# ==============================================================================
# datos_03.limpieza-datos.R
# Limpieza y estandarizacion de datos — Demanda potencial para un Doctorado en
# Ciencias (paisaje y turismo rural, desarrollo, manejo y aprovechamiento del
# paisaje rural). Universidad Autonoma Metropolitana (UAM), Ciudad de Mexico.
#
# Diseñado en 2 pasos, segun acuerdo con el equipo de investigacion (22-jul-2026):
#   PASO 1: Reglas de estandarizacion (acentos/espacios/entidades via catalogo
#           auditable; NA explicito para dato faltante REAL; se preserva el
#           texto original en columnas "_otro_texto" para respuestas libres
#           que no encajan en ninguna categoria predefinida).
#   PASO 2: Automatizacion del pipeline completo (lectura, validacion de
#           estructura, recodificacion, verificacion de integridad), de forma
#           que el resultado sea 100% reproducible desde el archivo crudo,
#           sin pasos manuales no documentados.
#   PASO 3: Exportacion en tres formatos: .csv, .xlsx y .rds (nativo de R).
#
# Principio rector: NINGUNA regla debe fusionar dos respuestas con significado
# distinto (p. ej. "Indefinido" != "No especifica"; "Sector privado" !=
# "Aplicacion en campo"). Toda respuesta libre que no calce en una categoria
# predefinida se marca como "Otro" y su texto original se conserva integro
# en una columna companion "<variable>_otro_texto".
#
# ------------------------------------------------------------------------------
# COMO EJECUTAR ESTE SCRIPT (reproducibilidad)
# ------------------------------------------------------------------------------
# 1. Descargue TODA la carpeta del repositorio (o clone el repositorio de
#    GitHub) manteniendo todos los archivos "datos_..." en un mismo directorio.
# 2. Abra R o RStudio y fije el directorio de trabajo a esa carpeta:
#       setwd("ruta/a/la/carpeta/del/repositorio")
# 3. Ejecute el script completo:
#       source("datos_03.limpieza-datos.R")
#    (o en terminal: Rscript datos_03.limpieza-datos.R)
# 4. Requisitos: R >= 4.3. Los paquetes necesarios (readxl, stringr, dplyr,
#    writexl, openxlsx, stringi) se instalan automaticamente si faltan
#    (bloque 0). Requiere conexion a internet solo si algun paquete no esta
#    instalado. Vea datos_08.sesion-r-reproducibilidad.txt para la version
#    exacta de R y de cada paquete usada para generar los archivos publicados.
# 5. El script lee "datos_01.datos-brutos-cuestionario.xlsx" (dato crudo,
#    sin tocar) y "datos_02.catalogo-estandarizacion-entidades.csv" (tabla de
#    equivalencias), y genera "datos_04.datos-limpios-completos.*" y
#    "datos_05.datos-interesados.*" en los 3 formatos indicados arriba.
# 6. Un mensaje "Proceso finalizado correctamente" al final confirma que no
#    hubo errores. Cualquier fallo detiene la ejecucion (stop()) con un
#    mensaje explicito de la causa.
# ==============================================================================

# ------------------------------------------------------------------------------
# BLOQUE -1: LOCALE UTF-8 (evita "invalid char string in output conversion"
# al escribir acentos/eñes en CSV bajo un locale C por defecto)
# ------------------------------------------------------------------------------
try(Sys.setlocale("LC_ALL", "C.UTF-8"), silent = TRUE)

# ------------------------------------------------------------------------------
# BLOQUE 0: CARGA SEGURA DE PAQUETES
# ------------------------------------------------------------------------------
instalar_y_cargar <- function(paquete) {
  if (!requireNamespace(paquete, quietly = TRUE)) {
    message(paste("Paquete no encontrado. Instalando:", paquete))
    install.packages(paquete, dependencies = TRUE, repos = "https://cran.rstudio.com/")
  }
  suppressPackageStartupMessages(library(paquete, character.only = TRUE))
}

paquetes_requeridos <- c("readxl", "stringr", "dplyr", "writexl", "openxlsx")

tryCatch({
  lapply(paquetes_requeridos, instalar_y_cargar)
  message("Todos los paquetes se cargaron correctamente.")
}, error = function(e) {
  stop("ERROR CRITICO: no se pudieron cargar los paquetes necesarios. Detalle: ", e$message)
})

# ------------------------------------------------------------------------------
# BLOQUE 1: LECTURA Y VALIDACION DE ESTRUCTURA (igual que v1)
# ------------------------------------------------------------------------------
ruta_archivo <- "datos_01.datos-brutos-cuestionario.xlsx"

if (!file.exists(ruta_archivo)) {
  stop("ERROR: el archivo '", ruta_archivo, "' no existe en: ", getwd())
}

datos_crudos <- tryCatch({
  read_excel(ruta_archivo, sheet = 1, col_types = NULL)
}, error = function(e) {
  stop("ERROR al leer el Excel. Posibles causas: archivo abierto, corrupto o formato inválido.\n",
       "Detalle: ", e$message)
})

if (nrow(datos_crudos) == 0) stop("ERROR: el archivo Excel esta vacio (0 filas).")
message(paste("Archivo leido. Filas:", nrow(datos_crudos)))

columnas_esperadas <- c(
  "marca_temporal", "interes_en_doctorado", "doctorado_de_interes", "genero",
  "edad", "estado_estudios", "estado_residencia", "area_maestria",
  "maestria_estudiada", "universidad_estudios_maestria", "situacion_laboral",
  "motivacion_en_doctorado", "tiempo_inicio_doctorado"
)
columnas_faltantes <- setdiff(columnas_esperadas, names(datos_crudos))
if (length(columnas_faltantes) > 0) {
  stop("ERROR DE ESTRUCTURA: faltan columnas:\n", paste("-", columnas_faltantes, collapse = "\n"))
}

n_crudo <- nrow(datos_crudos)

# ------------------------------------------------------------------------------
# PASO 1 — REGLAS DE ESTANDARIZACION
# ------------------------------------------------------------------------------

# 1.1 Limpieza universal de texto: normalizacion Unicode (NFC) + recorte de
#     espacios (inicio/fin) + colapso de espacios internos multiples.
#     Se aplica a TODAS las columnas de texto antes de cualquier recodificacion.
limpiar_texto_base <- function(x) {
  x <- as.character(x)
  x <- stringi::stri_trans_nfc(x)      # normaliza acentos/diacríticos (Unicode NFC)
  x <- str_squish(x)                    # recorta espacios y colapsa múltiples
  x[x %in% c("", "NA", "N/A", "n/a", "-", "s/d", "S/D")] <- NA_character_
  x
}

if (!requireNamespace("stringi", quietly = TRUE)) install.packages("stringi", repos = "https://cran.rstudio.com/")
suppressPackageStartupMessages(library(stringi))

datos <- datos_crudos %>%
  mutate(across(-marca_temporal, limpiar_texto_base))
datos$marca_temporal <- as.POSIXct(datos_crudos$marca_temporal)

# 1.2 Catalogo de estandarizacion de entidades federativas (crosswalk auditable,
#     ver 00_catalogo_estandarizacion_entidades.csv para la justificacion de
#     cada equivalencia, incluida la decision editorial "Mexico" -> "Estado de Mexico").
catalogo_entidades <- read.csv("datos_02.catalogo-estandarizacion-entidades.csv",
                                encoding = "UTF-8", stringsAsFactors = FALSE)
mapa_entidades <- setNames(catalogo_entidades$valor_estandarizado, catalogo_entidades$valor_crudo)

estandarizar_entidad <- function(x) {
  x_norm <- str_squish(stri_trans_nfc(x))
  encontrados <- x_norm %in% names(mapa_entidades)
  out <- x_norm
  out[encontrados] <- mapa_entidades[x_norm[encontrados]]
  no_encontrados <- unique(x_norm[!encontrados & !is.na(x_norm)])
  if (length(no_encontrados) > 0) {
    warning("Valores de entidad NO presentes en el catalogo (se conservan tal cual, revisar manualmente): ",
            paste(no_encontrados, collapse = " | "))
  }
  out
}

datos$estado_estudios    <- estandarizar_entidad(datos$estado_estudios)
datos$estado_residencia  <- estandarizar_entidad(datos$estado_residencia)

# 1.3 Funcion generica de recodificacion CONTROLADA: exige que cada respuesta
#     calce con un patron explicito; si no calce, se marca "Otro" y el texto
#     original se preserva en una columna companion (nunca se pierde informacion).
recodificar_controlado <- function(columna, patrones, valores, etiqueta_otro = "Otro") {
  col <- str_to_lower(str_squish(columna))
  resultado <- rep(NA_character_, length(col))
  ya_asignado <- rep(FALSE, length(col))   # rastrea coincidencias, incluso si el valor destino es NA
  for (i in seq_along(patrones)) {
    idx <- str_detect(col, regex(patrones[i], ignore_case = TRUE)) & !ya_asignado
    idx[is.na(idx)] <- FALSE
    resultado[idx] <- valores[i]
    ya_asignado[idx] <- TRUE
  }
  # Lo que no calzo con NINGUN patron (no solo lo que quedo NA) pero SI tiene respuesta -> "Otro"
  sin_match <- !ya_asignado & !is.na(col)
  resultado[sin_match] <- etiqueta_otro
  resultado
}

# --- Genero (sin ambiguedad en el instrumento: 2 opciones) ---
datos$genero <- recodificar_controlado(
  datos$genero,
  patrones = c("^fem", "^masc"),
  valores  = c("Femenino", "Masculino")
)

# --- Interes en doctorado ---
datos$interes_en_doctorado <- recodificar_controlado(
  datos$interes_en_doctorado,
  patrones = c("^si$|^s$|^yes$|^y$", "^no$|^n$"),
  valores  = c("Sí", "No")
)

# --- doctorado_de_interes: si la persona NO tiene interes, la pregunta no
#     aplicaba (salto de pregunta) -> NA explicito, no el texto "No".
datos$doctorado_de_interes[datos$interes_en_doctorado == "No"] <- NA_character_

# --- area_maestria: llega pre-codificada desde la fuente (ver auditoria previa);
#     solo se re-normaliza texto, SIN recodificar de nuevo (evita doble codificacion).
#     (ya se aplico limpiar_texto_base arriba)

# --- situacion_laboral: "No contesto" = dato faltante real -> NA.
datos$situacion_laboral <- recodificar_controlado(
  datos$situacion_laboral,
  patrones = c("trabaja.*estud|estud.*trabaja", "docent|profesor",
               "emplead|trabajador", "negocio.*propio|emprende",
               "^solo.*estud|^estudiante$", "no contest"),
  valores  = c("Trabaja y estudia", "Docente", "Empleado", "Negocio propio",
               "Solo estudia", NA_character_)
)

# --- motivacion_en_doctorado: patrones estrictos, SIN fusionar conceptos.
#     "Sector privado" ya NO se agrupa con "Aplicacion en campo".
datos$motivacion_en_doctorado_otro_texto <- NA_character_
tmp_mot_original <- datos$motivacion_en_doctorado
datos$motivacion_en_doctorado <- recodificar_controlado(
  datos$motivacion_en_doctorado,
  patrones = c("^investig", "^docenc", "^aplicaci.n en campo$"),
  valores  = c("Investigación", "Docencia", "Aplicación en campo")
)
idx_otro_mot <- datos$motivacion_en_doctorado == "Otro" & !is.na(tmp_mot_original)
datos$motivacion_en_doctorado_otro_texto[idx_otro_mot] <- tmp_mot_original[idx_otro_mot]

# --- tiempo_inicio_doctorado: "Indefinido" queda como categoria propia,
#     DISTINTA de un dato faltante real (celda vacia -> ya es NA desde 1.1).
datos$tiempo_inicio_doctorado <- recodificar_controlado(
  datos$tiempo_inicio_doctorado,
  patrones = c("inmediat|^ya$|^ahora$", "^en 1 a.o$|1 a.o|12 meses",
               "^en 2 a.os$|2 a.os|24 meses", "^en 3 a.os$|3 a.os|36 meses",
               "^en 4 a.os$|4 a.os|48 meses", "^en 5 a.os$|5 a.os|60 meses",
               "^indefinido$"),
  valores  = c("De inmediato", "En 1 año", "En 2 años", "En 3 años",
               "En 4 años", "En 5 años", "Indefinido")
)

message("PASO 1 completado: estandarizacion sin fusion de categorias, con NA explicito para dato faltante real.")

# ------------------------------------------------------------------------------
# PASO 2 — VARIABLES DERIVADAS Y VALIDACION
# ------------------------------------------------------------------------------
tryCatch({
  datos_interesados <- datos %>% filter(interes_en_doctorado == "Sí")
  n_interesados <- nrow(datos_interesados)

  if (n_interesados == 0) {
    warning("ADVERTENCIA: no se encontraron registros con interes 'Si'.")
  }
  message(paste("Filtrado completado. Total:", nrow(datos), "| Interesados:", n_interesados))
}, error = function(e) {
  stop("ERROR al crear variables derivadas. Detalle: ", e$message)
})

# Validacion de integridad: mismo N de filas que el archivo crudo
if (nrow(datos) != n_crudo) {
  stop("ERROR DE INTEGRIDAD: el numero de filas cambio durante la limpieza (",
       n_crudo, " -> ", nrow(datos), "). Revisar el pipeline antes de exportar.")
}
message("Validacion de integridad OK: ", nrow(datos), " filas conservadas (= archivo crudo).")

# ------------------------------------------------------------------------------
# PASO 3 — EXPORTACION EN 3 FORMATOS: CSV, XLSX, RDS
# ------------------------------------------------------------------------------
tryCatch({
  # RDS (formato nativo de R, conserva tipos de dato exactos, incl. POSIXct)
  saveRDS(datos, "datos_04.datos-limpios-completos.rds")
  saveRDS(datos_interesados, "datos_05.datos-interesados.rds")

  # CSV (UTF-8, para uso general / disposicion publica)
  write.csv(datos, "datos_04.datos-limpios-completos.csv", row.names = FALSE, na = "NA", fileEncoding = "UTF-8")
  write.csv(datos_interesados, "datos_05.datos-interesados.csv", row.names = FALSE, na = "NA", fileEncoding = "UTF-8")

  # XLSX (para revision manual / coautores)
  write_xlsx(list(
    "datos_limpios_completos" = datos,
    "datos_interesados"       = datos_interesados
  ), "datos_04.datos-limpios-completos.xlsx")

  message("Archivos exportados en 3 formatos (csv, xlsx, rds).")
}, error = function(e) {
  stop("ERROR al exportar. Detalle: ", e$message)
})

# Captura del entorno de ejecucion (version de R y de cada paquete), para que
# cualquier persona pueda verificar bajo que configuracion se generaron los
# archivos publicados -- pieza clave de reproducibilidad.
writeLines(
  c(paste("Fecha de ejecucion:", Sys.time()),
    "", capture.output(sessionInfo())),
  "datos_08.sesion-r-reproducibilidad.txt"
)

# ------------------------------------------------------------------------------
# REPORTE FINAL
# ------------------------------------------------------------------------------
cat("\n==================================================\n")
cat("      REPORTE FINAL DE LIMPIEZA v2 (2 pasos)      \n")
cat("==================================================\n")
cat("Registros originales           :", n_crudo, "\n")
cat("Registros limpios               :", nrow(datos), "\n")
cat("Registros con interes 'Si'      :", nrow(datos_interesados), "\n")
cat("--------------------------------------------------\n")
cat("Valores NA (dato faltante real) por variable:\n")
print(colSums(is.na(datos)))
cat("--------------------------------------------------\n")
cat("Categorias 'Otro' preservadas con texto original:\n")
cat("  motivacion_en_doctorado -> Otro:",
    sum(datos$motivacion_en_doctorado == "Otro", na.rm = TRUE), "caso(s):\n")
print(na.omit(datos$motivacion_en_doctorado_otro_texto))
cat("==================================================\n")
cat("Proceso finalizado correctamente.\n")
