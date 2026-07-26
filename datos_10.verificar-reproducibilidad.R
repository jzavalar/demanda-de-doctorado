# ==============================================================================
# datos_10.verificar-reproducibilidad.R
# Compara los archivos de datos limpios "clonados" (los que vienen publicados
# en el repositorio) contra los que genera datos_03.limpieza-datos.R al
# correrlo de nuevo, para confirmar que el pipeline es 100% reproducible.
#
# CÓMO USAR ESTE SCRIPT
# ----------------------
# 1. Recién clonado/descargado el repositorio (ANTES de correr
#    datos_03.limpieza-datos.R más de una vez), ejecute:
#       source("datos_10.verificar-reproducibilidad.R")
#    Esto:
#      a) Guarda una copia de los datos_04.*/datos_05.* actuales (los
#         "clonados", tal como venían publicados) en la carpeta
#         _verificacion_manual/clonado/
#      b) Vuelve a correr datos_03.limpieza-datos.R (esto SOBREESCRIBE
#         datos_04.*/datos_05.* con una versión recién generada)
#      c) Compara, campo por campo (no solo byte a byte, para no dar falsos
#         positivos por metadatos internos de los .xlsx), la copia guardada
#         contra la versión recién generada
#      d) Imprime un reporte [OK]/[DIFERENCIAS] por archivo
#
# 2. Si ya había corrido datos_03.limpieza-datos.R antes y no tiene la
#    versión "clonada" original a la mano, este script igual sirve como
#    PRUEBA DE DETERMINISMO: compara la última corrida contra una corrida
#    nueva. Si el resultado es [OK] en los 5 archivos, el script es
#    reproducible (siempre da el mismo resultado a partir del mismo dato
#    crudo), que es la propiedad que realmente importa para la revista.
#
# 3. La carpeta _verificacion_manual/ es solo un área de trabajo temporal de
#    este script de verificación; no forma parte de los datos publicados y
#    puede borrarse sin problema en cualquier momento.
# ==============================================================================

cat("==================================================\n")
cat("   VERIFICACION DE REPRODUCIBILIDAD (datos_10)     \n")
cat("==================================================\n\n")

archivos_a_comparar <- c(
  "datos_04.datos-limpios-completos.csv",
  "datos_04.datos-limpios-completos.rds",
  "datos_04.datos-limpios-completos.xlsx",
  "datos_05.datos-interesados.csv",
  "datos_05.datos-interesados.rds"
)

dir_clonado <- file.path("_verificacion_manual", "clonado")
dir.create(dir_clonado, recursive = TRUE, showWarnings = FALSE)

# ------------------------------------------------------------------------------
# PASO 1: Guardar una copia de los archivos actuales ("clonados") ANTES de
# sobreescribirlos, si todavía no existe una copia previa guardada.
# ------------------------------------------------------------------------------
ya_habia_copia <- all(file.exists(file.path(dir_clonado, archivos_a_comparar)))

if (ya_habia_copia) {
  cat("Ya existe una copia guardada en '", dir_clonado, "' de una verificacion\n", sep = "")
  cat("anterior; se usara esa como referencia 'clonada'. Si prefiere comparar\n")
  cat("contra el estado actual de los archivos, borre esa carpeta y vuelva a\n")
  cat("correr este script antes de ejecutar datos_03.limpieza-datos.R de nuevo.\n\n")
} else {
  faltantes <- archivos_a_comparar[!file.exists(archivos_a_comparar)]
  if (length(faltantes) > 0) {
    stop("ERROR: no se encontraron estos archivos en el directorio actual: ",
         paste(faltantes, collapse = ", "),
         "\nAsegurese de ejecutar este script desde la carpeta del repositorio.")
  }
  invisible(file.copy(archivos_a_comparar, dir_clonado, overwrite = TRUE))
  cat("Copia de los archivos 'clonados' guardada en '", dir_clonado, "'.\n\n", sep = "")
}

# ------------------------------------------------------------------------------
# PASO 2: Volver a generar los archivos desde datos_01/datos_02 corriendo el
# script de limpieza (sobreescribe datos_04.*/datos_05.* en el directorio).
# ------------------------------------------------------------------------------
cat("Ejecutando datos_03.limpieza-datos.R para regenerar los archivos...\n\n")
if (!file.exists("datos_03.limpieza-datos.R")) {
  stop("ERROR: no se encontro datos_03.limpieza-datos.R en el directorio actual.")
}
source("datos_03.limpieza-datos.R", echo = FALSE)
cat("\n(fin de la ejecucion de datos_03.limpieza-datos.R)\n\n")

# ------------------------------------------------------------------------------
# PASO 3: Comparar, campo por campo, la version "clonada" contra la recien
# generada. Se usa una funcion de comparacion distinta segun el formato.
# ------------------------------------------------------------------------------
comparar_csv <- function(a, b) {
  da <- tryCatch(read.csv(a, stringsAsFactors = FALSE, encoding = "UTF-8"),
                 error = function(e) NULL)
  db <- tryCatch(read.csv(b, stringsAsFactors = FALSE, encoding = "UTF-8"),
                 error = function(e) NULL)
  if (is.null(da) || is.null(db)) return(list(ok = FALSE, detalle = "No se pudo leer alguno de los dos CSV."))
  if (!identical(dim(da), dim(db))) {
    return(list(ok = FALSE, detalle = paste0("Dimensiones distintas: clonado=", paste(dim(da), collapse="x"),
                                              " vs regenerado=", paste(dim(db), collapse="x"))))
  }
  iguales <- isTRUE(all.equal(da, db, check.attributes = FALSE))
  if (iguales) return(list(ok = TRUE, detalle = paste0(nrow(da), " filas x ", ncol(da), " columnas, idénticas.")))
  dif <- which(!mapply(function(x, y) isTRUE(all.equal(x, y)), da, db))
  return(list(ok = FALSE, detalle = paste0("Diferencias en la(s) columna(s): ",
                                            paste(names(da)[dif], collapse = ", "))))
}

comparar_rds <- function(a, b) {
  da <- tryCatch(readRDS(a), error = function(e) NULL)
  db <- tryCatch(readRDS(b), error = function(e) NULL)
  if (is.null(da) || is.null(db)) return(list(ok = FALSE, detalle = "No se pudo leer alguno de los dos RDS."))
  if (identical(da, db)) return(list(ok = TRUE, detalle = paste0(nrow(da), " filas x ", ncol(da), " columnas, idénticas byte a byte."))) 
  iguales <- isTRUE(all.equal(da, db, check.attributes = FALSE))
  if (iguales) return(list(ok = TRUE, detalle = "Idénticas en contenido (difieren solo metadatos internos menores)."))
  return(list(ok = FALSE, detalle = "Contenido distinto entre el .rds clonado y el regenerado."))
}

comparar_xlsx <- function(a, b) {
  if (!requireNamespace("readxl", quietly = TRUE)) {
    return(list(ok = NA, detalle = "Paquete 'readxl' no disponible; no se pudo comparar este archivo."))
  }
  hojas_a <- readxl::excel_sheets(a)
  hojas_b <- readxl::excel_sheets(b)
  if (!identical(hojas_a, hojas_b)) {
    return(list(ok = FALSE, detalle = paste0("Hojas distintas: ", paste(hojas_a, collapse=","), " vs ", paste(hojas_b, collapse=","))))
  }
  detalles <- c()
  todas_ok <- TRUE
  for (h in hojas_a) {
    da <- as.data.frame(readxl::read_excel(a, sheet = h))
    db <- as.data.frame(readxl::read_excel(b, sheet = h))
    if (!isTRUE(all.equal(da, db, check.attributes = FALSE))) {
      todas_ok <- FALSE
      detalles <- c(detalles, paste0("hoja '", h, "' difiere"))
    }
  }
  if (todas_ok) return(list(ok = TRUE, detalle = paste0(length(hojas_a), " hoja(s), idénticas.")))
  return(list(ok = FALSE, detalle = paste(detalles, collapse = "; ")))
}

cat("--- Resultado de la comparación ---\n\n")
resultados <- data.frame(archivo = character(), estado = character(), detalle = character(), stringsAsFactors = FALSE)

for (f in archivos_a_comparar) {
  clonado <- file.path(dir_clonado, f)
  regenerado <- f
  ext <- tolower(tools::file_ext(f))

  r <- tryCatch({
    if (ext == "csv") comparar_csv(clonado, regenerado)
    else if (ext == "rds") comparar_rds(clonado, regenerado)
    else if (ext == "xlsx") comparar_xlsx(clonado, regenerado)
    else list(ok = NA, detalle = "Formato no soportado por este verificador.")
  }, error = function(e) list(ok = FALSE, detalle = paste("Error al comparar:", e$message)))

  estado <- if (isTRUE(r$ok)) "[OK]" else if (is.na(r$ok)) "[N/A]" else "[DIFERENCIAS]"
  cat(sprintf("%s %s\n     %s\n\n", estado, f, r$detalle))
  resultados <- rbind(resultados, data.frame(archivo = f, estado = estado, detalle = r$detalle))
}

cat("==================================================\n")
if (all(resultados$estado == "[OK]")) {
  cat("REPRODUCIBILIDAD CONFIRMADA: los 5 archivos regenerados son idénticos\n")
  cat("en contenido a los archivos clonados/publicados.\n")
} else if (any(resultados$estado == "[DIFERENCIAS]")) {
  cat("ATENCION: se encontraron diferencias en al menos un archivo (ver detalle\n")
  cat("arriba). Esto puede deberse a que el dato crudo (datos_01) o el catalogo\n")
  cat("de entidades (datos_02) cambiaron entre una corrida y otra, o a un ajuste\n")
  cat("en datos_03.limpieza-datos.R. Revise antes de publicar una nueva version.\n")
} else {
  cat("Verificacion incompleta: revise los mensajes [N/A] arriba.\n")
}
cat("==================================================\n")
cat("\nNota: la copia de referencia usada para esta comparación quedó guardada en\n")
cat("'", dir_clonado, "'. Puede borrar la carpeta '_verificacion_manual' en\n", sep = "")
cat("cualquier momento; no forma parte de los datos publicados.\n")
