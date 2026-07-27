# ==============================================================================
# datos_12.analisis-descriptivo.R
# Analisis descriptivo, bivariado y perfil sintesis - Demanda Potencial para un
# Doctorado en Ciencias en Paisaje y Rurismo Rural.
# Colegio de Postgraduados, Campus Cordoba.
# Responsable del proyecto: Dra. Obdulia Baltazar Bernal (obduliabb@colpos.mx)
# Responsable del repositorio: Dr. Jesus Zavala Ruiz (jzr@xanum.uam.mx)
#
# Implementa las etapas 1-4 de datos_11.plan-analisis-datos.md:
#   Etapa 1: descriptivo univariado (frecuencias + graficos + IC de Wilson)
#   Etapa 2: bivariado pre-especificado (RQ6-RQ7), con prueba de independencia
#            elegida por la regla de Cochran (chi-cuadrado vs Fisher exacto) y
#            V de Cramer como tamano de efecto
#   Etapa 3: perfil sintesis de quienes estan interesados
#   Etapa 4: revision del texto libre preservado (columnas "..._otro_texto")
#
# La Etapa 5 (mapa) esta en datos_13.mapa-entidades.R, por separado, porque
# depende de una libreria y un archivo geoespacial adicionales.
#
# COMO EJECUTAR: Rscript datos_12.analisis-descriptivo.R (o source() en R),
# desde la carpeta del repositorio, DESPUES de correr datos_03.limpieza-datos.R
# al menos una vez (este script lee datos_04.datos-limpios-completos.csv).
#
# SALIDAS:
#   datos_14.tablas-resultados.xlsx   (todas las tablas, una hoja por etapa)
#   datos_15.figuras/*.png            (todas las figuras)
#   datos_15.figuras/pies-de-figura.md (texto listo para pegar en el articulo,
#                                       formato RIDE: titulo arriba, fuente abajo)
# ==============================================================================

try(Sys.setlocale("LC_ALL", "C.UTF-8"), silent = TRUE)

# Semilla fija: las pruebas de Fisher exacto de este script usan simulacion
# Monte Carlo (simulate.p.value = TRUE); sin una semilla fija, el p-valor
# exacto varia ligeramente entre corridas. Se fija para que los numeros
# citados en el manuscrito sean reproducibles byte a byte, no solo
# "aproximadamente los mismos".
set.seed(20260726)

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
paquetes_requeridos <- c("dplyr", "stringr", "tidyr", "ggplot2", "scales", "writexl", "openxlsx")
tryCatch({
  lapply(paquetes_requeridos, instalar_y_cargar)
  message("Todos los paquetes se cargaron correctamente.")
}, error = function(e) stop("ERROR CRITICO cargando paquetes: ", e$message))

# ------------------------------------------------------------------------------
# BLOQUE 1: LECTURA Y VALIDACION
# ------------------------------------------------------------------------------
ruta_datos <- "datos_04.datos-limpios-completos.csv"
if (!file.exists(ruta_datos)) {
  stop("ERROR: no se encontro '", ruta_datos, "'. Corra primero datos_03.limpieza-datos.R.")
}
d <- read.csv(ruta_datos, stringsAsFactors = FALSE, encoding = "UTF-8")
n_total <- nrow(d)
d_interesados <- d %>% filter(interes_en_doctorado == "Sí")
n_interesados <- nrow(d_interesados)
message(sprintf("Datos cargados: %d respuestas totales, %d con interes 'Si'.", n_total, n_interesados))

dir_figuras <- "datos_15.figuras"
dir.create(dir_figuras, showWarnings = FALSE)

# ------------------------------------------------------------------------------
# BLOQUE 2: FUNCIONES AUXILIARES
# ------------------------------------------------------------------------------

# IC de Wilson (score interval), sin correccion por continuidad. Se usa en vez
# del IC normal-aproximado, mas apropiado con n y/o proporciones pequenas.
# Se reporta como medida de PRECISION MUESTRAL, no como margen de error
# poblacional (ver datos_11.plan-analisis-datos.md, seccion 1).
wilson_ci <- function(x, n, conf = 0.95) {
  if (n == 0) return(c(estimate = NA, lower = NA, upper = NA))
  pt <- suppressWarnings(prop.test(x, n, conf.level = conf, correct = FALSE))
  c(estimate = unname(pt$estimate), lower = pt$conf.int[1], upper = pt$conf.int[2])
}

# V de Cramer como tamano de efecto para tablas de contingencia r x c
cramers_v <- function(tab) {
  chi <- suppressWarnings(chisq.test(tab, correct = FALSE))
  n_tot <- sum(tab)
  k <- min(dim(tab))
  if (k < 2 || n_tot == 0) return(NA_real_)
  as.numeric(sqrt(chi$statistic / (n_tot * (k - 1))))
}

# Elige la prueba de independencia por la regla de Cochran: si mas del 20% de
# las celdas esperadas tienen frecuencia <5, usa Fisher exacto (con simulacion
# Monte Carlo si la tabla es grande, para que sea computacionalmente viable);
# si no, usa chi-cuadrado. Nunca detiene el script: ante cualquier error de
# calculo, reporta el problema y continua con NA.
probar_asociacion <- function(tab, B_simulacion = 5000) {
  resultado <- list(prueba = NA_character_, estadistico = NA_real_, p_valor = NA_real_,
                     v_cramer = NA_real_, pct_celdas_bajas = NA_real_, n_efectivo = sum(tab))
  tryCatch({
    chi <- suppressWarnings(chisq.test(tab, correct = FALSE))
    pct_bajas <- mean(chi$expected < 5) * 100
    resultado$pct_celdas_bajas <- pct_bajas
    resultado$v_cramer <- cramers_v(tab)

    if (pct_bajas > 20) {
      f <- tryCatch(
        fisher.test(tab, simulate.p.value = TRUE, B = B_simulacion),
        error = function(e) NULL
      )
      if (!is.null(f)) {
        resultado$prueba <- "Fisher exacto (simulado, Monte Carlo)"
        resultado$p_valor <- f$p.value
      } else {
        resultado$prueba <- "chi-cuadrado (Fisher fallo; interpretar con cautela)"
        resultado$estadistico <- unname(chi$statistic)
        resultado$p_valor <- chi$p.value
      }
    } else {
      resultado$prueba <- "chi-cuadrado"
      resultado$estadistico <- unname(chi$statistic)
      resultado$p_valor <- chi$p.value
    }
  }, error = function(e) {
    message("AVISO: no se pudo calcular la prueba de asociacion (", e$message, ")")
  })
  resultado
}

# Guarda un grafico de barras horizontal para una variable categorica, con
# estilo consistente. El PNG no lleva titulo "oficial" incrustado en el area
# de la imagen mas alla de un rotulo ligero de referencia: el titulo/fuente en
# formato RIDE (arriba en negritas / fuente abajo) se agrega como texto normal
# en el documento de Word al insertar la figura (ver 01_Normas_Editoriales_RIDE),
# y queda pre-redactado en datos_15.figuras/pies-de-figura.md.
grafico_barras <- function(datos, variable, etiqueta, archivo, ancho = 7, alto = NULL) {
  tabla <- datos %>%
    filter(!is.na(.data[[variable]])) %>%
    count(.data[[variable]], name = "n") %>%
    mutate(pct = n / sum(n) * 100) %>%
    arrange(desc(n))
  names(tabla)[1] <- "categoria"

  # Altura dinamica: variables con muchas categorias (p. ej. 24 entidades)
  # necesitan mas espacio vertical para que las etiquetas no queden amontonadas.
  if (is.null(alto)) alto <- max(4, 0.32 * nrow(tabla) + 1.2)

  n_total <- sum(tabla$n)

  # Nota de tamano de muestra DENTRO del area de la figura (requerido por el
  # ejemplo oficial de RIDE, ver 03_Ejemplo_Formato_Figura_RIDE.png: "180
  # RESPUESTAS" dentro de la imagen). Se usa el espacio de subtitulo (no el de
  # titulo, que se elimino a proposito): es una nota de dato (n=), no un
  # titulo editorial, y al vivir en el subtitulo no se superpone con las
  # barras ni con las etiquetas de cada categoria.
  p <- ggplot(tabla, aes(x = reorder(categoria, n), y = n)) +
    geom_col(fill = "#1F3864") +
    geom_text(aes(label = paste0(n, " (", round(pct, 1), "%)")), hjust = -0.05, size = 3.2,
              family = "Times") +
    coord_flip(clip = "off") +
    labs(x = NULL, y = "Frecuencia (n)", subtitle = paste0("n = ", n_total)) +
    scale_y_continuous(expand = expansion(mult = c(0, 0.3))) +
    theme_minimal(base_size = 11, base_family = "Times") +
    theme(panel.grid.minor = element_blank(),
          plot.subtitle = element_text(size = 9.5, color = "gray30", family = "Times"))

  ggsave(file.path(dir_figuras, archivo), p, width = ancho, height = alto, dpi = 300, bg = "white")
  tabla
}

# ------------------------------------------------------------------------------
# Contenedores de resultados para exportar al final
# ------------------------------------------------------------------------------
tablas_univariado <- list()
tablas_bivariado <- list()
pies_de_figura <- character()
n_figura <- 0

nueva_pie <- function(titulo) {
  n_figura <<- n_figura + 1
  pies_de_figura <<- c(pies_de_figura, sprintf("**Figura %d.** %s\n\n*Fuente: Elaboración propia.*\n", n_figura, titulo))
  n_figura
}

cat("\n==================================================\n")
cat("   ETAPA 1: DESCRIPTIVO UNIVARIADO\n")
cat("==================================================\n\n")

# ------------------------------------------------------------------------------
# ETAPA 1: UNIVARIADO
# ------------------------------------------------------------------------------
variables_univariado <- list(
  list(var = "interes_en_doctorado",     etq = "Interés en cursar el doctorado",              arch = "fig01_interes_doctorado.png",      datos = d),
  list(var = "doctorado_de_interes",     etq = "Línea de doctorado de interés",                arch = "fig02_linea_doctorado.png",        datos = d_interesados),
  list(var = "genero",                   etq = "Género",                                       arch = "fig03_genero.png",                 datos = d_interesados),
  list(var = "edad",                     etq = "Edad (rangos)",                                 arch = "fig04_edad.png",                   datos = d_interesados),
  list(var = "estado_estudios",          etq = "Entidad donde cursó la maestría",               arch = "fig05_estado_estudios.png",        datos = d_interesados),
  list(var = "estado_residencia",        etq = "Entidad de residencia actual",                  arch = "fig06_estado_residencia.png",      datos = d_interesados),
  list(var = "area_maestria",            etq = "Área de la maestría",                           arch = "fig07_area_maestria.png",          datos = d_interesados),
  list(var = "situacion_laboral",        etq = "Situación laboral",                             arch = "fig08_situacion_laboral.png",      datos = d_interesados),
  list(var = "motivacion_en_doctorado",  etq = "Motivación principal para cursar el doctorado", arch = "fig09_motivacion.png",             datos = d_interesados),
  list(var = "tiempo_inicio_doctorado",  etq = "Plazo estimado para iniciar el doctorado",      arch = "fig10_tiempo_inicio.png",          datos = d_interesados)
)

for (v in variables_univariado) {
  tryCatch({
    tab <- grafico_barras(v$datos, v$var, v$etq, v$arch)
    tablas_univariado[[v$var]] <- tab %>% mutate(variable = v$var, .before = 1)
    nueva_pie(v$etq)
    cat(sprintf("[OK] %s -> %s (%d categorías, n=%d)\n", v$var, v$arch, nrow(tab), sum(tab$n)))
  }, error = function(e) cat(sprintf("[AVISO] %s: %s\n", v$var, e$message)))
}

# Proporciones clave con IC de Wilson
cat("\n--- Proporciones clave (IC de Wilson 95%, precisión muestral, no poblacional) ---\n")
t_interes <- table(d$interes_en_doctorado)
ic_interes <- wilson_ci(t_interes["Sí"], sum(t_interes))
cat(sprintf("Interés declarado 'Sí': %.1f%% (IC 95%% Wilson: %.1f%%-%.1f%%), n=%d\n",
            ic_interes["estimate"] * 100, ic_interes["lower"] * 100, ic_interes["upper"] * 100, sum(t_interes)))

t_linea <- table(d_interesados$doctorado_de_interes)
linea_top <- names(which.max(t_linea))
ic_linea <- wilson_ci(t_linea[linea_top], sum(t_linea))
cat(sprintf("Línea más elegida ('%s'): %.1f%% de interesados (IC 95%% Wilson: %.1f%%-%.1f%%), n=%d\n",
            linea_top, ic_linea["estimate"] * 100, ic_linea["lower"] * 100, ic_linea["upper"] * 100, sum(t_linea)))

tabla_proporciones_clave <- data.frame(
  proporcion = c("Interés declarado 'Sí' (de N total)", paste0("Línea más elegida: ", linea_top, " (de interesados)")),
  n_exito = c(unname(t_interes["Sí"]), unname(t_linea[linea_top])),
  n_base = c(sum(t_interes), sum(t_linea)),
  estimacion_pct = c(ic_interes["estimate"], ic_linea["estimate"]) * 100,
  ic95_wilson_inf = c(ic_interes["lower"], ic_linea["lower"]) * 100,
  ic95_wilson_sup = c(ic_interes["upper"], ic_linea["upper"]) * 100
)

cat("\n==================================================\n")
cat("   ETAPA 2: BIVARIADO (RQ6-RQ7, cruces pre-especificados)\n")
cat("==================================================\n\n")

# ------------------------------------------------------------------------------
# ETAPA 2: BIVARIADO
# ------------------------------------------------------------------------------
grafico_barras_apiladas <- function(datos, var_x, var_fill, etiqueta, archivo, ancho = 7.5, alto = 5) {
  tabla <- datos %>%
    filter(!is.na(.data[[var_x]]), !is.na(.data[[var_fill]])) %>%
    count(.data[[var_x]], .data[[var_fill]], name = "n")
  names(tabla)[1:2] <- c("x", "fill")
  n_total <- sum(tabla$n)

  p <- ggplot(tabla, aes(x = x, y = n, fill = fill)) +
    geom_col(position = "fill") +
    scale_y_continuous(labels = percent_format()) +
    labs(x = NULL, y = "% dentro de cada categoría", fill = NULL,
         subtitle = paste0("n = ", n_total)) +
    coord_flip() +
    theme_minimal(base_size = 10, base_family = "Times") +
    theme(legend.position = "bottom",
          legend.text = element_text(family = "Times"),
          plot.subtitle = element_text(size = 9, color = "gray30", family = "Times"))
  ggsave(file.path(dir_figuras, archivo), p, width = ancho, height = alto, dpi = 300, bg = "white")
}

cruces <- list(
  list(id = "situacion_laboral__tiempo_inicio", x = "situacion_laboral", y = "tiempo_inicio_doctorado",
       etq = "Situación laboral según plazo estimado de inicio (RQ6)", arch = "fig11_situacion_x_tiempo.png",
       datos = d_interesados),
  list(id = "situacion_laboral__motivacion", x = "situacion_laboral", y = "motivacion_en_doctorado",
       etq = "Situación laboral según motivación principal (RQ6)", arch = "fig12_situacion_x_motivacion.png",
       datos = d_interesados),
  list(id = "doctorado_interes__area_maestria", x = "area_maestria", y = "doctorado_de_interes",
       etq = "Área de la maestría según línea de doctorado de interés (RQ7)", arch = "fig13_area_x_linea.png",
       datos = d_interesados)
)

resumen_bivariado <- list()

for (cr in cruces) {
  tryCatch({
    tab <- table(cr$datos[[cr$x]], cr$datos[[cr$y]], useNA = "no")
    r <- probar_asociacion(tab)
    grafico_barras_apiladas(cr$datos, cr$x, cr$y, cr$etq, cr$arch)
    nueva_pie(cr$etq)

    tablas_bivariado[[cr$id]] <- as.data.frame.matrix(tab) %>%
      tibble::rownames_to_column(var = cr$x)

    resumen_bivariado[[cr$id]] <- data.frame(
      cruce = cr$id,
      variable_1 = cr$x, variable_2 = cr$y,
      n_efectivo = r$n_efectivo,
      pct_celdas_esperadas_bajo5 = round(r$pct_celdas_bajas, 1),
      prueba_usada = r$prueba,
      estadistico = r$estadistico,
      p_valor = signif(r$p_valor, 3),
      v_cramer = round(r$v_cramer, 3)
    )

    cat(sprintf("[OK] %s: %s, p=%.3f, V de Cramér=%.3f (n=%d, %.0f%% celdas esperadas <5)\n",
                cr$id, r$prueba, r$p_valor, r$v_cramer, r$n_efectivo, r$pct_celdas_bajas))
  }, error = function(e) cat(sprintf("[AVISO] %s: %s\n", cr$id, e$message)))
}

# RQ8 (movilidad geográfica): se resume como una proporción interpretable
# (misma entidad de estudios y de residencia vs. distinta) ademas de la prueba
# de independencia sobre la tabla completa, que por su tamano (17x25 aprox.)
# se hace con Fisher exacto simulado y se interpreta con cautela.
tryCatch({
  mov <- d_interesados %>%
    filter(!is.na(estado_estudios), !is.na(estado_residencia)) %>%
    mutate(misma_entidad = estado_estudios == estado_residencia)
  tab_mov <- table(mov$misma_entidad)
  ic_mov <- wilson_ci(unname(tab_mov["TRUE"]), sum(tab_mov))
  cat(sprintf("\n[RQ8] Permanecen en la misma entidad (estudios = residencia): %.1f%% (IC 95%% Wilson: %.1f%%-%.1f%%), n=%d\n",
              ic_mov["estimate"] * 100, ic_mov["lower"] * 100, ic_mov["upper"] * 100, sum(tab_mov)))

  tab_geo <- table(d_interesados$estado_estudios, d_interesados$estado_residencia, useNA = "no")
  r_geo <- probar_asociacion(tab_geo, B_simulacion = 2000)
  cat(sprintf("[RQ8] Asociación estado_estudios x estado_residencia (tabla completa, %dx%d): %s, p=%.3f, V de Cramér=%.3f (n=%d)\n",
              nrow(tab_geo), ncol(tab_geo), r_geo$prueba, r_geo$p_valor, r_geo$v_cramer, r_geo$n_efectivo))

  resumen_bivariado[["rq8_movilidad"]] <- data.frame(
    cruce = "estado_estudios__estado_residencia (tabla completa, ver nota)",
    variable_1 = "estado_estudios", variable_2 = "estado_residencia",
    n_efectivo = r_geo$n_efectivo,
    pct_celdas_esperadas_bajo5 = round(r_geo$pct_celdas_bajas, 1),
    prueba_usada = r_geo$prueba,
    estadistico = r_geo$estadistico,
    p_valor = signif(r_geo$p_valor, 3),
    v_cramer = round(r_geo$v_cramer, 3)
  )
  tabla_movilidad_resumen <- data.frame(
    indicador = "Permanece en la misma entidad (estudios = residencia)",
    n_exito = unname(tab_mov["TRUE"]), n_base = sum(tab_mov),
    estimacion_pct = ic_mov["estimate"] * 100,
    ic95_wilson_inf = ic_mov["lower"] * 100, ic95_wilson_sup = ic_mov["upper"] * 100
  )
}, error = function(e) cat("[AVISO] RQ8:", e$message, "\n"))

tabla_resumen_bivariado <- bind_rows(resumen_bivariado)

cat("\n==================================================\n")
cat("   ETAPA 3: PERFIL SINTESIS (interesados)\n")
cat("==================================================\n\n")

# ------------------------------------------------------------------------------
# ETAPA 3: PERFIL SINTESIS
# ------------------------------------------------------------------------------
perfil_variable <- function(datos, variable) {
  tab <- table(datos[[variable]])
  if (length(tab) == 0) return(NULL)
  top <- names(which.max(tab))
  data.frame(
    variable = variable,
    categoria_mas_frecuente = top,
    n = unname(tab[top]),
    pct = round(unname(tab[top]) / sum(tab) * 100, 1),
    n_categorias_totales = length(tab)
  )
}

vars_perfil <- c("genero", "edad", "estado_residencia", "area_maestria", "situacion_laboral",
                  "motivacion_en_doctorado", "tiempo_inicio_doctorado", "doctorado_de_interes")
perfil_sintesis <- bind_rows(lapply(vars_perfil, perfil_variable, datos = d_interesados))
print(perfil_sintesis, row.names = FALSE)

cat("\n==================================================\n")
cat("   ETAPA 4: TEXTO LIBRE PRESERVADO ('..._otro_texto')\n")
cat("==================================================\n\n")

# ------------------------------------------------------------------------------
# ETAPA 4: TEXTO LIBRE ("Otro", ver datos_03.limpieza-datos.R)
# Codificacion tematica MANUAL y transparente (n es muy pequeno para
# text-mining formal); cualquier persona puede revisar/ajustar estas 3 filas.
# ------------------------------------------------------------------------------
texto_libre <- d %>%
  filter(!is.na(motivacion_en_doctorado_otro_texto)) %>%
  select(motivacion_en_doctorado_otro_texto) %>%
  mutate(tema_asignado = case_when(
    motivacion_en_doctorado_otro_texto == "Sector privado" ~ "Interés laboral fuera del ámbito académico",
    str_detect(motivacion_en_doctorado_otro_texto, "jubil") ~ "Cercanía a jubilación / sin proyección laboral futura",
    motivacion_en_doctorado_otro_texto == "Ninguno" ~ "Sin motivación adicional declarada",
    TRUE ~ "Sin clasificar (revisar manualmente)"
  ))
print(texto_libre, row.names = FALSE)

cat("\n==================================================\n")
cat("   EXPORTACION DE RESULTADOS\n")
cat("==================================================\n\n")

# ------------------------------------------------------------------------------
# EXPORTACION: datos_14.tablas-resultados.xlsx (todas las tablas) +
# datos_15.figuras/pies-de-figura.md (texto listo para el articulo)
# ------------------------------------------------------------------------------
tryCatch({
  hojas <- list(
    "Proporciones_clave" = tabla_proporciones_clave
  )
  for (nm in names(tablas_univariado)) hojas[[paste0("Univ_", substr(nm, 1, 25))]] <- tablas_univariado[[nm]]
  hojas[["Bivariado_resumen"]] <- tabla_resumen_bivariado
  for (nm in names(tablas_bivariado)) hojas[[paste0("Cruce_", substr(nm, 1, 22))]] <- tablas_bivariado[[nm]]
  if (exists("tabla_movilidad_resumen")) hojas[["RQ8_movilidad"]] <- tabla_movilidad_resumen
  hojas[["Perfil_sintesis"]] <- perfil_sintesis
  hojas[["Texto_libre_otro"]] <- texto_libre

  write_xlsx(hojas, "datos_14.tablas-resultados.xlsx")
  message("Tablas exportadas a datos_14.tablas-resultados.xlsx (", length(hojas), " hojas).")
}, error = function(e) stop("ERROR al exportar tablas: ", e$message))

tryCatch({
  # Misma logica de bloques con marcadores que datos_13/datos_19 (ver esa
  # funcion para el detalle): preserva los pies de figura que datos_13 y
  # datos_19 ya hayan escrito, en vez de sobrescribir todo el archivo.
  ruta_pies <- file.path(dir_figuras, "pies-de-figura.md")
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
  escribir_bloque_pies(ruta_pies, "datos_12", pies_de_figura)
  message("Pies de figura (formato RIDE) actualizados en su bloque dentro de ", ruta_pies)
}, error = function(e) message("AVISO al guardar pies de figura: ", e$message))

cat("\n==================================================\n")
cat("REPORTE FINAL\n")
cat("==================================================\n")
cat("Respuestas totales:", n_total, "| Interesados:", n_interesados, "\n")
cat("Figuras generadas:", n_figura, "en", dir_figuras, "\n")
cat("Tablas exportadas: datos_14.tablas-resultados.xlsx\n")
cat("Proceso finalizado correctamente.\n")
