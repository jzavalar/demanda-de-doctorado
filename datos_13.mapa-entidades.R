# ==============================================================================
# datos_13.mapa-entidades.R
# Mapa coropletico por entidad federativa (estado de estudios y de residencia)
# - Etapa 5 de datos_11.plan-analisis-datos.md.
# Demanda Potencial para un Doctorado en Ciencias en Paisaje y Rurismo Rural.
# Colegio de Postgraduados, Campus Cordoba.
#
# Usa un archivo geoespacial YA DESCARGADO Y GUARDADO en el repositorio
# (datos_13.geojson-entidades-mexico.geojson), en vez de descargarlo en cada
# corrida: asi el mapa se puede regenerar sin conexion a internet, incluso si
# la fuente original en linea deja de existir en el futuro (mismo criterio de
# reproducibilidad que datos_02.catalogo-estandarizacion-entidades.csv).
#
# FUENTE DEL ARCHIVO GEOESPACIAL: geometrias de los 32 estados de Mexico,
# derivadas de los shapefiles municipales CONABIO 2020-2023 publicados por
# PhantomInsights (https://github.com/PhantomInsights/mexico-geojson,
# licencia MIT). Referencia completa en formato APA lista para el articulo:
# ver datos_17.referencias-bibliograficas.md. El archivo original de ese repositorio esta a nivel de
# municipio; se disolvio (union geometrica) cada estado a partir de sus
# municipios, se simplifico la geometria (tolerancia 0.01 grados) para reducir
# el tamano del archivo sin alterar la forma visible a la escala del mapa, y
# se homologaron 4 nombres al catalogo de este proyecto (ver
# datos_02.catalogo-estandarizacion-entidades.csv): "Coahuila de Zaragoza" ->
# "Coahuila", "Michoacan de Ocampo" -> "Michoacan", "Mexico" -> "Estado de
# Mexico", "Veracruz de Ignacio de la Llave" -> "Veracruz". Descargado y
# procesado el 26 de julio de 2026.
#
# COMO EJECUTAR: Rscript datos_13.mapa-entidades.R (o source() en R), desde la
# carpeta del repositorio, DESPUES de correr datos_03.limpieza-datos.R al
# menos una vez.
#
# SALIDAS: datos_15.figuras/fig14_mapa_estado_estudios.png
#          datos_15.figuras/fig15_mapa_estado_residencia.png
#          (se agregan sus pies de figura a datos_15.figuras/pies-de-figura.md)
# ==============================================================================

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
paquetes_requeridos <- c("sf", "dplyr", "ggplot2", "scales")
tryCatch({
  lapply(paquetes_requeridos, instalar_y_cargar)
  message("Todos los paquetes se cargaron correctamente.")
}, error = function(e) stop("ERROR CRITICO cargando paquetes: ", e$message))

# ------------------------------------------------------------------------------
# BLOQUE 1: LECTURA Y VALIDACION
# ------------------------------------------------------------------------------
ruta_datos <- "datos_04.datos-limpios-completos.csv"
ruta_geo <- "datos_13.geojson-entidades-mexico.geojson"

if (!file.exists(ruta_datos)) stop("ERROR: no se encontro '", ruta_datos, "'. Corra primero datos_03.limpieza-datos.R.")
if (!file.exists(ruta_geo))   stop("ERROR: no se encontro '", ruta_geo, "' en el directorio actual.")

d <- read.csv(ruta_datos, stringsAsFactors = FALSE, encoding = "UTF-8")
d_interesados <- d %>% filter(interes_en_doctorado == "Sí")

geo <- tryCatch(
  st_read(ruta_geo, quiet = TRUE),
  error = function(e) stop("ERROR al leer el archivo geoespacial: ", e$message)
)

# Los 32 nombres del geojson ya vienen homologados al catalogo estandarizado
# de este proyecto (ver encabezado de este script y
# datos_02.catalogo-estandarizacion-entidades.csv). Se conserva esta linea
# como salvaguarda idempotente (no cambia nada si los nombres ya coinciden).
geo <- geo %>% mutate(entidad = ifelse(name == "México", "Estado de México", name))

entidades_sin_geometria <- function(valores_datos) {
  setdiff(unique(na.omit(valores_datos)), geo$entidad)
}
faltantes_estudios <- entidades_sin_geometria(d_interesados$estado_estudios)
faltantes_residencia <- entidades_sin_geometria(d_interesados$estado_residencia)
if (length(faltantes_estudios) > 0) {
  message("AVISO: valores de estado_estudios sin geometria correspondiente (se omiten del mapa): ",
          paste(faltantes_estudios, collapse = ", "))
}
if (length(faltantes_residencia) > 0) {
  message("AVISO: valores de estado_residencia sin geometria correspondiente (se omiten del mapa, ej. 'Estados Unidos de América'): ",
          paste(faltantes_residencia, collapse = ", "))
}

dir_figuras <- "datos_15.figuras"
dir.create(dir_figuras, showWarnings = FALSE)

# ------------------------------------------------------------------------------
# BLOQUE 2: FUNCION DE MAPEO
# ------------------------------------------------------------------------------
mapa_coropletico <- function(datos, variable, etiqueta_leyenda, archivo, titulo_interno) {
  conteo <- datos %>%
    filter(!is.na(.data[[variable]])) %>%
    count(.data[[variable]], name = "n")
  names(conteo)[1] <- "entidad"
  n_total <- sum(conteo$n)

  geo_join <- geo %>% left_join(conteo, by = "entidad") %>%
    mutate(n = ifelse(is.na(n), 0, n))

  p <- ggplot(geo_join) +
    geom_sf(aes(fill = n), color = "white", linewidth = 0.15) +
    scale_fill_gradient(low = "#D9E2F3", high = "#1F3864", name = etiqueta_leyenda,
                         breaks = scales::pretty_breaks()) +
    labs(subtitle = paste0("n = ", n_total)) +
    theme_void(base_size = 11, base_family = "Times") +
    theme(legend.position = "right",
          legend.text = element_text(family = "Times"),
          legend.title = element_text(family = "Times", face = "bold"),
          plot.subtitle = element_text(size = 9.5, color = "gray30", family = "Times", hjust = 0))

  ggsave(file.path(dir_figuras, archivo), p, width = 7, height = 5.5, dpi = 300, bg = "white")
  geo_join %>% st_drop_geometry() %>% select(entidad, n) %>% arrange(desc(n))
}

# ------------------------------------------------------------------------------
# BLOQUE 3: GENERAR LOS 2 MAPAS (solo sobre interesados, igual que las demas
# figuras de perfil en datos_12.analisis-descriptivo.R)
# ------------------------------------------------------------------------------
cat("\n==================================================\n")
cat("   ETAPA 5: MAPAS COROPLETICOS\n")
cat("==================================================\n\n")

tabla_mapa_estudios <- tabla_mapa_residencia <- NULL

tryCatch({
  tabla_mapa_estudios <- mapa_coropletico(
    d_interesados, "estado_estudios", "N personas",
    "fig14_mapa_estado_estudios.png",
    "Entidad donde cursaron la maestría (personas interesadas)"
  )
  cat("[OK] fig14_mapa_estado_estudios.png generado.\n")
}, error = function(e) cat("[AVISO] mapa estado_estudios:", e$message, "\n"))

tryCatch({
  tabla_mapa_residencia <- mapa_coropletico(
    d_interesados, "estado_residencia", "N personas",
    "fig15_mapa_estado_residencia.png",
    "Entidad de residencia actual (personas interesadas)"
  )
  cat("[OK] fig15_mapa_estado_residencia.png generado.\n")
}, error = function(e) cat("[AVISO] mapa estado_residencia:", e$message, "\n"))

# ------------------------------------------------------------------------------
# BLOQUE 4: EXPORTAR TABLAS DE APOYO Y AGREGAR PIES DE FIGURA
# ------------------------------------------------------------------------------
tryCatch({
  write.csv(tabla_mapa_estudios, file.path(dir_figuras, "datos_15.mapa-estado-estudios.csv"),
            row.names = FALSE, na = "NA", fileEncoding = "UTF-8")
  write.csv(tabla_mapa_residencia, file.path(dir_figuras, "datos_15.mapa-estado-residencia.csv"),
            row.names = FALSE, na = "NA", fileEncoding = "UTF-8")
  message("Tablas de apoyo de los mapas exportadas a datos_15.mapa-estado-estudios.csv y datos_15.mapa-estado-residencia.csv")
}, error = function(e) message("AVISO al exportar tablas de los mapas: ", e$message))

tryCatch({
  pies_nuevos <- c(
    "**Figura 14.** Distribución por entidad donde cursaron la maestría, personas interesadas en el doctorado.\n\n*Fuente: Elaboración propia.*\n",
    "**Figura 15.** Distribución por entidad de residencia actual, personas interesadas en el doctorado.\n\n*Fuente: Elaboración propia.*\n"
  )
  ruta_pies <- file.path(dir_figuras, "pies-de-figura.md")
  # Misma logica de bloques con marcadores que datos_12/datos_19 (ver esa
  # funcion para el detalle): garantiza el orden final MCA -> datos_12 -> mapas
  # sin importar en que orden se corrieron los scripts, y sin sobrescribir lo
  # que los otros dos ya hayan escrito.
  escribir_bloque_pies <- function(ruta, tag, bloque_nuevo,
                                    orden = c("datos_19", "datos_12", "datos_13")) {
    ini_tag <- paste0("<!-- CAPTIONS:", tag, ":INICIO -->")
    fin_tag <- paste0("<!-- CAPTIONS:", tag, ":FIN -->")
    bloque_tagged <- c(ini_tag, bloque_nuevo, fin_tag)
    existentes <- list()
    if (file.exists(ruta)) {
      lineas <- readLines(ruta, warn = FALSE)
      for (t in orden) {
        ini_t <- paste0("<!-- CAPTIONS:", t, ":INICIO -->")
        fin_t <- paste0("<!-- CAPTIONS:", t, ":FIN -->")
        idx_i <- which(lineas == ini_t); idx_f <- which(lineas == fin_t)
        if (length(idx_i) == 1 && length(idx_f) == 1 && idx_f > idx_i) {
          existentes[[t]] <- lineas[idx_i:idx_f]
        }
      }
    }
    existentes[[tag]] <- bloque_tagged
    bloques_finales <- unlist(lapply(orden, function(t) {
      if (!is.null(existentes[[t]])) c(existentes[[t]], "") else NULL
    }))
    writeLines(bloques_finales, ruta)
  }
  escribir_bloque_pies(ruta_pies, "datos_13", pies_nuevos)
  message("Pies de figura de los mapas escritos/actualizados en su bloque dentro de ", ruta_pies)
}, error = function(e) message("AVISO al actualizar pies de figura: ", e$message))

cat("\n==================================================\n")
cat("Proceso finalizado correctamente.\n")
