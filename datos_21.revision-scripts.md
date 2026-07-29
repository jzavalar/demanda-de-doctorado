# Revisión de los scripts de limpieza y análisis

**Alcance:** `datos_03.limpieza-datos.R`, `datos_12.analisis-descriptivo.R`,
`datos_13.mapa-entidades.R`, `datos_19.mca-exploratorio.R`
**Propósito:** detectar errores antes de ejecutar la corrida canónica en Fedora 44.

**Advertencia de método.** Este contenedor no tiene R instalado, así que **no ejecuté los
scripts**: hice lectura de código y verifiqué su comportamiento esperado recalculando los
resultados de forma independiente en Python, desde los mismos CSV. Todo lo que afirmo sobre
las cifras está verificado; todo lo que afirmo sobre el comportamiento del código es
inferencia de lectura, y así lo marco donde corresponde.

---

## Resumen

| Severidad | Hallazgo |
|---|---|
| 🔴 Alta | **A1** — Réplicas Monte Carlo insuficientes para los decimales que se reportan |
| 🔴 Alta | **A2** — Semilla única: los p-valores dependen del orden de ejecución |
| 🟠 Media | **B1** — `encoding=` en lugar de `fileEncoding=`: riesgo de fallo silencioso |
| 🟠 Media | **B2** — Ninguna aserción de integridad sobre el número de registros |
| 🟡 Baja | **B3** — Asignación por índice lógico que aborta si aparece un `NA` |
| 🟡 Baja | **B4** — Patrón `^si$` frágil ante el acento |
| 🟡 Baja | **A3** — `estadistico` queda `NA` en toda prueba de Fisher |
| ⚪ Decisión | **C1–C3** — Puntos metodológicos a confirmar, no errores |

**La limpieza está correcta.** Tracé las seis variables recodificadas categoría por categoría a
través de cada expresión regular, contra los valores crudos reales, y el resultado reproduce
exactamente el archivo publicado. Detalle en la sección D.

---

## A. Errores que afectan cifras publicadas

### 🔴 A1 — Réplicas Monte Carlo insuficientes. **Esta es la causa de las divergencias.**

En `datos_12`, línea 100:

```r
probar_asociacion <- function(tab, B_simulacion = 5000) {
```

y línea 320, para RQ8:

```r
r_geo <- probar_asociacion(tab_geo, B_simulacion = 2000)
```

Son **5 000 réplicas** para RQ6–RQ7 y **2 000** para RQ8. El manuscrito lo declara con
honestidad (`datos_18`, línea 143), así que no hay problema de transparencia. El problema es de
precisión.

Con B = 5 000 y p ≈ 0.29, el error estándar de simulación es

    √(0.29 × 0.71 / 5000) = 0.0064

de modo que dos corridas legítimas del mismo código sobre los mismos datos pueden devolver
cualquier valor entre **0.275 y 0.301** con 95 % de probabilidad. Los dos valores que aparecen
en el repositorio —0.278 y 0.297— caen ambos dentro de ese rango.

**No hay error de cálculo. Hay un tercer decimal que el procedimiento no puede sostener.** Y sin
embargo el script lo reporta: línea 297 `p_valor = signif(r$p_valor, 3)` y línea 301
`p=%.3f`.

Esto importa más de lo que parece en este artículo en particular. Si el argumento de método es
que cualquiera puede reproducir cada cifra, publicar un decimal que cambia entre corridas es
justamente lo que un árbitro escéptico buscaría.

**Corrección:** elevar a 200 000 réplicas. El error estándar baja a 0.001 y el tercer decimal se
estabiliza. El costo es de segundos para las tablas de RQ6–RQ7.

```r
# ANTES
probar_asociacion <- function(tab, B_simulacion = 5000) {

# DESPUÉS
probar_asociacion <- function(tab, B_simulacion = 200000) {
```

```r
# ANTES  (línea 320)
r_geo <- probar_asociacion(tab_geo, B_simulacion = 2000)

# DESPUÉS
r_geo <- probar_asociacion(tab_geo, B_simulacion = 50000)
```

La tabla de RQ8 es de 17 × 24, así que 50 000 réplicas ya tardan un poco; es suficiente para
estabilizar dos decimales, que es todo lo que necesita una prueba que el propio manuscrito
interpreta con cautela.

### 🔴 A2 — Semilla única al inicio: los p-valores dependen del orden de ejecución

`datos_12` fija `set.seed(20260726)` una sola vez, en la línea 38. Las cuatro pruebas simuladas
consumen números aleatorios en secuencia, así que **el p-valor de cada prueba depende de cuántos
números aleatorios consumieron las anteriores**.

Consecuencia práctica: si mañana se agrega un cruce a la lista `cruces`, se reordena esa lista, o
se elimina una prueba, **todos los p-valores posteriores cambian** — aunque los datos y el método
sean idénticos. Para un artículo cuyo aporte metodológico declarado es la trazabilidad, éste es
el punto más frágil del repositorio.

**Corrección:** sembrar inmediatamente antes de cada llamada a `fisher.test`, con una semilla
derivada del identificador de la prueba. Así cada p-valor queda anclado a *su* prueba y es
inmune al orden.

```r
# ANTES  (dentro de probar_asociacion)
probar_asociacion <- function(tab, B_simulacion = 5000) {
  ...
      f <- tryCatch(
        fisher.test(tab, simulate.p.value = TRUE, B = B_simulacion),
        error = function(e) NULL
      )

# DESPUÉS
probar_asociacion <- function(tab, B_simulacion = 200000, semilla = 20260726) {
  ...
      set.seed(semilla)          # ancla el p-valor a esta prueba, no al orden de ejecución
      f <- tryCatch(
        fisher.test(tab, simulate.p.value = TRUE, B = B_simulacion),
        error = function(e) NULL
      )
```

y pasar una semilla distinta por cruce, p. ej. `probar_asociacion(tab, semilla = 20260726L + 1L)`
para RQ6a, `+ 2L` para RQ6b, y así. Cualquier esquema sirve mientras quede documentado.

### 🟡 A3 — `estadistico` queda `NA` en toda prueba de Fisher

En la rama Fisher (líneas 114–116) se asignan `prueba` y `p_valor`, pero nunca `estadistico`, que
conserva el `NA_real_` de la inicialización. Por eso la columna "Estadístico" aparece vacía en la
Tabla 2 del manuscrito.

Es defendible —la prueba exacta de Fisher no tiene un estadístico de contraste convencional— pero
conviene que el manuscrito lo diga en la nota al pie de la tabla en vez de dejar un guion sin
explicación. Alternativa: reportar ahí el χ² observado como referencia descriptiva, dejando claro
que el p-valor no proviene de él.

---

## B. Riesgos de fallo silencioso

### 🟠 B1 — `encoding=` no hace lo que parece

Aparece en los cuatro scripts:

```r
d <- read.csv(ruta_datos, stringsAsFactors = FALSE, encoding = "UTF-8")
```

En `read.csv`, el argumento `encoding` **no reconvierte** el archivo: solo *declara* que las
cadenas resultantes ya están en esa codificación. El argumento que efectivamente reconvierte es
`fileEncoding`. En Linux con locale UTF-8 funciona por coincidencia, porque la codificación
nativa ya es UTF-8.

El riesgo es concreto porque el repositorio incluye un instalador para Windows
(`datos_09.instalar-entorno-windows.ps1`). Bajo una codificación nativa distinta,
`filter(interes_en_doctorado == "Sí")` no coincidiría con nada, `d_interesados` quedaría con cero
filas, y **el script terminaría sin error**, produciendo figuras vacías y tablas de ceros. Un
fallo que no se anuncia es peor que uno que aborta.

```r
# ANTES
read.csv(ruta_datos, stringsAsFactors = FALSE, encoding = "UTF-8")

# DESPUÉS
read.csv(ruta_datos, stringsAsFactors = FALSE, fileEncoding = "UTF-8")
```

Y en el filtro, evitar depender del acento:

```r
# ANTES
d_interesados <- d %>% filter(interes_en_doctorado == "Sí")

# DESPUÉS
d_interesados <- d %>% filter(grepl("^S", interes_en_doctorado))
```

### 🟠 B2 — Ninguna aserción de integridad

`datos_03` sí valida que el número de filas no cambie durante la limpieza (línea 246), lo cual
está bien. Pero `datos_12`, `datos_13` y `datos_19` no verifican nada: aceptan lo que venga en el
CSV. Combinado con B1, eso es lo que permite que un fallo de codificación pase inadvertido.

Añadir después de la línea 66 de `datos_12`:

```r
stopifnot(
  "El total de respuestas no es 113 — revise datos_04"       = n_total == 113L,
  "Las personas interesadas no son 100 — posible fallo de codificación al leer el CSV"
                                                              = n_interesados == 100L
)
```

Un fallo ruidoso en el segundo 3 de la ejecución vale más que una figura vacía descubierta en la
revisión de galeras.

### 🟡 B3 — Asignación por índice lógico que aborta ante un `NA`

`datos_03`, línea 188:

```r
datos$doctorado_de_interes[datos$interes_en_doctorado == "No"] <- NA_character_
```

Si `interes_en_doctorado` contuviera algún `NA`, la comparación produce `NA` y R aborta con
*"NAs are not allowed in subscripted assignments"*. Hoy no ocurre porque las 113 respuestas
tienen valor, pero el script está escrito para ser reejecutable sobre datos futuros.

```r
# DESPUÉS
datos$doctorado_de_interes[which(datos$interes_en_doctorado == "No")] <- NA_character_
```

`which()` descarta los `NA` en lugar de propagarlos.

### 🟡 B4 — El patrón `^si$` es frágil ante el acento

`datos_03`, línea 182:

```r
patrones = c("^si$|^s$|^yes$|^y$", "^no$|^n$"),
```

El dato crudo actual es `Si` sin acento, así que funciona. Pero si una recolección futura trajera
`Sí`, `str_to_lower()` daría `sí`, que **no** coincide con `^si$`, y esas respuestas caerían en
la categoría `"Otro"` sin que nada lo advierta: el conteo de interesados se desplomaría en
silencio.

```r
# DESPUÉS
patrones = c("^s[ií]$|^yes$|^y$", "^no$|^n$"),
```

---

## C. Decisiones metodológicas a confirmar (no son errores)

**C1 — Wilson vs. Clopper-Pearson.** `wilson_ci()` usa `prop.test(correct = FALSE)`, que es
Wilson sin corrección por continuidad: implementación correcta. El punto abierto es cuál reportar,
ya planteado en el documento de conciliación. Mi recomendación sigue siendo Clopper-Pearson, para
coincidir con el intervalo ya dictaminado.

**C2 — La regla de Cochran está bien implementada.** `pct_bajas > 20` sobre `chi$expected`
reproduce el criterio estándar. Sin observaciones.

**C3 — Género × interés.** El manuscrito dictaminado reporta p = 0.723, que reproduje al cuarto
decimal (0.7228) con χ² sin corrección de continuidad. Pero la tabla es 2×2 con celdas de 6 y 7,
donde lo apropiado es Fisher exacto: p = 0.771. La conclusión no cambia —independencia en ambos
casos— y por coherencia con el resto del análisis convendría usar Fisher y decirlo. Nótese que
este cruce hoy no pasa por `probar_asociacion`, así que la regla de Cochran no se le aplica.

---

## D. Lo que está bien, y conviene no tocar

La limpieza es sólida. Tracé las seis variables recodificadas contra los valores crudos reales:

| Variable | Categorías crudas | Resultado | Estado |
|---|---|---|---|
| `interes_en_doctorado` | `Si` (100), `No` (13) | 100 / 13 | ✅ |
| `genero` | `Femenino` (66), `Masculino` (47) | 66 / 47 | ✅ |
| `situacion_laboral` | 6 categorías, incl. `Trabaja como docente` y `Trabaja como empleado` | 38/24/23/21/5 + 2 `NA` | ✅ |
| `motivacion_en_doctorado` | 6 valores, 3 fuera de catálogo | 61/31/18 + 3 `Otro` | ✅ |
| `tiempo_inicio_doctorado` | 5 categorías | 60/24/19/9/1 | ✅ |
| `area_maestria` | ya precodificada, no se recodifica | 53/32/22/4/2 | ✅ |

El orden de los patrones en `situacion_laboral` es el punto delicado —`"emplead|trabajador"`
aparece antes que `"^solo.*estud"`— y aun así es correcto, porque el rastreador `ya_asignado`
impide la reasignación y ninguna categoría cruda satisface dos patrones. Está bien pensado.

Otros aciertos que conviene preservar: el catálogo auditable de entidades en lugar de coincidencia
difusa; el rastreador `ya_asignado`, que permite mapear una categoría a `NA` sin confundirla con
"no coincidió"; la preservación del texto libre en columnas `_otro_texto`; el esquema de
marcadores de bloque en `pies-de-figura.md`, que hace idempotente la escritura compartida entre
tres scripts; la altura dinámica de las figuras según el número de categorías; y la ausencia de
títulos incrustados en los PNG, que es lo que pide RIDE.

`datos_13` no usa aleatoriedad en absoluto, así que no requiere semilla. `datos_19` fija la
semilla antes del trazado —necesaria para que `ggrepel` coloque las etiquetas de forma
reproducible—; el MCA en sí es determinista.

---

## E. Orden de ejecución para la corrida canónica

1. Aplicar los parches A1, A2, B1 y B2 a `datos_12`; B3 y B4 a `datos_03`; B1 a `datos_13` y
   `datos_19`.
2. Ejecutar `datos_03` → `datos_12` → `datos_13` → `datos_19`.
3. Ejecutar `datos_22.reporte-cifras-canonicas.R` (adjunto), que imprime en un solo archivo de
   texto todas las cifras que el manuscrito necesita.
4. Compartirme ese archivo de texto y el `sessionInfo()`.
5. Ejecutar todo una segunda vez y confirmar que el reporte es idéntico byte a byte.

El paso 3 existe para que no tenga que enviarme dieciocho hojas de Excel: el script emite un solo
reporte compacto con cada número que va a aparecer en Resultados.
