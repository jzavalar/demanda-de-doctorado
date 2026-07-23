#!/usr/bin/env bash
# ==============================================================================
# datos_09.instalar-entorno-fedora.sh
# Instalación a prueba de fallas del entorno R necesario para ejecutar
# datos_03.limpieza-datos.R, en Fedora Linux 44.
#
# Mismo diseño "a prueba de fallas" que datos_09.instalar-entorno-ubuntu.sh:
#   - Ningún paso detiene el script; cada uno se reporta OK / AVISO / FALLO
#     y se continúa con el siguiente.
#   - Cada paquete de R se intenta primero como RPM de Fedora (R-<paquete>,
#     precompilado); si el nombre no existe en los repos de Fedora o la
#     instalación falla, se reintenta automáticamente compilándolo desde
#     CRAN dentro de R (para eso se instalan antes las dependencias de
#     compilación). Esto protege el script ante cambios de nombre de paquete
#     entre versiones de Fedora.
#   - Verificación final real (cargar cada paquete en R) antes de declarar
#     éxito; solo se sale con código de error si algo sigue roto.
#   - Idempotente: se puede ejecutar varias veces sin causar daño.
#
# Uso:
#   chmod +x datos_09.instalar-entorno-fedora.sh
#   ./datos_09.instalar-entorno-fedora.sh
#   (o: bash datos_09.instalar-entorno-fedora.sh)
#
# Nota: Fedora 41 en adelante usa dnf5 como gestor de paquetes por defecto;
# el binario 'dnf' sigue funcionando (es compatible) y es el que usa este
# script. Si su sistema solo tuviera 'dnf5' como nombre de binario, el script
# lo detecta y lo usa igual.
# ==============================================================================

set -u  # variables no definidas son error; NO usamos "set -e" a propósito:
        # el script debe seguir adelante, reportar y reintentar, no abortar.

OK="[OK]"
FAIL="[FALLO]"
WARN="[AVISO]"
RESUMEN=()
HUBO_FALLO_CRITICO=0

log()  { printf '%s\n' "$1"; }
paso() { printf '\n--- %s ---\n' "$1"; }
registrar() { RESUMEN+=("$2 $1"); }

# Detectar el binario de dnf disponible (dnf o dnf5)
DNF_BIN=""
if command -v dnf >/dev/null 2>&1; then
  DNF_BIN="dnf"
elif command -v dnf5 >/dev/null 2>&1; then
  DNF_BIN="dnf5"
fi

# ------------------------------------------------------------------------------
# 0. Verificaciones previas (SO, privilegios, red, gestor de paquetes)
# ------------------------------------------------------------------------------
paso "0. Verificaciones previas"

if [ -r /etc/os-release ]; then
  . /etc/os-release
  log "Sistema detectado: ${PRETTY_NAME:-desconocido}"
  if [ "${ID:-}" != "fedora" ]; then
    log "$WARN Este script está pensado para Fedora; se detectó ID='${ID:-desconocido}'."
    log "     Puede continuar, pero considere usar datos_09.instalar-entorno-ubuntu.sh si está en Ubuntu/Debian."
  fi
else
  log "$WARN No se pudo leer /etc/os-release; se continúa de todas formas."
fi

if [ -z "$DNF_BIN" ]; then
  log "$FAIL No se encontró 'dnf' ni 'dnf5' en este sistema. No se pueden instalar paquetes."
  registrar "Gestor de paquetes (dnf/dnf5)" "FALLO"
  HUBO_FALLO_CRITICO=1
else
  log "Gestor de paquetes detectado: $DNF_BIN"
  registrar "Gestor de paquetes (dnf/dnf5)" "OK"
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
    log "$WARN No se pudo alcanzar CRAN en este momento. Se reintentará cada paso que dependa de la red de todas formas."
    registrar "Conexión a internet / CRAN" "AVISO"
  fi
else
  log "$WARN 'curl' no está instalado; se omite la verificación de red."
fi

# ------------------------------------------------------------------------------
# 1. Actualizar caché de metadatos de dnf (no crítico si falla)
# ------------------------------------------------------------------------------
paso "1. Actualizando metadatos de dnf"
if [ -n "$DNF_BIN" ]; then
  if $SUDO "$DNF_BIN" makecache -q; then
    log "$OK Metadatos de dnf actualizados."
    registrar "$DNF_BIN makecache" "OK"
  else
    log "$WARN No se pudo actualizar el caché de dnf. Se continúa con el caché existente."
    registrar "$DNF_BIN makecache" "AVISO"
  fi
fi

# ------------------------------------------------------------------------------
# 2. Instalar R (paquete meta 'R') si falta
# ------------------------------------------------------------------------------
paso "2. Instalando R (paquete 'R')"
if command -v Rscript >/dev/null 2>&1; then
  log "$OK R ya está instalado: $(Rscript --version 2>&1)"
  registrar "R (paquete 'R')" "OK"
else
  if [ -n "$DNF_BIN" ] && $SUDO "$DNF_BIN" install -y -q R; then
    log "$OK R instalado correctamente."
    registrar "R (paquete 'R')" "OK"
  else
    log "$FAIL No se pudo instalar el paquete 'R'. El resto del script no podrá continuar de forma útil."
    registrar "R (paquete 'R')" "FALLO"
    HUBO_FALLO_CRITICO=1
  fi
fi

# ------------------------------------------------------------------------------
# 3. Dependencias de compilación (fallback para instalar paquetes desde CRAN
#    si el RPM de Fedora correspondiente no existe o falla)
# ------------------------------------------------------------------------------
paso "3. Instalando dependencias de compilación (fallback para CRAN)"
LIBS_SISTEMA="gcc gcc-c++ gcc-gfortran make libcurl-devel openssl-devel libxml2-devel libicu-devel"
if [ -n "$DNF_BIN" ] && $SUDO "$DNF_BIN" install -y -q $LIBS_SISTEMA; then
  log "$OK Dependencias de compilación instaladas ($LIBS_SISTEMA)."
  registrar "Dependencias de compilación" "OK"
else
  log "$WARN No se pudieron instalar todas las dependencias de compilación. Si algún paquete de R necesita compilarse desde CRAN, podría fallar más adelante; se informará en ese caso."
  registrar "Dependencias de compilación" "AVISO"
fi

# ------------------------------------------------------------------------------
# 4. Paquetes de R vía dnf (R-<paquete>): rápido, precompilado, sin tocar CRAN
# ------------------------------------------------------------------------------
paso "4. Instalando paquetes de R vía dnf (R-<paquete>)"
declare -A DNF_PKG=(
  [readxl]="R-readxl"
  [stringr]="R-stringr"
  [dplyr]="R-dplyr"
  [writexl]="R-writexl"
  [openxlsx]="R-openxlsx"
  [stringi]="R-stringi"
)

for pkg in "${!DNF_PKG[@]}"; do
  dnf_name="${DNF_PKG[$pkg]}"
  if [ -n "$DNF_BIN" ] && $SUDO "$DNF_BIN" install -y -q "$dnf_name" 2>/dev/null; then
    log "$OK $pkg  (paquete dnf: $dnf_name)"
  else
    log "$WARN No se pudo instalar '$dnf_name' vía dnf (puede que el nombre exacto del RPM difiera en su versión de Fedora). Se reintentará desde CRAN en el paso 5."
  fi
done

# ------------------------------------------------------------------------------
# 5. Verificación real + fallback a CRAN para lo que haya quedado pendiente
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
# 6. (Opcional) LibreOffice + pandoc, para regenerar documentos renderizados
# ------------------------------------------------------------------------------
paso "6. (Opcional) LibreOffice y pandoc, para regenerar documentos renderizados"
if [ -n "$DNF_BIN" ] && $SUDO "$DNF_BIN" install -y -q libreoffice-writer libreoffice-calc pandoc 2>/dev/null; then
  log "$OK LibreOffice y pandoc instalados (opcional, no requerido por datos_03.limpieza-datos.R)."
  registrar "LibreOffice + pandoc (opcional)" "OK"
else
  log "$WARN No se instalaron LibreOffice/pandoc. No afecta la limpieza de datos; solo sería necesario si desea regenerar manualmente los documentos .docx/.xlsx renderizados."
  registrar "LibreOffice + pandoc (opcional)" "AVISO"
fi

# ------------------------------------------------------------------------------
# 7. (Opcional) RStudio Desktop vía el repositorio Copr comunitario iucar/rstudio
#    https://copr.fedorainfracloud.org/coprs/iucar/rstudio/
#    Nota: este paquete ('rstudio-desktop') es distinto y NO compatible con el
#    RPM oficial de Posit ('rstudio'); no mezclar ambos métodos en la misma
#    máquina.
# ------------------------------------------------------------------------------
paso "7. (Opcional) Instalando RStudio Desktop vía Copr (iucar/rstudio)"

if command -v rstudio >/dev/null 2>&1; then
  log "$OK RStudio ya está instalado: $(command -v rstudio)"
  registrar "RStudio Desktop (Copr iucar/rstudio, opcional)" "OK"
elif [ -z "$DNF_BIN" ]; then
  log "$WARN No hay gestor dnf disponible; se omite la instalación de RStudio."
  registrar "RStudio Desktop (Copr iucar/rstudio, opcional)" "AVISO"
else
  # El subcomando 'copr' requiere el plugin correspondiente. En dnf5 (Fedora
  # 41+) se llama 'dnf5-plugins'; en dnf clásico, 'dnf-plugins-core'. Se
  # intenta primero sin instalar nada (puede que ya esté disponible) y solo
  # se instala el plugin si el subcomando falla.
  if ! $SUDO "$DNF_BIN" copr --help >/dev/null 2>&1; then
    log "El subcomando 'copr' no está disponible; instalando el plugin necesario..."
    if ! $SUDO "$DNF_BIN" install -y -q dnf5-plugins 2>/dev/null; then
      $SUDO "$DNF_BIN" install -y -q dnf-plugins-core 2>/dev/null
    fi
  fi

  if $SUDO "$DNF_BIN" copr --help >/dev/null 2>&1; then
    if $SUDO "$DNF_BIN" copr enable -y iucar/rstudio; then
      log "$OK Repositorio Copr iucar/rstudio habilitado."
      if $SUDO "$DNF_BIN" install -y -q rstudio-desktop; then
        log "$OK RStudio Desktop instalado: $(rstudio --version 2>&1 | head -1)"
        registrar "RStudio Desktop (Copr iucar/rstudio, opcional)" "OK"
      else
        log "$WARN El repositorio se habilitó pero 'dnf install rstudio-desktop' falló. RStudio no es necesario para correr datos_03.limpieza-datos.R; puede reintentarlo manualmente después."
        registrar "RStudio Desktop (Copr iucar/rstudio, opcional)" "AVISO"
      fi
    else
      log "$WARN No se pudo habilitar el repositorio Copr iucar/rstudio (revise su conexión a copr.fedorainfracloud.org). Esto NO afecta la limpieza de datos, que solo requiere Rscript."
      registrar "RStudio Desktop (Copr iucar/rstudio, opcional)" "AVISO"
    fi
  else
    log "$WARN No se pudo habilitar el subcomando 'copr' de dnf (falta el plugin y no se pudo instalar). Se omite RStudio; vea datos_09.instrucciones-entorno-windows-linux.md, sección D, para instalarlo manualmente."
    registrar "RStudio Desktop (Copr iucar/rstudio, opcional)" "AVISO"
  fi
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
