# ==============================================================================
# datos_19.mca-exploratorio.R
# Analisis de Correspondencias Multiples (MCA) — panorama EXPLORATORIO de las
# variables de demanda, para presentarse al inicio de Resultados (antes de
# RQ1), no como prueba confirmatoria. Complementa, sin sustituir, las pruebas
# de asociacion pareadas y pre-especificadas de RQ6-RQ7 (ver
# datos_11.plan-analisis-datos.md y datos_12.analisis-descriptivo.R).
#
# Adaptado del script original compartido por el equipo (v14, dos paneles como
# imagenes independientes con leyenda propia cada una). Cambios respecto al
# original, todos para dejarlo consistente con el resto del repositorio:
#   1. Se agrega fijar el locale a UTF-8 (bloque 0): sin esto, el script
#      original producia advertencias de codificacion ("unable to translate
#      'Agronomica' to native encoding") y terminaba con un error de parseo
#      ("invalid multibyte character"). Corregido y verificado.
#   2. Se reemplaza la carga de 'tidyverse' completo por los paquetes
#      puntuales que realmente se usan (dplyr, ggplot2), con instalacion
#      automatica igual que datos_03/datos_12/datos_13.
#   3. Se quita 'factoextra': se cargaba en el original pero ninguna de sus
#      funciones se usa (el script solo usa res.mca$var$coord/$contrib, que
#      son de FactoMineR); se elimina esa dependencia innecesaria.
#   4. Se quita la version combinada de las figuras 5a+5b en un solo archivo
#      (estaba comentada como "opcional/no se genera" en el encabezado del
#      script original, pero el codigo correspondiente NO estaba realmente
#      comentado y si se ejecutaba, duplicando contenido ya cubierto por los
#      dos paneles por separado). Se conserva la decision de dos figuras
#      independientes, sin una tercera version combinada.
#   5. Se agrega bg = "white" en ggsave (el original generaba PNG con fondo
#      transparente; el resto de las figuras del repositorio usan fondo
#      blanco, por consistencia al pegarlas en Word).
#   6. Solo se exporta .png (no .pdf), igual que el resto de datos_15.figuras/.
#   7. Rutas y nombres de archivo ajustados a la convencion de este
#      repositorio (datos_05.datos-interesados.csv como entrada;
#      salidas dentro de datos_15.figuras/).
#
# COMO EJECUTAR: Rscript datos_19.mca-exploratorio.R (o source() en R), desde
# la carpeta del repositorio, DESPUES de correr datos_03.limpieza-datos.R al
# menos una vez.
#
# SALIDAS: datos_15.figuras/fig16_mca_vista_general.png
#          datos_15.figuras/fig17_mca_detalle_cumulo.png
#          datos_15.figuras/datos_15.mca-coordenadas.csv
#          datos_15.figuras/datos_15.mca-dimensiones.csv
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

paquetes_requeridos <- c("dplyr", "ggplot2", "ggrepel", "FactoMineR")

tryCatch({
  lapply(paquetes_requeridos, instalar_y_cargar)
  message("Todos los paquetes se cargaron correctamente.")
}, error = function(e) {
  stop("ERROR CRITICO: no se pudieron cargar los paquetes necesarios. Detalle: ", e$message)
})

# ------------------------------------------------------------------------------
# BLOQUE 1: LECTURA Y VALIDACION
# ------------------------------------------------------------------------------
ruta_datos <- "datos_05.datos-interesados.csv"
dir_figuras <- "datos_15.figuras"

if (!file.exists(ruta_datos)) {
  stop("ERROR: no se encontro '", ruta_datos, "'. Corra primero datos_03.limpieza-datos.R.")
}
dir.create(dir_figuras, showWarnings = FALSE)

datos_interesados <- read.csv(ruta_datos, stringsAsFactors = FALSE, encoding = "UTF-8")

variables_mca <- c("genero", "edad", "area_maestria", "situacion_laboral",
                    "motivacion_en_doctorado", "tiempo_inicio_doctorado")
faltantes_cols <- setdiff(variables_mca, names(datos_interesados))
if (length(faltantes_cols) > 0) {
  stop("ERROR DE ESTRUCTURA: faltan columnas necesarias para el MCA: ",
       paste(faltantes_cols, collapse = ", "))
}

datos_mca <- datos_interesados[, variables_mca]
datos_mca[] <- lapply(datos_mca, as.factor)
n_antes_na <- nrow(datos_mca)
datos_mca <- na.omit(datos_mca)
n_omitidos <- n_antes_na - nrow(datos_mca)

cat("Registros validos para el MCA:", nrow(datos_mca), "de", n_antes_na,
    "(", n_omitidos, "excluidos por dato faltante real en alguna de las 6 variables, ",
    "principalmente situacion_laboral)\n")

# ------------------------------------------------------------------------------
# BLOQUE 2: EJECUTAR EL MCA
# ------------------------------------------------------------------------------
res.mca <- tryCatch(
  FactoMineR::MCA(datos_mca, graph = FALSE),
  error = function(e) stop("ERROR al ejecutar el MCA: ", e$message)
)

inercia_dim1      <- round(res.mca$eig[1, 2], 1)
inercia_dim2      <- round(res.mca$eig[2, 2], 1)
inercia_acumulada <- round(sum(res.mca$eig[1:2, 2]), 1)

# ------------------------------------------------------------------------------
# BLOQUE 3: COORDENADAS Y CONTRIBUCIONES
# ------------------------------------------------------------------------------
coord_mca <- as.data.frame(res.mca$var$coord)
coord_mca$categoria <- rownames(coord_mca)
names(coord_mca)[names(coord_mca) == "Dim 1"] <- "dim1"
names(coord_mca)[names(coord_mca) == "Dim 2"] <- "dim2"

contrib_mca <- as.data.frame(res.mca$var$contrib)
contrib_mca$categoria <- rownames(contrib_mca)
contrib_mca$contrib_total <- contrib_mca[["Dim 1"]] + contrib_mca[["Dim 2"]]

niveles_variable <- c("Género", "Edad", "Área de maestría",
                       "Situación laboral", "Motivación", "Tiempo de inicio")

coord_mca <- merge(coord_mca, contrib_mca[, c("categoria", "contrib_total")], by = "categoria")
coord_mca$variable <- with(coord_mca, ifelse(
  categoria %in% levels(datos_mca$genero), "Género", ifelse(
  categoria %in% levels(datos_mca$edad), "Edad", ifelse(
  categoria %in% levels(datos_mca$area_maestria), "Área de maestría", ifelse(
  categoria %in% levels(datos_mca$situacion_laboral), "Situación laboral", ifelse(
  categoria %in% levels(datos_mca$motivacion_en_doctorado), "Motivación", ifelse(
  categoria %in% levels(datos_mca$tiempo_inicio_doctorado), "Tiempo de inicio", "Otra")))))))
coord_mca$variable <- factor(coord_mca$variable, levels = niveles_variable)
coord_mca$dist_origen <- sqrt(coord_mca$dim1^2 + coord_mca$dim2^2)

cat("Total de categorías graficadas:", nrow(coord_mca), "\n")

# ------------------------------------------------------------------------------
# BLOQUE 4: RECTANGULO DE ZOOM (panel de detalle), mismo criterio geometrico
# que el original: el rectangulo y el contenido del panel B son SIEMPRE el
# mismo conjunto de categorias (no un porcentaje aproximado).
# ------------------------------------------------------------------------------
umbral_percentil_zoom <- 0.50
umbral_dist <- quantile(coord_mca$dist_origen, umbral_percentil_zoom)
cumulo_aproximado <- coord_mca[coord_mca$dist_origen <= umbral_dist, ]

zx0 <- range(cumulo_aproximado$dim1); zy0 <- range(cumulo_aproximado$dim2)
pad_zoom <- 0.12
zoom_xlim <- c(zx0[1] - diff(zx0) * pad_zoom, zx0[2] + diff(zx0) * pad_zoom)
zoom_ylim <- c(zy0[1] - diff(zy0) * pad_zoom, zy0[2] + diff(zy0) * pad_zoom)

coord_mca$en_zoom <- coord_mca$dim1 >= zoom_xlim[1] & coord_mca$dim1 <= zoom_xlim[2] &
                     coord_mca$dim2 >= zoom_ylim[1] & coord_mca$dim2 <= zoom_ylim[2]
zoom_data <- coord_mca[coord_mca$en_zoom, ]

cat("Categorías en el panel de detalle (zoom):", nrow(zoom_data), "de", nrow(coord_mca), "\n")

fx <- range(coord_mca$dim1); fy <- range(coord_mca$dim2)
fx_pad <- diff(fx) * 0.15; fy_pad <- diff(fy) * 0.15
full_xlim <- c(fx[1] - fx_pad, fx[2] + fx_pad)
full_ylim <- c(fy[1] - fy_pad, fy[2] + fy_pad)
breaks_x_panel_a <- seq(floor(full_xlim[1] * 2) / 2, ceiling(full_xlim[2] * 2) / 2, by = 0.5)
breaks_y_panel_a <- seq(floor(full_ylim[1] * 2) / 2, ceiling(full_ylim[2] * 2) / 2, by = 0.5)

# ------------------------------------------------------------------------------
# BLOQUE 5: ESCALAS Y TEMA COMPARTIDOS
# ------------------------------------------------------------------------------
paleta_contrib <- ggplot2::scale_color_gradientn(
  colors = c("#004C8C", "#4A90D9", "#E69F00", "#D55E00", "#B30000"),
  name = "Contribución\ntotal (%)",
  limits = range(coord_mca$contrib_total)
)

escala_forma <- ggplot2::scale_shape_manual(
  name   = "Variable",
  values = c("Género" = 16, "Edad" = 17, "Área de maestría" = 15,
             "Situación laboral" = 3, "Motivación" = 4, "Tiempo de inicio" = 8),
  limits = niveles_variable,
  drop   = FALSE
)

# "Times" resuelve via fontconfig a un sustituto metricamente compatible
# (TeX Gyre Termes / Liberation Serif segun el sistema); no requiere que
# "Times New Roman" este instalado literalmente.
tema_base <- ggplot2::theme_minimal(base_size = 11, base_family = "Times") +
  ggplot2::theme(
    axis.title       = ggplot2::element_text(size = 10, face = "bold"),
    axis.text        = ggplot2::element_text(size = 8.5),
    panel.grid.minor = ggplot2::element_blank(),
    panel.grid.major = ggplot2::element_line(color = "gray92", linewidth = 0.3),
    legend.text      = ggplot2::element_text(family = "Times"),
    legend.title     = ggplot2::element_text(family = "Times", face = "bold")
  )

set.seed(20260726)

# ------------------------------------------------------------------------------
# BLOQUE 6: PANEL A (vista general) y PANEL B (detalle del cumulo)
# Nota RIDE: sin title/subtitle/caption incrustados en el PNG (el titulo y la
# fuente van como texto de Word, en pies-de-figura.md), igual que el resto de
# las figuras de este repositorio.
# ------------------------------------------------------------------------------
panel_a <- ggplot2::ggplot(coord_mca, ggplot2::aes(x = dim1, y = dim2)) +
  ggplot2::geom_vline(xintercept = 0, linetype = "dashed", color = "gray50", linewidth = 0.6) +
  ggplot2::geom_hline(yintercept = 0, linetype = "dashed", color = "gray50", linewidth = 0.6) +
  ggplot2::annotate("rect", xmin = zoom_xlim[1], xmax = zoom_xlim[2],
                    ymin = zoom_ylim[1], ymax = zoom_ylim[2],
                    fill = "gray40", alpha = 0.08, color = "gray40",
                    linewidth = 0.5, linetype = "dotted") +
  ggplot2::annotate("text", x = zoom_xlim[2], y = zoom_ylim[2],
                    label = "Ver Figura 2", hjust = -0.05, vjust = -0.3,
                    size = 3, fontface = "italic", color = "gray30", family = "Times") +
  ggplot2::geom_point(ggplot2::aes(color = contrib_total, shape = variable), size = 2.6, alpha = 0.9) +
  ggrepel::geom_text_repel(
    data = coord_mca[!coord_mca$en_zoom, ],
    ggplot2::aes(label = categoria, color = contrib_total),
    size = 3.3, family = "Times",
    max.overlaps = Inf, max.time = 3, max.iter = 20000,
    box.padding = 0.45, point.padding = 0.35, force = 3, force_pull = 0.6,
    direction = "both", segment.color = "gray55", segment.size = 0.3,
    segment.alpha = 0.6, min.segment.length = 0,
    xlim = full_xlim, ylim = full_ylim, show.legend = FALSE
  ) +
  paleta_contrib + escala_forma +
  ggplot2::scale_x_continuous(breaks = breaks_x_panel_a) +
  ggplot2::scale_y_continuous(breaks = breaks_y_panel_a) +
  ggplot2::coord_cartesian(xlim = full_xlim, ylim = full_ylim) +
  ggplot2::labs(
    x = paste0("Dimensión 1 (", inercia_dim1, "% de inercia)"),
    y = paste0("Dimensión 2 (", inercia_dim2, "% de inercia)"),
    subtitle = paste0("n = ", nrow(datos_mca))
  ) +
  tema_base +
  ggplot2::theme(legend.position = "right",
                 plot.subtitle = ggplot2::element_text(size = 9.5, color = "gray30", family = "Times"))

panel_b <- ggplot2::ggplot(zoom_data, ggplot2::aes(x = dim1, y = dim2)) +
  ggplot2::geom_vline(xintercept = 0, linetype = "dashed", color = "gray50", linewidth = 0.5) +
  ggplot2::geom_hline(yintercept = 0, linetype = "dashed", color = "gray50", linewidth = 0.5) +
  ggplot2::geom_point(ggplot2::aes(color = contrib_total, shape = variable), size = 3, alpha = 0.9) +
  ggrepel::geom_text_repel(
    ggplot2::aes(label = categoria, color = contrib_total),
    size = 3.4, family = "Times",
    max.overlaps = Inf, max.time = 4, max.iter = 30000,
    box.padding = 0.55, point.padding = 0.35, force = 4, force_pull = 0.4,
    direction = "both", segment.color = "gray55", segment.size = 0.3,
    segment.alpha = 0.7, min.segment.length = 0,
    xlim = zoom_xlim, ylim = zoom_ylim, show.legend = FALSE
  ) +
  paleta_contrib + escala_forma +
  ggplot2::coord_cartesian(xlim = zoom_xlim, ylim = zoom_ylim) +
  ggplot2::labs(
    x = paste0("Dimensión 1 (", inercia_dim1, "% de inercia)"),
    y = paste0("Dimensión 2 (", inercia_dim2, "% de inercia)"),
    subtitle = paste0("n = ", nrow(zoom_data), " categorías mostradas")
  ) +
  tema_base +
  ggplot2::theme(
    panel.border    = ggplot2::element_rect(color = "gray40", fill = NA, linewidth = 0.6),
    plot.subtitle   = ggplot2::element_text(size = 9.5, color = "gray30", family = "Times"),
    legend.position = "right"
  )

# ------------------------------------------------------------------------------
# BLOQUE 7: GUARDAR FIGURAS
# ------------------------------------------------------------------------------
tryCatch({
  ggplot2::ggsave(file.path(dir_figuras, "fig16_mca_vista_general.png"), panel_a,
                   width = 10, height = 8, dpi = 300, units = "in", bg = "white")
  ggplot2::ggsave(file.path(dir_figuras, "fig17_mca_detalle_cumulo.png"), panel_b,
                   width = 9, height = 8, dpi = 300, units = "in", bg = "white")
  cat("[OK] fig16_mca_vista_general.png y fig17_mca_detalle_cumulo.png generadas.\n")
}, error = function(e) stop("ERROR al guardar las figuras del MCA: ", e$message))

cat("Dimensión 1:", inercia_dim1, "% | Dimensión 2:", inercia_dim2, "%\n")
cat("Inercia acumulada (2 dimensiones):", inercia_acumulada, "%\n")

# ------------------------------------------------------------------------------
# BLOQUE 8: PIES DE FIGURA (formato RIDE), agregados sin duplicar si ya existen
# ------------------------------------------------------------------------------
pie_figura_1 <- paste0(
  "**Figura 1.** Panorama exploratorio de las variables de demanda (análisis de correspondencias ",
  "múltiples): vista general.\n\n",
  "*Nota:* n = ", nrow(datos_mca), " personas interesadas. Análisis exploratorio, no confirmatorio. ",
  "La proximidad entre categorías sugiere asociación; el color indica la contribución de cada ",
  "categoría a la formación de las dos dimensiones mostradas, que en conjunto explican solo el ",
  inercia_acumulada, "% de la inercia (variabilidad) total entre categorías — se presenta como ",
  "panorama general, no como evidencia confirmatoria. El área sombreada corresponde a la región ",
  "ampliada en la Figura 2.\n\n*Fuente: Elaboración propia.*\n"
)

pie_figura_2 <- paste0(
  "**Figura 2.** Panorama exploratorio de las variables de demanda (análisis de correspondencias ",
  "múltiples): detalle del cúmulo central (n = ", nrow(zoom_data), " categorías).\n\n",
  "*Nota:* ampliación de la región sombreada en la Figura 1, para evitar la sobreposición de ",
  "etiquetas. El color indica la contribución de cada categoría a la formación de las dos ",
  "dimensiones.\n\n*Fuente: Elaboración propia.*\n"
)

ruta_pies <- file.path(dir_figuras, "pies-de-figura.md")

# Funcion compartida (misma logica en datos_12/datos_13/datos_19): cada script
# escribe su propio bloque de pies de figura delimitado por marcadores HTML
# (invisibles al renderizar el markdown), y reconstruye el archivo completo en
# un orden FIJO sin importar en que orden se corrieron los scripts. Esto evita
# el problema real detectado el 26-jul-2026: datos_12 sobrescribia TODO el
# archivo sin preservar lo que datos_13/datos_19 ya habian agregado.
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

escribir_bloque_pies(ruta_pies, "datos_19", c(pie_figura_1, "", pie_figura_2))
message("Pies de figura del MCA escritos/actualizados en su bloque dentro de ", ruta_pies,
        " (orden final fijo, independiente del orden en que se corran los scripts).")

# ------------------------------------------------------------------------------
# BLOQUE 9: EXPORTAR TABLA DE DIMENSIONES Y COORDENADAS
# ------------------------------------------------------------------------------
tabla_dimensiones <- data.frame(
  dimension          = c("Dimensión 1", "Dimensión 2"),
  valor_propio       = round(res.mca$eig[1:2, 1], 3),
  pct_inercia        = round(res.mca$eig[1:2, 2], 2),
  pct_inercia_acum   = round(cumsum(res.mca$eig[1:2, 2]), 2)
)

tryCatch({
  write.csv(tabla_dimensiones, file.path(dir_figuras, "datos_15.mca-dimensiones.csv"),
            row.names = FALSE, fileEncoding = "UTF-8")
  write.csv(coord_mca[, c("categoria", "variable", "dim1", "dim2", "contrib_total", "en_zoom")],
            file.path(dir_figuras, "datos_15.mca-coordenadas.csv"),
            row.names = FALSE, fileEncoding = "UTF-8")
  cat("Tabla de dimensiones y coordenadas exportadas a datos_15.mca-dimensiones.csv y ",
      "datos_15.mca-coordenadas.csv\n")
}, error = function(e) stop("ERROR al exportar tablas del MCA: ", e$message))

cat("\n==================================================\n")
cat("Proceso finalizado correctamente.\n")
cat("==================================================\n")
