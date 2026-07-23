#!/usr/bin/env bash
# ==============================================================================
# datos_09.instalar-entorno-ubuntu.sh
# Instalación a prueba de fallas del entorno R necesario para ejecutar
# datos_03.limpieza-datos.R, en Ubuntu 24.04 LTS (Noble Numbat).
#
# Diseño "a prueba de fallas" (mismo espíritu que el script de limpieza en R):
#   - Nunca se detiene ante el primer error: cada paso se intenta, se reporta
#     su resultado (OK / FALLO) y el script continúa con el siguiente paso.
#   - Cada paquete de R se intenta primero vía el repositorio de Ubuntu
#     (rápido, sin compilar); si no está disponible o falla, se reintenta
#     automáticamente instalándolo desde CRAN dentro de R.
#   - Al final se hace una verificación real (cargar cada paquete en R) y se
#     imprime un resumen; el script solo termina con código de error (exit 1)
#     si algo queda realmente roto después de todos los reintentos.
#   - Es seguro volver a ejecutarlo (idempotente): si ya todo está instalado,
#     lo detecta y no reinstala nada innecesariamente.
#
# Uso:
#   chmod +x datos_09.instalar-entorno-ubuntu.sh
#   ./datos_09.instalar-entorno-ubuntu.sh
#   (o: bash datos_09.instalar-entorno-ubuntu.sh)
# ==============================================================================

set -u  # variables no definidas son error; NO usamos "set -e" a propósito,
        # porque este script debe seguir adelante y reportar fallos, no abortar.

OK="[OK]"
FAIL="[FALLO]"
WARN="[AVISO]"
RESUMEN=()          # aquí se acumula el resultado de cada paso
HUBO_FALLO_CRITICO=0

log()  { printf '%s\n' "$1"; }
paso() { printf '\n--- %s ---\n' "$1"; }

registrar() {
  # registrar "<etiqueta>" "<OK|FALLO|AVISO>"
  RESUMEN+=("$2 $1")
}

# ------------------------------------------------------------------------------
# 0. Verificaciones previas (SO, privilegios, red)
# ------------------------------------------------------------------------------
paso "0. Verificaciones previas"

if [ -r /etc/os-release ]; then
  . /etc/os-release
  log "Sistema detectado: ${PRETTY_NAME:-desconocido}"
  if [ "${ID:-}" != "ubuntu" ]; then
    log "$WARN Este script está pensado para Ubuntu; se detectó ID='${ID:-desconocido}'."
    log "     Puede continuar, pero considere usar datos_09.instalar-entorno-fedora.sh si está en Fedora."
  fi
else
  log "$WARN No se pudo leer /etc/os-release; se continúa de todas formas."
fi

SUDO=""
if [ "$(id -u)" -ne 0 ]; then
  if command -v sudo >/dev/null 2>&1; then
    SUDO="sudo"
    log "Se usará 'sudo' para instalar paquetes del sistema."
  else
    log "$FAIL No se es root y 'sudo' no está disponible. No se pueden instalar paquetes del sistema."
    registrar "Privilegios de instalación" "FALLO"
    HUBO_FALLO_CRITICO=1
  fi
else
  log "Ejecutando como root; no se requiere 'sudo'."
fi

if command -v curl >/dev/null 2>&1; then
  if curl -sSf --max-time 8 https://cran.r-project.org >/dev/null 2>&1; then
    log "Conexión a CRAN (cran.r-project.org): OK"
    registrar "Conexión a internet / CRAN" "OK"
  else
    log "$WARN No se pudo alcanzar CRAN en este momento. Los pasos que dependan de la red podrían fallar; se reintentará cada uno de todas formas."
    registrar "Conexión a internet / CRAN" "AVISO"
  fi
else
  log "$WARN 'curl' no está instalado; se omite la verificación de red."
fi

# ------------------------------------------------------------------------------
# 1. Actualizar índices de paquetes (no crítico si falla: se continúa)
# ------------------------------------------------------------------------------
paso "1. Actualizando índices de apt"
if $SUDO apt-get update -qq; then
  log "$OK Índices de apt actualizados."
  registrar "apt-get update" "OK"
else
  log "$WARN 'apt-get update' falló o hubo repositorios inalcanzables. Se continúa con los índices existentes."
  registrar "apt-get update" "AVISO"
fi

# ------------------------------------------------------------------------------
# 2. Instalar R base (r-base-core) si falta
# ------------------------------------------------------------------------------
paso "2. Instalando R (r-base-core)"
if command -v Rscript >/dev/null 2>&1; then
  log "$OK R ya está instalado: $(Rscript --version 2>&1)"
  registrar "R (r-base-core)" "OK"
else
  if $SUDO apt-get install -y -qq r-base-core; then
    log "$OK R instalado correctamente."
    registrar "R (r-base-core)" "OK"
  else
    log "$FAIL No se pudo instalar r-base-core. El resto del script no podrá continuar de forma útil."
    registrar "R (r-base-core)" "FALLO"
    HUBO_FALLO_CRITICO=1
  fi
fi

# ------------------------------------------------------------------------------
# 3. Librerías de sistema necesarias para compilar paquetes de R desde CRAN
#    (fallback usado en el paso 5 si el paquete Ubuntu no está disponible)
# ------------------------------------------------------------------------------
paso "3. Instalando dependencias de compilación (fallback para CRAN)"
LIBS_SISTEMA="build-essential gfortran libcurl4-openssl-dev libssl-dev libxml2-dev libicu-dev"
if $SUDO apt-get install -y -qq $LIBS_SISTEMA; then
  log "$OK Dependencias de compilación instaladas ($LIBS_SISTEMA)."
  registrar "Dependencias de compilación" "OK"
else
  log "$WARN No se pudieron instalar todas las dependencias de compilación. Si algún paquete de R necesita compilarse desde CRAN, podría fallar más adelante; se informará en ese caso."
  registrar "Dependencias de compilación" "AVISO"
fi

# ------------------------------------------------------------------------------
# 4. Paquetes de R vía apt (r-cran-*): rápido, precompilado, sin tocar CRAN
# ------------------------------------------------------------------------------
paso "4. Instalando paquetes de R vía apt (r-cran-*)"
# Mapeo nombre-de-paquete-R -> nombre-de-paquete-apt en Ubuntu 24.04 (universe)
declare -A APT_PKG=(
  [readxl]="r-cran-readxl"
  [stringr]="r-cran-stringr"
  [dplyr]="r-cran-dplyr"
  [writexl]="r-cran-writexl"
  [openxlsx]="r-cran-openxlsx"
  [stringi]="r-cran-stringi"
)

PAQUETES_PENDIENTES=()   # los que no se logren instalar vía apt, van a fallback CRAN (paso 5)

for pkg in "${!APT_PKG[@]}"; do
  apt_name="${APT_PKG[$pkg]}"
  if $SUDO apt-get install -y -qq "$apt_name" 2>/dev/null; then
    log "$OK $pkg  (paquete apt: $apt_name)"
  else
    log "$WARN No se pudo instalar '$apt_name' vía apt. Se reintentará desde CRAN en el paso 5."
    PAQUETES_PENDIENTES+=("$pkg")
  fi
done

# ------------------------------------------------------------------------------
# 5. Verificación real + fallback a CRAN para lo que haya quedado pendiente
#    (se hace TODO dentro de una sola llamada a R, con manejo de errores
#    por paquete, replicando el patrón tryCatch del script de limpieza)
# ------------------------------------------------------------------------------
paso "5. Verificación final en R (con reintento automático desde CRAN si hace falta)"

if command -v Rscript >/dev/null 2>&1; then
  Rscript --vanilla -e '
    paquetes <- c("readxl", "stringr", "dplyr", "writexl", "openxlsx", "stringi")
    resultado <- data.frame(paquete = paquetes, estado = NA_character_)

    for (i in seq_along(paquetes)) {
      p <- paquetes[i]
      ok <- requireNamespace(p, quietly = TRUE)
      if (!ok) {
        message("Intentando instalar '", p, "' desde CRAN (fallback)...")
        intento <- tryCatch({
          install.packages(p, repos = "https://cran.r-project.org")
          requireNamespace(p, quietly = TRUE)
        }, error = function(e) FALSE, warning = function(w) FALSE)
        ok <- isTRUE(intento)
      }
      resultado$estado[i] <- if (ok) "OK" else "FALLO"
    }

    cat("\n--- Verificación de paquetes de R ---\n")
    for (i in seq_len(nrow(resultado))) {
      cat(sprintf("[%s] %s\n", resultado$estado[i], resultado$paquete[i]))
    }

    if (any(resultado$estado == "FALLO")) {
      cat("\nHubo paquetes que no se pudieron instalar por ningún medio. Revise su conexión a internet o instale manualmente con install.packages().\n")
      quit(status = 1)
    } else {
      cat("\nTodos los paquetes necesarios están disponibles.\n")
      quit(status = 0)
    }
  '
  ESTADO_R=$?
  if [ "$ESTADO_R" -eq 0 ]; then
    registrar "Paquetes de R (readxl, stringr, dplyr, writexl, openxlsx, stringi)" "OK"
  else
    registrar "Paquetes de R (readxl, stringr, dplyr, writexl, openxlsx, stringi)" "FALLO"
    HUBO_FALLO_CRITICO=1
  fi
else
  log "$FAIL Rscript no está disponible; no se puede verificar ni instalar paquetes de R."
  registrar "Verificación de paquetes de R" "FALLO"
  HUBO_FALLO_CRITICO=1
fi

# ------------------------------------------------------------------------------
# 6. LibreOffice + pandoc (opcionales: solo si se quieren regenerar los .docx/
#    .xlsx renderizados de este repositorio; el script de limpieza NO los necesita)
# ------------------------------------------------------------------------------
paso "6. (Opcional) LibreOffice y pandoc, para regenerar documentos renderizados"
if $SUDO apt-get install -y -qq libreoffice-core pandoc 2>/dev/null; then
  log "$OK LibreOffice y pandoc instalados (opcional, no requerido por datos_03.limpieza-datos.R)."
  registrar "LibreOffice + pandoc (opcional)" "OK"
else
  log "$WARN No se instalaron LibreOffice/pandoc. No afecta la limpieza de datos; solo sería necesario si desea regenerar los documentos .docx/.xlsx renderizados manualmente."
  registrar "LibreOffice + pandoc (opcional)" "AVISO"
fi

# ------------------------------------------------------------------------------
# 7. (Opcional) RStudio Desktop
#    Se descarga el build "jammy" (Ubuntu 22.04), que Posit mantiene compatible
#    también con Ubuntu 24.04 "Noble" por retrocompatibilidad de las LTS.
#    Se usa el enlace de redirección "stable" de Posit, que siempre apunta a la
#    versión estable vigente sin necesidad de conocer el número de versión de
#    antemano (ver datos_09.instrucciones-entorno-windows-linux.md, sección D).
# ------------------------------------------------------------------------------
paso "7. (Opcional) Instalando RStudio Desktop"
URL_RSTUDIO="https://rstudio.org/download/latest/stable/desktop/jammy/rstudio-latest-amd64.deb"
DEB_TMP="$(mktemp --suffix=.deb)"

if command -v rstudio >/dev/null 2>&1; then
  log "$OK RStudio ya está instalado: $(command -v rstudio)"
  registrar "RStudio Desktop (opcional)" "OK"
else
  DESCARGA_OK=0
  for intento in 1 2 3; do
    log "Descargando RStudio Desktop (intento $intento de 3)..."
    if command -v wget >/dev/null 2>&1 && wget -q --timeout=60 -O "$DEB_TMP" "$URL_RSTUDIO"; then
      DESCARGA_OK=1
      break
    elif command -v curl >/dev/null 2>&1 && curl -sSL --max-time 60 -o "$DEB_TMP" "$URL_RSTUDIO"; then
      DESCARGA_OK=1
      break
    fi
    log "$WARN Intento $intento fallido, reintentando..."
    sleep 2
  done

  if [ "$DESCARGA_OK" -eq 1 ] && [ -s "$DEB_TMP" ] && file "$DEB_TMP" | grep -qi "debian binary package"; then
    if $SUDO apt-get install -y -q "$DEB_TMP"; then
      log "$OK RStudio Desktop instalado: $(rstudio --version 2>&1 | head -1)"
      registrar "RStudio Desktop (opcional)" "OK"
    else
      log "$WARN El .deb se descargó pero 'apt-get install' falló (posible conflicto de dependencias). RStudio no es necesario para correr datos_03.limpieza-datos.R; puede instalarlo manualmente más tarde."
      registrar "RStudio Desktop (opcional)" "AVISO"
    fi
  else
    log "$WARN No se pudo descargar un .deb válido de RStudio tras 3 intentos (revise su conexión a $URL_RSTUDIO). Esto NO afecta la limpieza de datos, que solo requiere Rscript; puede instalar RStudio manualmente después. Ver datos_09.instrucciones-entorno-windows-linux.md, sección D."
    registrar "RStudio Desktop (opcional)" "AVISO"
  fi
  rm -f "$DEB_TMP"
fi

# ------------------------------------------------------------------------------
# RESUMEN FINAL
# ------------------------------------------------------------------------------
paso "RESUMEN"
for linea in "${RESUMEN[@]}"; do
  log "$linea"
done

echo ""
if [ "$HUBO_FALLO_CRITICO" -eq 0 ]; then
  echo "Entorno listo. Para correr la limpieza de datos:"
  echo "  cd ruta/a/este/repositorio"
  echo "  Rscript datos_03.limpieza-datos.R"
  echo "Para abrir RStudio (si se instaló): rstudio &"
  exit 0
else
  echo "Hubo al menos un fallo crítico (ver arriba). Revise los mensajes [FALLO] antes de ejecutar datos_03.limpieza-datos.R."
  exit 1
fi
