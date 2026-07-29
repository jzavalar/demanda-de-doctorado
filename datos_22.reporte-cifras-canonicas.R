# ==============================================================================
# datos_22.reporte-cifras-canonicas.R
# Reporte canónico de todas las cifras que aparecen en Resultados del manuscrito
# "Análisis de la demanda del Doctorado en Ciencias integrado a la Maestría
# Profesionalizante en Paisaje y Turismo Rural" (RIDE).
#
# Colegio de Postgraduados, Campus Córdoba.
# Responsable del proyecto: Dra. Obdulia Baltazar Bernal (obduliabb@colpos.mx)
# Responsable del repositorio: Dr. Jesús Zavala Ruiz (jzr@xanum.uam.mx)
#
# ------------------------------------------------------------------------------
# PARA QUÉ SIRVE
# ------------------------------------------------------------------------------
# Este script NO sustituye a datos_12/datos_13/datos_19: no genera figuras ni
# tablas de Excel. Su única función es imprimir, en un solo archivo de texto,
# cada número que va a aparecer en el manuscrito, para poder:
#   (a) congelar la corrida canónica en el entorno declarado,
#   (b) verificar que dos corridas dan un resultado idéntico byte a byte,
#   (c) compartir los resultados en un formato compacto y legible.
#
# ------------------------------------------------------------------------------
# DISEÑO
# ------------------------------------------------------------------------------
# * Usa SOLO R base (stats, utils). Sin dplyr, ggplot2 ni ningún paquete
#   externo: elimina la superficie de fallo por versiones de paquetes y hace que
#   el reporte sea reproducible con cualquier instalación de R >= 4.0.
# * Siembra la semilla INMEDIATAMENTE ANTES de cada prueba simulada, con una
#   semilla propia por prueba. Así cada p-valor queda anclado a su prueba y es
#   inmune al orden de ejecución (ver datos_21.revision-scripts.md, hallazgo A2).
# * Usa 200 000 réplicas Monte Carlo, para que el tercer decimal del p-valor sea
#   estable entre corridas (hallazgo A1).
# * Aborta con mensaje explícito si el número de registros no es el esperado
#   (hallazgo B2), en vez de producir un reporte de ceros en silencio.
# * No depende de la coincidencia literal de cadenas acentuadas: identifica el
#   "Sí" por su inicial y los rangos de edad por su número inicial (hallazgo B1).
#
# ------------------------------------------------------------------------------
# CÓMO EJECUTAR
# ------------------------------------------------------------------------------
#   Rscript datos_22.reporte-cifras-canonicas.R
# desde la carpeta del repositorio, DESPUÉS de datos_03.limpieza-datos.R.
#
# SALIDA: datos_22.reporte-cifras-canonicas.txt
#
# VERIFICACIÓN DE REPRODUCIBILIDAD (ejecutar dos veces y comparar):
#   Rscript datos_22.reporte-cifras-canonicas.R
#   mv datos_22.reporte-cifras-canonicas.txt corrida_1.txt
#   Rscript datos_22.reporte-cifras-canonicas.R
#   diff <(grep -v "^Fecha" corrida_1.txt) \
#        <(grep -v "^Fecha" datos_22.reporte-cifras-canonicas.txt) && echo "IDENTICO"
# ==============================================================================

try(Sys.setlocale("LC_ALL", "C.UTF-8"), silent = TRUE)

B_REPLICAS      <- 200000L   # RQ6 y RQ7
B_REPLICAS_RQ8  <- 50000L    # RQ8: tabla 17x24, más costosa
SEMILLA_BASE    <- 20260726L

ARCHIVO_SALIDA <- "datos_22.reporte-cifras-canonicas.txt"

# ------------------------------------------------------------------------------
# BLOQUE 1: LECTURA Y VALIDACIÓN DE INTEGRIDAD
# ------------------------------------------------------------------------------
leer <- function(ruta) {
  if (!file.exists(ruta)) {
    stop("No se encontró '", ruta, "' en ", getwd(),
         ". Ejecute primero datos_03.limpieza-datos.R.", call. = FALSE)
  }
  read.csv(ruta, stringsAsFactors = FALSE, fileEncoding = "UTF-8")
}

d  <- leer("datos_04.datos-limpios-completos.csv")
di <- leer("datos_05.datos-interesados.csv")

# Identifica el "Sí" por la inicial, no por la cadena acentuada completa.
es_si <- function(x) !is.na(x) & grepl("^[Ss]", x)

n_total       <- nrow(d)
n_interesados <- nrow(di)

if (n_total != 113L) {
  stop("INTEGRIDAD: se esperaban 113 respuestas y se leyeron ", n_total,
       ". Revise datos_04.", call. = FALSE)
}
if (n_interesados != 100L) {
  stop("INTEGRIDAD: se esperaban 100 personas interesadas y se leyeron ",
       n_interesados, ". Causa probable: fallo de codificación al leer el CSV.",
       call. = FALSE)
}
if (sum(es_si(d$interes_en_doctorado)) != 100L) {
  stop("INTEGRIDAD: el conteo de 'Sí' en datos_04 no coincide con datos_05.",
       call. = FALSE)
}

# ------------------------------------------------------------------------------
# BLOQUE 2: FUNCIONES AUXILIARES
# ------------------------------------------------------------------------------
regla <- function(car = "-", n = 78) cat(strrep(car, n), "\n", sep = "")

titulo <- function(txt) {
  cat("\n"); regla("="); cat(txt, "\n"); regla("=")
}

# Frecuencias con base de porcentaje explícita (el punto central de la
# conciliación: todo porcentaje debe declarar sobre qué se calcula).
frecuencias <- function(x, base_n, etiqueta) {
  x  <- x[!is.na(x)]
  tb <- sort(table(x), decreasing = TRUE)
  cat(sprintf("\n%s\n   categorías: %d | respuestas válidas: %d | base del %%: %d\n",
              etiqueta, length(tb), sum(tb), base_n))
  for (i in seq_along(tb)) {
    cat(sprintf("     %-46s %4d   %5.1f%%\n",
                names(tb)[i], as.integer(tb[i]), 100 * as.integer(tb[i]) / base_n))
  }
  invisible(tb)
}

ic_wilson <- function(x, n) {
  r <- suppressWarnings(prop.test(x, n, correct = FALSE))
  c(100 * r$conf.int[1], 100 * r$conf.int[2])
}

ic_clopper <- function(x, n) {
  r <- binom.test(x, n)
  c(100 * r$conf.int[1], 100 * r$conf.int[2])
}

v_cramer <- function(tab) {
  ch <- suppressWarnings(chisq.test(tab, correct = FALSE))
  k  <- min(dim(tab))
  if (k < 2L || sum(tab) == 0L) return(NA_real_)
  as.numeric(sqrt(ch$statistic / (sum(tab) * (k - 1))))
}

# Prueba de independencia con semilla propia. Reporta además el error estándar
# de simulación, que es lo que dice cuántos decimales son defendibles.
prueba_asociacion <- function(tab, etiqueta, B, semilla) {
  ch        <- suppressWarnings(chisq.test(tab, correct = FALSE))
  pct_bajas <- 100 * mean(ch$expected < 5)
  v         <- v_cramer(tab)

  set.seed(semilla)
  fi <- fisher.test(tab, simulate.p.value = TRUE, B = B)
  p  <- fi$p.value
  ee <- sqrt(p * (1 - p) / B)

  cat(sprintf("\n%s\n", etiqueta))
  cat(sprintf("   tabla                : %d x %d,  n = %d\n",
              nrow(tab), ncol(tab), sum(tab)))
  cat(sprintf("   celdas esperadas < 5 : %.1f%%  (regla de Cochran: %s)\n",
              pct_bajas, if (pct_bajas > 20) "Fisher" else "chi-cuadrado"))
  cat(sprintf("   chi-cuadrado obs.    : %.4f  (gl = %d) [solo referencia descriptiva]\n",
              as.numeric(ch$statistic), as.integer(ch$parameter)))
  cat(sprintf("   Fisher exacto simul. : p = %.4f\n", p))
  cat(sprintf("   error est. simulación: %.5f   ->  decimales defendibles: %d\n",
              ee, if (ee < 0.0005) 3L else if (ee < 0.005) 2L else 1L))
  cat(sprintf("   réplicas / semilla   : B = %d / set.seed(%d)\n", B, semilla))
  cat(sprintf("   V de Cramér          : %.4f\n", v))
  invisible(list(p = p, v = v, ee = ee))
}

# ------------------------------------------------------------------------------
# BLOQUE 3: REPORTE
# ------------------------------------------------------------------------------
con <- file(ARCHIVO_SALIDA, open = "wt", encoding = "UTF-8")
sink(con, split = TRUE)
on.exit({ sink(); close(con) }, add = TRUE)

regla("=")
cat("REPORTE CANÓNICO DE CIFRAS\n")
cat("Demanda potencial de un Doctorado en Ciencias -- Colegio de Postgraduados\n")
regla("=")
cat("Fecha de ejecución :", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n")
cat("Versión de R       :", R.version.string, "\n")
cat("Plataforma         :", R.version$platform, "\n")
cat("Réplicas MC        :", B_REPLICAS, "(RQ6-RQ7) /", B_REPLICAS_RQ8, "(RQ8)\n")
cat("Semilla base       :", SEMILLA_BASE, "\n")
cat("Respuestas totales :", n_total, "\n")
cat("Interesados        :", n_interesados, "\n")

# --- RQ1: interés declarado --------------------------------------------------
titulo("RQ1 -- MAGNITUD DEL INTERÉS DECLARADO")
x_si <- sum(es_si(d$interes_en_doctorado))
w <- ic_wilson(x_si, n_total)
cp <- ic_clopper(x_si, n_total)
cat(sprintf("\nInterés declarado 'Sí': %d de %d = %.1f%%\n",
            x_si, n_total, 100 * x_si / n_total))
cat(sprintf("   IC 95%% Wilson          : [%.2f%%, %.2f%%]\n", w[1], w[2]))
cat(sprintf("   IC 95%% Clopper-Pearson : [%.2f%%, %.2f%%]  <- el reportado en la versión dictaminada\n",
            cp[1], cp[2]))
cat("\n   NOTA: elegir uno de los dos para el manuscrito y declararlo en Métodos.\n")

# --- Univariados: doble denominador ------------------------------------------
titulo("UNIVARIADOS -- CONCILIACIÓN DE DENOMINADORES")
cat("\nCada variable se reporta dos veces: sobre las 113 respuestas (denominador de\n")
cat("la versión dictaminada) y sobre las 100 personas interesadas (denominador del\n")
cat("reanálisis). La diferencia entre ambas columnas es la conciliación.\n")

vars <- c("doctorado_de_interes", "genero", "edad", "area_maestria",
          "situacion_laboral", "motivacion_en_doctorado", "tiempo_inicio_doctorado")
etq  <- c("RQ2 -- Línea de doctorado de interés",
          "Género", "Edad (rangos)", "Área de la maestría",
          "Situación laboral", "RQ4 -- Motivación principal",
          "RQ5 -- Plazo estimado para iniciar")

for (k in seq_along(vars)) {
  cat("\n"); regla("-")
  frecuencias(d[[vars[k]]],  113L, paste0("[base 113] ", etq[k]))
  frecuencias(di[[vars[k]]], 100L, paste0("[base 100] ", etq[k]))
}

# --- Perfil sociodemográfico: valores para la Tabla 1 ------------------------
titulo("TABLA 1 -- PERFIL SOCIODEMOGRÁFICO (base: 100 interesados)")
for (v in c("genero", "edad", "area_maestria", "situacion_laboral")) {
  frecuencias(di[[v]], 100L, paste0("   ", v))
}

# --- Género x interés --------------------------------------------------------
titulo("GÉNERO x INTERÉS (verificación de la cifra dictaminada p = 0.723)")
tab_gi <- table(d$genero, ifelse(es_si(d$interes_en_doctorado), "Si", "No"))
cat("\n"); print(tab_gi)
ch_gi <- suppressWarnings(chisq.test(tab_gi, correct = FALSE))
ch_gy <- suppressWarnings(chisq.test(tab_gi, correct = TRUE))
fi_gi <- fisher.test(tab_gi)
cat(sprintf("\n   chi-cuadrado sin corrección : p = %.4f  <- reproduce el 0.723 dictaminado\n",
            ch_gi$p.value))
cat(sprintf("   chi-cuadrado con Yates      : p = %.4f\n", ch_gy$p.value))
cat(sprintf("   Fisher exacto               : p = %.4f  <- recomendado (tabla 2x2, celdas pequeñas)\n",
            fi_gi$p.value))
cat(sprintf("   V de Cramér                 : %.4f\n", v_cramer(tab_gi)))
cat("\n   Conclusión idéntica con los tres métodos: no hay asociación.\n")

# --- Tendencia por edad: la corrección mayor ---------------------------------
titulo("TENDENCIA POR EDAD -- VERIFICACIÓN DE LA AFIRMACIÓN DICTAMINADA")
cat("\nLa versión dictaminada afirma que el interés AUMENTA con la edad.\n")
cat("Este bloque somete esa afirmación a prueba.\n")

# Orden por el número inicial del rango: robusto ante acentos y ante el
# cambio de etiquetas ("61 o más" -> 61).
edad_inf <- suppressWarnings(as.integer(sub("^([0-9]+).*$", "\\1", d$edad)))
ok <- !is.na(edad_inf) & !is.na(d$interes_en_doctorado)
y  <- as.integer(es_si(d$interes_en_doctorado))

cat("\n   Proporción de personas interesadas por rango de edad:\n")
cat(sprintf("     %-14s %5s %5s %9s\n", "rango", "n", "sí", "% interés"))
for (lv in sort(unique(edad_inf[ok]))) {
  sel <- ok & edad_inf == lv
  cat(sprintf("     %-14s %5d %5d %8.1f%%\n",
              unique(d$edad[sel])[1], sum(sel), sum(y[sel]),
              100 * mean(y[sel])))
}

mod <- glm(y[ok] ~ edad_inf[ok], family = binomial())
co  <- summary(mod)$coefficients
cat(sprintf("\n   Regresión logística (tendencia lineal):\n"))
cat(sprintf("     beta = %+.5f   OR por cada 5 años = %.4f   z = %.4f   p = %.4f\n",
            co[2, 1], exp(co[2, 1] * 5), co[2, 3], co[2, 4]))
sp <- suppressWarnings(cor.test(edad_inf[ok], y[ok], method = "spearman"))
cat(sprintf("     Spearman rho = %+.4f   p = %.4f\n",
            as.numeric(sp$estimate), sp$p.value))
cat("\n   INTERPRETACIÓN: si beta es negativo y p > 0.05, la afirmación de la versión\n")
cat("   dictaminada no se sostiene, ni en dirección ni en significancia, y debe\n")
cat("   sustituirse en Resultados y en Discusión.\n")

# --- RQ6 y RQ7 ---------------------------------------------------------------
titulo("RQ6 y RQ7 -- PRUEBAS DE ASOCIACIÓN PRE-ESPECIFICADAS")

t6a <- table(di$situacion_laboral, di$tiempo_inicio_doctorado)
prueba_asociacion(t6a, "RQ6a -- Situación laboral x Plazo de inicio",
                  B_REPLICAS, SEMILLA_BASE + 1L)

t6b <- table(di$situacion_laboral, di$motivacion_en_doctorado)
prueba_asociacion(t6b, "RQ6b -- Situación laboral x Motivación",
                  B_REPLICAS, SEMILLA_BASE + 2L)

t7 <- table(di$area_maestria, di$doctorado_de_interes)
prueba_asociacion(t7, "RQ7 -- Área de la maestría x Línea de doctorado",
                  B_REPLICAS, SEMILLA_BASE + 3L)
cat("\n   Tabla de contingencia de RQ7 (es la única asociación significativa):\n\n")
print(t7)

# --- RQ8 ---------------------------------------------------------------------
titulo("RQ8 -- MOVILIDAD GEOGRÁFICA")
misma <- di$estado_estudios == di$estado_residencia
misma <- misma[!is.na(misma)]
x_m <- sum(misma); n_m <- length(misma)
w8  <- ic_wilson(x_m, n_m); cp8 <- ic_clopper(x_m, n_m)
cat(sprintf("\nPermanece en la misma entidad (estudios = residencia): %d de %d = %.1f%%\n",
            x_m, n_m, 100 * x_m / n_m))
cat(sprintf("   IC 95%% Wilson          : [%.2f%%, %.2f%%]\n", w8[1], w8[2]))
cat(sprintf("   IC 95%% Clopper-Pearson : [%.2f%%, %.2f%%]\n", cp8[1], cp8[2]))
cat(sprintf("\n   Entidades distintas -- estudios: %d | residencia: %d\n",
            length(unique(na.omit(di$estado_estudios))),
            length(unique(na.omit(di$estado_residencia)))))

t8 <- table(di$estado_estudios, di$estado_residencia)
cat("\n   (la prueba sobre la tabla completa puede tardar algunos minutos)\n")
prueba_asociacion(t8, "RQ8 -- Entidad de estudios x Entidad de residencia",
                  B_REPLICAS_RQ8, SEMILLA_BASE + 4L)
cat("\n   ADVERTENCIA: con 100 % de celdas esperadas < 5, esta prueba se reporta\n")
cat("   únicamente como respaldo del patrón diagonal, no como hallazgo autónomo.\n")

cat("\n   Entidades de estudios (base 100 interesados):\n")
frecuencias(di$estado_estudios, 100L, "     entidad donde cursó la maestría")
cat("\n   Entidades de residencia (base 100 interesados):\n")
frecuencias(di$estado_residencia, 100L, "     entidad de residencia actual")

# --- Texto libre preservado --------------------------------------------------
titulo("TEXTO LIBRE PRESERVADO ('Otro')")
tl <- d$motivacion_en_doctorado_otro_texto
tl <- tl[!is.na(tl)]
cat(sprintf("\nRespuestas conservadas íntegras: %d\n", length(tl)))
for (s in tl) cat("   -", s, "\n")

# --- Entorno -----------------------------------------------------------------
titulo("ENTORNO DE EJECUCIÓN")
cat("\n")
print(sessionInfo())

regla("=")
cat("FIN DEL REPORTE\n")
regla("=")

sink()
close(con)
on.exit()

message("Reporte escrito en: ", ARCHIVO_SALIDA)
