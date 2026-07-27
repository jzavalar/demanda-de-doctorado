# Datos y Scripts de Procesamiento para el Artículo *Demanda Potencial para un Doctorado en Ciencias en Paisaje y Rurismo Rural*

**Institución responsable:** Colegio de Postgraduados, Campus Córdoba
**Responsable del proyecto de investigación:** Dra. Obdulia Baltazar Bernal — [obduliabb@colpos.mx](mailto:obduliabb@colpos.mx)
**Responsable del repositorio y sus productos:** Dr. Jesús Zavala Ruiz — [jzr@xanum.uam.mx](mailto:jzr@xanum.uam.mx)
**Periodo de levantamiento:** 4 de abril de 2024 – 7 de mayo de 2024
**N total de respuestas:** 113 (100 con interés declarado en cursar el doctorado)
**Licencia:** [CC BY 4.0](LICENSE.txt)
**Última actualización de este repositorio:** 27 de julio de 2026

> Este repositorio acompaña al artículo derivado de esta investigación y se publica para dar
> cumplimiento a la transparencia de datos, métodos y materiales solicitada por la revista de
> destino ([RIDE](https://www.ride.org.mx/)), y para que cualquier persona pueda **reproducir
> de principio a fin** el proceso de preparación de los datos previo a su análisis y su
> posterior procesamiento.

---

## 1. Contenido del repositorio

Todos los archivos de datos y de código siguen la nomenclatura `datos_NN.nombre-descriptivo.ext`,
numerados en el orden lógico del flujo de trabajo (00 = insumos de origen → 08 = trazabilidad
del entorno de ejecución). `README.md` y `LICENSE.txt` son la excepción intencional: se dejan
con esos nombres porque GitHub y la mayoría de los repositorios de datos los reconocen y
despliegan de forma especial en esa forma exacta.

| # | Archivo | Qué es | Formato |
|---|---|---|---|
| 00 | [`datos_00.instrumento-cuestionario.docx`](datos_00.instrumento-cuestionario.docx) | Instrumento de levantamiento de datos (cuestionario original) | Word |
| 00 | [`datos_00.instrumento-cuestionario.md`](datos_00.instrumento-cuestionario.md) | Transcripción en texto plano del instrumento, para lectura rápida en GitHub | Markdown |
| 01 | [`datos_01.datos-brutos-cuestionario.xlsx`](datos_01.datos-brutos-cuestionario.xlsx) | Respuestas crudas del formulario, **sin ninguna transformación** | Excel |
| 01 | [`datos_01.datos-brutos-cuestionario.csv`](datos_01.datos-brutos-cuestionario.csv) | Mismo contenido que el anterior, en texto plano UTF-8 | CSV |
| 02 | [`datos_02.catalogo-estandarizacion-entidades.csv`](datos_02.catalogo-estandarizacion-entidades.csv) | Tabla de equivalencias auditable para nombres de entidades federativas (acentos, espacios, casos ambiguos) usada por el script de limpieza | CSV |
| 03 | [`datos_03.limpieza-datos.R`](datos_03.limpieza-datos.R) | **Script de limpieza y estandarización**, comentado y automatizado en 3 pasos | R |
| 04 | [`datos_04.datos-limpios-completos.csv`](datos_04.datos-limpios-completos.csv) · [`.xlsx`](datos_04.datos-limpios-completos.xlsx) · [`.rds`](datos_04.datos-limpios-completos.rds) | Datos limpios, las 113 respuestas | CSV / Excel / R nativo |
| 05 | [`datos_05.datos-interesados.csv`](datos_05.datos-interesados.csv) · [`.rds`](datos_05.datos-interesados.rds) | Subconjunto de 04 filtrado a `interes_en_doctorado = "Sí"` (100 respuestas) | CSV / R nativo |
| 06 | [`datos_06.diccionario-datos.xlsx`](datos_06.diccionario-datos.xlsx) | **Diccionario de datos completo**: variables, codebook de recodificación, estadísticas descriptivas | Excel (5 hojas) |
| 07 | [`datos_07.reporte-validacion-limpieza.md`](datos_07.reporte-validacion-limpieza.md) | Reporte de auditoría del proceso de limpieza: hallazgos y su resolución | Markdown |
| 08 | `datos_08.sesion-r-reproducibilidad.txt` | Versión de R y de cada paquete usada para generar los archivos (se genera automáticamente al correr el script) | Texto plano |
| 09 | [`datos_09.instrucciones-entorno-windows-linux.md`](datos_09.instrucciones-entorno-windows-linux.md) | Instrucciones para reproducir el entorno de R **y de RStudio Desktop** en Windows 11, Ubuntu 24 y Fedora 44 (manual y automatizado, con solución de fallas) | Markdown |
| 09 | [`datos_09.instalar-entorno-windows.ps1`](datos_09.instalar-entorno-windows.ps1) | Script de instalación automatizada del entorno (R + RStudio vía winget, con respaldo de descarga directa), a prueba de fallas, para Windows 11 | PowerShell |
| 09 | [`datos_09.instalar-entorno-ubuntu.sh`](datos_09.instalar-entorno-ubuntu.sh) | Script de instalación automatizada del entorno (R + RStudio), a prueba de fallas, para Ubuntu 24.04 LTS | Bash |
| 09 | [`datos_09.instalar-entorno-fedora.sh`](datos_09.instalar-entorno-fedora.sh) | Script de instalación automatizada del entorno (R + RStudio vía Copr `iucar/rstudio`), a prueba de fallas, para Fedora Linux 44 | Bash |
| 10 | [`datos_10.verificar-reproducibilidad.R`](datos_10.verificar-reproducibilidad.R) | Compara los archivos clonados/publicados contra los que regenera `datos_03.limpieza-datos.R` al volver a correrlo, para confirmar reproducibilidad byte a byte | R |
| 11 | [`datos_11.plan-analisis-datos.md`](datos_11.plan-analisis-datos.md) | Plan de análisis de datos argumentado (preguntas de investigación, decisiones estadísticas, etapas) previo a los scripts de análisis | Markdown |
| 12 | [`datos_12.analisis-descriptivo.R`](datos_12.analisis-descriptivo.R) | Script de análisis: descriptivo univariado, bivariado (RQ6-RQ8) con pruebas de asociación, perfil síntesis y revisión del texto libre preservado | R |
| 13 | [`datos_13.mapa-entidades.R`](datos_13.mapa-entidades.R) | Script de mapas coropléticos por entidad (estudios y residencia) | R |
| 13 | [`datos_13.geojson-entidades-mexico.geojson`](datos_13.geojson-entidades-mexico.geojson) | Geometrías de los 32 estados de México, disueltas a nivel estatal a partir de los shapefiles municipales CONABIO 2020-2023 (PhantomInsights, MIT — referencia completa en [`datos_17`](datos_17.referencias-bibliograficas.md)), guardadas localmente para que el mapa no dependa de una fuente en línea | GeoJSON |
| 14 | [`datos_14.tablas-resultados.xlsx`](datos_14.tablas-resultados.xlsx) | Todas las tablas de resultados (18 hojas: proporciones clave, univariado, bivariado, perfil síntesis, texto libre) | Excel |
| 15 | [`datos_15.figuras/`](datos_15.figuras) — ver su [README](datos_15.figuras/README.md) | Las 17 figuras (`.png`) del análisis descriptivo, bivariado, los mapas y el panorama exploratorio MCA, más `pies-de-figura.md` (texto listo para pegar en el artículo, formato RIDE) y las tablas de apoyo en CSV (mapas y MCA) | PNG / Markdown / CSV |
| 16 | [`datos_16.validacion-figuras-manuscrito.md`](datos_16.validacion-figuras-manuscrito.md) | Clasifica las 15 figuras generadas en esenciales (7) vs. redundantes con tabla ya existente (8), y valida su diseño contra los criterios editoriales de RIDE — el hallazgo de formato que documentaba (título incrustado en el PNG) ya está corregido | Markdown |
| 17 | [`datos_17.referencias-bibliograficas.md`](datos_17.referencias-bibliograficas.md) | Referencias en formato APA 7: fuentes de datos externas (geojson) y herramientas de software (R, RStudio, 9 paquetes), listas para copiar a la sección de Referencias del artículo | Markdown |
| 18 | [`datos_18.borrador-metodologia-resultados.md`](datos_18.borrador-metodologia-resultados.md) | **Primera versión completa** de Materiales y Métodos, Resultados y Discusión del manuscrito, con la numeración final de figuras/tablas y el MCA integrado, para revisión del equipo antes de pasarlo al documento de Word | Markdown |
| 19 | [`datos_19.mca-exploratorio.R`](datos_19.mca-exploratorio.R) | Análisis de correspondencias múltiples (MCA), panorama exploratorio de las 6 variables de demanda, para presentarse al inicio de Resultados | R |
| — | [`LICENSE.txt`](LICENSE.txt) | Licencia y forma de citar el conjunto de datos | Texto plano |

## 2. El instrumento

El cuestionario (`datos_00.instrumento-cuestionario.*`) se aplicó en línea (Google Forms) y
consta de 10 preguntas: interés e línea de doctorado, género, edad por rangos, entidad de
estudios y de residencia, maestría e institución de origen, situación laboral, motivación y
plazo estimado para iniciar el doctorado. El detalle pregunta-por-pregunta y una nota sobre
una diferencia menor entre el documento y el formulario en línea están en la transcripción
Markdown.

## 3. Proceso de limpieza de datos (2 pasos)

El script `datos_03.limpieza-datos.R` implementa el criterio acordado con el equipo de
investigación: **estandarizar sin perder significado ni riqueza de la información**.

**Paso 1 — Reglas de estandarización**
- Normalización de texto (Unicode NFC + recorte/colapso de espacios) en todas las columnas.
- Estandarización de entidades federativas mediante un catálogo explícito y auditable
  (`datos_02.catalogo-estandarizacion-entidades.csv`), no por adivinación con expresiones
  regulares — cada equivalencia (p. ej. "Michoacan" → "Michoacán", "México" → "Estado de
  México") queda documentada con su justificación.
- Manejo explícito del dato faltante: se usa `NA` únicamente cuando la persona genuinamente
  no respondió o la pregunta no le aplicaba (lógica de salto del cuestionario). Una respuesta
  libre que sí existe pero no encaja en ninguna categoría predefinida **nunca** se convierte en
  `NA`: se marca `"Otro"` y su texto original se conserva íntegro en una columna espejo
  `..._otro_texto`.

**Paso 2 — Automatización y validación**
- Lectura y validación de estructura (columnas esperadas) con manejo de errores por bloque.
- Recodificación de variables categóricas con reglas estrictas, una por una, para no fusionar
  respuestas con significados distintos (p. ej. "Indefinido" se mantiene separado de un dato
  faltante real; "Sector privado" ya no se agrupa con "Aplicación en campo").
- Validación de integridad automática: el script se detiene si el número de filas cambia
  respecto al archivo crudo.

**Paso 3 — Exportación en 3 formatos:** `.csv` (uso general), `.xlsx` (revisión manual /
coautores) y `.rds` (formato nativo de R, conserva los tipos de dato exactos).

El detalle completo de cada hallazgo de la auditoría y su resolución está en
[`datos_07.reporte-validacion-limpieza.md`](datos_07.reporte-validacion-limpieza.md).

## 4. Hallazgos principales (resumen)

| Hallazgo | Resolución |
|---|---|
| "Michoacán" / "Michoacan" como categorías distintas | Unificadas vía catálogo |
| "México" ambiguo en estado de residencia | Resuelto como "Estado de México" (decisión documentada) |
| "Sector privado" fusionado con "Aplicación en campo" | Separado; ahora es `"Otro"` + texto original preservado |
| "Indefinido" fusionado con "No especifica" | "Indefinido" es ahora categoría propia |
| "No contesto" como texto literal | Convertido a `NA` real |
| Espacios en blanco en nombres de entidades | Corregidos y ahora documentados en el script |

Ningún hallazgo implicó pérdida de registros: las 113 respuestas se conservan íntegras en
todo el proceso (verificado automáticamente por el script).

## 5. Diccionario de datos

`datos_06.diccionario-datos.xlsx` contiene 5 hojas:

1. **Portada** — presentación general y cómo usar el archivo.
2. **Variables** — catálogo de las 13 variables originales: tipo, pregunta de origen, valores
   posibles, notas de calidad.
3. **Codebook_Recodificacion** — mapeo valor crudo → valor limpio (versión inicial).
4. **Calidad_Datos** — hallazgos completos de la auditoría, con severidad y recomendación.
5. **Codebook_v3_2pasos** — mapeo valor crudo → valor final para las variables rediseñadas en
   el proceso de 2 pasos (situación laboral, motivación, tiempo de inicio, interés, entidad de
   residencia).
6. **Estadisticas_Descriptivas** — frecuencias y porcentajes por variable, listas para citar.

## 6. Cómo reproducir el entorno y la limpieza de datos desde cero

### 6.1 Preparar el entorno (nueva máquina, Windows 11, Ubuntu 24 o Fedora 44)

Para dejar instalado R y todos los paquetes necesarios de forma automatizada y a prueba de
fallas:

```powershell
# Windows 11 (PowerShell, idealmente como Administrador)
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
.\datos_09.instalar-entorno-windows.ps1
```

```bash
# Ubuntu 24.04 LTS
chmod +x datos_09.instalar-entorno-ubuntu.sh && ./datos_09.instalar-entorno-ubuntu.sh

# Fedora Linux 44
chmod +x datos_09.instalar-entorno-fedora.sh && ./datos_09.instalar-entorno-fedora.sh
```

Los tres scripts nunca detienen la instalación ante un fallo aislado: reportan cada paso como
`[OK]`, `[AVISO]` o `[FALLO]`, reintentan automáticamente vía CRAN cualquier paquete que no se
pueda instalar por el medio más rápido de cada sistema, y verifican al final que R pueda cargar
los 6 paquetes antes de declarar éxito. También instalan **RStudio Desktop** de forma opcional:
en Windows, vía `winget` (con respaldo de descarga directa del instalador estable de Posit); en
Ubuntu, descargando el `.deb` estable de Posit; en Fedora, habilitando el repositorio Copr
comunitario [`iucar/rstudio`](https://copr.fedorainfracloud.org/coprs/iucar/rstudio/) e
instalando `rstudio-desktop`. Si ese paso no tiene éxito (p. ej. por falta de conexión en ese
momento), el script lo reporta como `[AVISO]` y continúa: RStudio no es necesario para correr
`datos_03.limpieza-datos.R`, que solo requiere `Rscript`. El detalle completo, la versión
manual paso a paso y una tabla de solución de fallas están en
[`datos_09.instrucciones-entorno-windows-linux.md`](datos_09.instrucciones-entorno-windows-linux.md).

### 6.2 Ejecutar la limpieza de datos

```r
# 1. Clonar o descargar este repositorio completo en una sola carpeta
# 2. Abrir R o RStudio y fijar el directorio de trabajo a esa carpeta:
setwd("ruta/a/este/repositorio")

# 3. Ejecutar el script de limpieza:
source("datos_03.limpieza-datos.R")

# Alternativa desde terminal:
# Rscript datos_03.limpieza-datos.R
```

Requisitos: **R ≥ 4.3**. Los paquetes necesarios (`readxl`, `stringr`, `dplyr`, `writexl`,
`openxlsx`, `stringi`) se instalan automáticamente si faltan. El script:

- Lee `datos_01.datos-brutos-cuestionario.xlsx` y `datos_02.catalogo-estandarizacion-entidades.csv`.
- Genera (o sobrescribe) `datos_04.datos-limpios-completos.*`, `datos_05.datos-interesados.*`
  y `datos_08.sesion-r-reproducibilidad.txt`.
- Se detiene con un mensaje explícito ante cualquier error (columnas faltantes, archivo
  corrupto, pérdida de registros), en vez de fallar en silencio.
- Al terminar exitosamente imprime un reporte con conteos totales, valores `NA` por variable
  y las respuestas libres preservadas en las columnas `..._otro_texto`.

Para verificar bajo qué versión exacta de R y de cada paquete se generaron los archivos aquí
publicados, ver `datos_08.sesion-r-reproducibilidad.txt` (se regenera cada vez que se corre
el script, con fecha y hora de ejecución).

> **Nota:** `datos_09.instalar-entorno-*` deja listas las dependencias de `datos_03` (readxl,
> stringr, dplyr, writexl, openxlsx, stringi). `datos_12.analisis-descriptivo.R` y
> `datos_13.mapa-entidades.R` necesitan además `ggplot2`, `scales`, `tidyr` y `sf`; ambos las
> instalan automáticamente si faltan (mismo mecanismo de auto-instalación que ya usa
> `datos_03`), así que no requieren un paso de entorno aparte — solo conexión a internet la
> primera vez que se corren en una máquina nueva.

### 6.3 Comparar los archivos clonados contra los que genera el script

`datos_10.verificar-reproducibilidad.R` responde a una pregunta distinta a la de 6.2: no solo
si el script corre sin errores, sino si **reproduce exactamente** los archivos que vienen
publicados en este repositorio.

```r
setwd("ruta/a/este/repositorio")
source("datos_10.verificar-reproducibilidad.R")
```

La primera vez que se corre (antes de haber ejecutado `datos_03.limpieza-datos.R` más de una
vez), este script:

1. Guarda una copia de los `datos_04.*`/`datos_05.*` **tal como vinieron publicados/clonados**
   en una carpeta temporal `_verificacion_manual/clonado/`.
2. Vuelve a correr `datos_03.limpieza-datos.R` desde cero (esto sobrescribe
   `datos_04.*`/`datos_05.*` con una versión recién generada).
3. Compara **campo por campo** (no solo byte a byte, para no dar falsos positivos por
   metadatos internos de los `.xlsx`) la copia guardada contra la versión recién generada, y
   reporta `[OK]` o `[DIFERENCIAS]` por cada uno de los 5 archivos.

Este mecanismo fue puesto a prueba deliberadamente antes de publicarse: se alteró a propósito
un valor en la copia de referencia y se confirmó que el script efectivamente reporta
`[DIFERENCIAS]` (no simplemente `[OK]` sin comparar de verdad). Sobre los datos reales de este
proyecto, la comparación confirma que los 5 archivos son idénticos.

La carpeta `_verificacion_manual/` es solo un área de trabajo temporal de esta verificación;
no forma parte de los datos publicados y puede borrarse en cualquier momento sin afectar nada.

## 7. Privacidad

El conjunto de datos no contiene nombres, correos electrónicos ni identificadores directos de
las personas respondientes; solo variables demográficas agregadas por rango (edad) y categoría
(género, entidad, situación laboral). No se identificó riesgo de reidentificación relevante
para su publicación en acceso abierto.

## 8. Licencia y forma de citar

Ver [`LICENSE.txt`](LICENSE.txt). Este material se distribuye bajo **CC BY 4.0**, en
concordancia con la política de acceso abierto de la revista de destino.

## 9. Resultados del análisis (resumen)

Generados por `datos_12.analisis-descriptivo.R` y `datos_13.mapa-entidades.R`, con hallazgos
completos en `datos_14.tablas-resultados.xlsx` y figuras en `datos_15.figuras/`:

- **Interés declarado:** 88.5% de 113 respuestas (IC 95% Wilson: 81.3%–93.2%; medida de
  precisión muestral, no un margen de error poblacional — ver `datos_11`, sección 1).
- **Línea más elegida:** "Manejo y Aprovechamiento del Paisaje Rural", 55.0% de quienes están
  interesados (IC 95% Wilson: 45.2%–64.4%).
- **RQ7 (área de maestría × línea de interés):** asociación estadísticamente significativa
  (Fisher exacto simulado, p=0.037; V de Cramér=0.417, efecto moderado-alto) — el interés
  declarado es coherente con la formación previa, no aspiracional al azar.
- **RQ6 (situación laboral × plazo de inicio / × motivación):** sin asociación estadísticamente
  significativa en esta muestra (p=0.278 y p=0.080 respectivamente); tamaños de efecto
  pequeños-moderados (V=0.211 y V=0.240).
- **RQ8 (movilidad geográfica):** 82.0% de quienes están interesados residen en la misma
  entidad donde cursaron la maestría (IC 95% Wilson: 73.3%–88.3%); la tabla completa
  estado_estudios × estado_residencia muestra una asociación muy fuerte (V de Cramér=0.890),
  esperable dada esa alta permanencia diagonal — se interpreta con cautela por el tamaño y
  dispersión de la tabla (17×24 categorías).

Estos resultados se reportan como **descriptivos de quienes respondieron**, no como estimación
poblacional generalizable, dado el muestreo no probabilístico (ver limitaciones en
`datos_11.plan-analisis-datos.md`).

## 10. Figuras del manuscrito: validación editorial RIDE

`datos_16.validacion-figuras-manuscrito.md` audita las 17 figuras generadas en
`datos_15.figuras/` con el mismo criterio de necesidad que ya se aplicó a los datos: una figura
se conserva solo si visualiza un hallazgo central o un patrón (espacial, de asociación) que
ninguna tabla puede transmitir. Con `datos_14.tablas-resultados.xlsx` ya cubriendo las 18
combinaciones univariadas y bivariadas, el documento aplica ese criterio de forma estricta.

**Resultado de la clasificación:** de las 17 figuras, se conservan **9** como esenciales: el
panorama exploratorio multivariado (MCA, 2 figuras, presentado al inicio de Resultados, antes
de RQ1 — ver sección 11), interés general, línea de doctorado, motivación, plazo de inicio, el
cruce área×línea que sí resultó significativo (RQ7), y los dos mapas coropléticos de RQ8. Las
otras 8 se retiran del manuscrito porque ya están cubiertas por una tabla existente sin pérdida
de información: cuatro variables sociodemográficas simples (género, edad, área de maestría,
situación laboral) se consolidan en una tabla de perfil; dos gráficos de barras por entidad
quedan redundantes frente a los mapas que muestran la misma variable con más patrón visual; y
dos cruces bivariados sin asociación significativa (RQ6) se reportan como tabla de
contingencia, no como figura.

El documento también deja registrado un **hallazgo de formato ya corregido**: al revisar el
código de `datos_12.analisis-descriptivo.R` y `datos_13.mapa-entidades.R` se encontró que el
título de cada figura quedaba dibujado **dentro** del `.png` (vía `labs(title=...)` de
`ggplot2`), lo que lo duplicaba con el título que `pies-de-figura.md` ya genera como texto para
pegar en Word — el mismo problema que se había corregido en una iteración anterior del proyecto
(el análisis de correspondencias múltiples), pero que había reaparecido en estos dos scripts
nuevos. La corrección ya se aplicó a las 15 figuras (se regeneraron todas desde cero) y se
verificó con análisis de imagen (Python/Pillow), no solo visualmente: la franja superior de las
7 figuras esenciales pasó de miles de píxeles oscuros (el texto del título) a cero.

## 11. Panorama exploratorio multivariado (MCA)

`datos_19.mca-exploratorio.R` genera un análisis de correspondencias múltiples (MCA) sobre las
6 variables de demanda (género, edad, área de maestría, situación laboral, motivación, tiempo
de inicio), acordado con el equipo el 26-jul-2026 como **panorama exploratorio al inicio de
Resultados** — antes de RQ1, no como prueba confirmatoria ni como sustituto de las pruebas
pareadas de RQ6-RQ7.

**Resultado:** n = 98 (2 excluidos por dato faltante real en situación laboral). Las dos
primeras dimensiones explican 9.5 % y 7.9 % de la inercia (17.4 % acumulado) — una fracción
modesta de la variabilidad total, por lo que el hallazgo se enmarca explícitamente como
exploratorio, no confirmatorio, en el propio texto (no en una nota al pie). El patrón visible
es coherente con la asociación significativa ya confirmada en RQ7 (área de maestría × línea de
interés).

Al recalcularlo contra los datos actuales (no se reciclaron números de una iteración anterior
del proyecto) se encontraron y corrigieron dos problemas reales en el script compartido por el
equipo: faltaba fijar el *locale* a UTF-8 (producía advertencias de codificación y un error de
parseo), y se cargaba el paquete `factoextra` sin usar ninguna de sus funciones.

**Nota de robustez:** al integrar este script se detectó que `datos_12.analisis-descriptivo.R`
sobrescribía por completo `pies-de-figura.md` sin preservar lo que `datos_13`/`datos_19` ya
hubieran escrito. Los tres scripts ahora usan un esquema de bloques con marcadores que garantiza
el orden final (MCA → `datos_12` → mapas) sin importar en qué orden se ejecuten — verificado
corriendo `datos_12` una segunda vez después de los otros dos y confirmando que no se pierde
nada.

Detalle completo, argumentación de la decisión y relación con un análisis exploratorio más
amplio de una iteración anterior del proyecto (una matriz de V de Cramér entre 15 pares de
variables, no retomada por ser inconsistente con el criterio de no explorar cruces sin pregunta
de investigación pre-especificada) en la sección 8 de
[`datos_11.plan-analisis-datos.md`](datos_11.plan-analisis-datos.md).

## 12. Historial de versiones

| Fecha | Cambio |
|---|---|
| 22-jul-2026 | Primera limpieza automatizada (script v1) y auditoría inicial de calidad de datos. |
| 22-jul-2026 | Rediseño en 2 pasos: catálogo de entidades auditable, manejo explícito de `NA` vs. respuesta libre, exportación en 3 formatos. |
| 23-jul-2026 | Empaquetado final para disposición pública: renombrado de archivos (`datos_NN.nombre-descriptivo.ext`), inclusión del instrumento, README consolidado y trazabilidad del entorno de ejecución (`datos_08`). |
| 23-jul-2026 | Instrucciones y scripts de instalación a prueba de fallas del entorno de R para Ubuntu 24.04 LTS y Fedora Linux 44 (`datos_09.*`), probados de extremo a extremo en un contenedor limpio de Ubuntu. |
| 23-jul-2026 | Se agregó la instalación opcional de RStudio Desktop a ambos scripts (`.deb` estable de Posit en Ubuntu; repositorio Copr `iucar/rstudio` en Fedora), con reintentos y sin detener el script si falla. |
| 23-jul-2026 | Se agregó `datos_09.instalar-entorno-windows.ps1` (instalación a prueba de fallas de R y RStudio en Windows 11 vía winget, con respaldo de descarga directa desde CRAN/Posit) y se completó `datos_09.instrucciones-entorno-windows-linux.md` con instrucciones para los tres sistemas operativos (Windows, Ubuntu, Fedora). |
| 23-jul-2026 | Se agregó `datos_10.verificar-reproducibilidad.R`, que compara campo por campo los archivos clonados/publicados contra los que regenera `datos_03.limpieza-datos.R`; confirmado que los 5 archivos de datos limpios son idénticos, y que el script detecta correctamente diferencias cuando existen (probado deliberadamente). |
| 26-jul-2026 | Se corrigió el contexto institucional en todos los archivos: institución responsable (Colegio de Postgraduados, Campus Córdoba), responsables del proyecto y del repositorio con sus contactos, título del artículo y enlace a la revista (RIDE). |
| 26-jul-2026 | Se agregó `datos_11.plan-analisis-datos.md`: plan de análisis argumentado (preguntas de investigación, reglas de decisión estadística, etapas) acordado con el equipo antes de programar los scripts de análisis. |
| 26-jul-2026 | Se implementó el plan de análisis: `datos_12.analisis-descriptivo.R` (univariado, bivariado con pruebas de asociación, perfil síntesis, texto libre) y `datos_13.mapa-entidades.R` (mapas coropléticos, con geometrías guardadas localmente en `datos_13.geojson-entidades-mexico.geojson`). Se corrigió un bug real de idempotencia detectado al probar el script del mapa (duplicaba pies de figura si se corría más de una vez) antes de publicarlo. Salidas en `datos_14.tablas-resultados.xlsx` y `datos_15.figuras/`. |
| 26-jul-2026 | Se agregó `datos_16.validacion-figuras-manuscrito.md`: clasifica las 15 figuras generadas en esenciales (7) vs. redundantes con una tabla ya existente (8), aplicando el criterio de necesidad acordado. Se encontró y documentó un hallazgo real de formato: el título queda incrustado dentro de los `.png` (vía `labs(title=...)`), duplicando el texto que `pies-de-figura.md` ya genera para Word; se dejó la corrección exacta pendiente de aplicar a las 7 figuras que se conservan. |
| 26-jul-2026 | Se sustituyó la fuente geoespacial del mapa: de un repositorio sin licencia declarada a los shapefiles municipales CONABIO 2020-2023 publicados por [PhantomInsights](https://github.com/PhantomInsights/mexico-geojson) (licencia MIT). Se disolvió cada estado a partir de sus municipios y se simplificó la geometría; se regeneraron `fig14`/`fig15` y se confirmó que el mapa es visualmente equivalente. Referencia lista para citar en el artículo. |
| 26-jul-2026 | Se corrigieron duplicados detectados tras subir el repositorio a GitHub (15 figuras y `pies-de-figura.md` que habían quedado también en la raíz, además de dentro de `datos_15.figuras/`). En la limpieza se eliminaron por completo `datos_15.mapa-estado-estudios.csv` y `datos_15.mapa-estado-residencia.csv` (no quedaron ni en la raíz ni en la carpeta); se detectó al clonar el repositorio publicado y se corrigió regenerándolos en `datos_15.figuras/`, su ubicación correcta según `datos_13.mapa-entidades.R`. |
| 26-jul-2026 | **Corregido** el hallazgo de formato de `datos_16.validacion-figuras-manuscrito.md`: se quitó el título incrustado (`labs(title=...)`) de las tres funciones generadoras de figura en `datos_12.analisis-descriptivo.R` y `datos_13.mapa-entidades.R` (las 15 figuras, no solo las 7 esenciales, para dejar el código consistente). Se regeneró todo el pipeline (`datos_03`→`datos_12`→`datos_13`) y se verificó con análisis de imagen (Python/Pillow) que la franja superior de las figuras ya no contiene el texto del título — no solo inspección visual. |
| 26-jul-2026 | Se agregó `datos_17.referencias-bibliograficas.md`: la referencia APA 7 del geojson (PhantomInsights / CONABIO) se había dado solo en la conversación de trabajo y nunca había quedado persistida en un archivo del repositorio; ahora está guardada ahí, lista para copiarse a la sección de Referencias del artículo. |
| 26-jul-2026 | Se amplió `datos_17.referencias-bibliograficas.md` con las referencias APA 7 de las herramientas de software usadas (R 4.3.3, RStudio, y los 9 paquetes de R de `datos_03`/`datos_12`/`datos_13`), con versiones verificadas contra `datos_08.sesion-r-reproducibilidad.txt`. |
| 26-jul-2026 | Se agregó `set.seed(20260726)` en `datos_12.analisis-descriptivo.R`: las pruebas de Fisher exacto usan simulación Monte Carlo y, sin semilla fija, el p-valor variaba ligeramente entre corridas. Confirmado con dos corridas consecutivas que el resultado ahora es idéntico byte a byte. |
| 26-jul-2026 | Se agregó `datos_18.borrador-metodologia-resultados.md`: borrador detallado de Materiales y Métodos y Resultados, con la numeración final de figuras (1-7) y tablas (1-2) ya aplicada, para revisión del equipo antes de pasarlo al documento de Word. No incluye Discusión ni la integración del MCA, ambas pendientes de decisión. |
| 26-jul-2026 | Se convirtió `datos_15b.tablas-mapas.xlsx` (2 hojas planas) en dos archivos CSV independientes, consistente con el resto del repositorio (CSV para tablas de una sola relación, sin dependencias de lectura). Se actualizó `datos_13.mapa-entidades.R` en consecuencia y se eliminó la dependencia de `writexl` en ese script. |
| 26-jul-2026 | Se renombraron esos dos archivos a `datos_15.mapa-estado-estudios.csv` y `datos_15.mapa-estado-residencia.csv` (antes `datos_15b...`), y se actualizó `datos_13.mapa-entidades.R` para que los genere ya con estos nombres. |
| 26-jul-2026 | **Decisión tomada:** se integra el MCA como panorama exploratorio al inicio de Resultados. Se agregó `datos_19.mca-exploratorio.R` (adaptado del script del equipo, con dos correcciones reales: falta de `Sys.setlocale` y dependencia `factoextra` sin usar), generando `fig16`/`fig17` + 2 tablas de apoyo. Se corrigió además un problema real de robustez: `datos_12.analisis-descriptivo.R` sobrescribía todo `pies-de-figura.md` sin preservar lo ya escrito por `datos_13`/`datos_19`; los tres scripts ahora usan un esquema de bloques con marcadores que garantiza el orden final sin importar el orden de ejecución. Se actualizaron `datos_11`, `datos_16` (9 figuras esenciales, numeración final 1-9) y `datos_18` (MCA integrado en Métodos y Resultados) en consecuencia. |
| 27-jul-2026 | Auditoría completa del repositorio publicado en GitHub: se encontró que varios artefactos generados (figuras, `datos_14.xlsx`, `pies-de-figura.md`, 2 CSV del MCA, sección de software de `datos_17`) no reflejaban una corrida fresca del código ya corregido. Se regeneró todo el pipeline desde cero y se volvió a publicar; verificado con una segunda clonación del repositorio que la corrección quedó correctamente integra. |
| 27-jul-2026 | Se corrigieron dos hallazgos adicionales de validación editorial en las 9 figuras esenciales: (1) nota de tamaño de muestra (`n = N`) agregada dentro del área de cada figura, usando el espacio de subtítulo de ggplot2 en vez del de título (que se había eliminado a propósito); (2) consistencia tipográfica — `datos_12.analisis-descriptivo.R` y `datos_13.mapa-entidades.R` usaban la fuente sans-serif por defecto del sistema, mientras que `datos_19.mca-exploratorio.R` ya usaba Times/TeX Gyre Termes; ahora las 9 figuras comparten la misma tipografía. Verificado con análisis de imagen, no solo inspección visual. Detalle en `datos_16.validacion-figuras-manuscrito.md`, secciones 5 y 6. |
| 27-jul-2026 | Se mejoró la legibilidad de la Figura 2 (`fig17_mca_detalle_cumulo.png`): 6 de 15 categorías tenían coordenadas casi exactamente sobre la línea horizontal de referencia (Dimensión 2 = 0), superponiendo sus etiquetas con esa línea. Se agregó un empuje vertical inicial (`nudge_y`) en `datos_19.mca-exploratorio.R`, proporcional a la cercanía de cada categoría a la línea, antes del reacomodo automático de `ggrepel`. Verificado extrayendo las posiciones finales de las 15 etiquetas: ninguna queda ya a menos de 0.10 unidades de la línea (antes, 6 lo estaban). Detalle en `datos_16.validacion-figuras-manuscrito.md`, sección 7. |
| 27-jul-2026 | Ajuste puntual solicitado en la Figura 2: la etiqueta "26 a 30" se movió específicamente por debajo de la línea horizontal (antes quedaba arriba, muy cerca de "Masculino"), separando ambas categorías. Verificado con `ggplot_build()`. |
| 27-jul-2026 | Ajuste puntual solicitado en la Figura 1: la etiqueta "Alimentos" se movió 0.2 unidades a la derecha en la escala de Dimensión 1. Se reconfirmó, tras el cambio, que el título sigue sin estar incrustado en ninguna de las 9 figuras esenciales (0 hallazgos, sin regresión). |
| 27-jul-2026 | Se corrigieron 3 valores de *n* incorrectos en `datos_15.figuras/README.md` (`fig03`/`fig04`: decían 113, son 100; `fig08`: decía 100, es 98 — 2 personas interesadas no respondieron `situacion_laboral`). Se agregó una tabla explicando por qué *n* toma tres valores (113/100/98) según qué variables involucra cada figura. |
| 27-jul-2026 | Se verificó directamente contra `ride.org.mx/index.php/RIDE/about/submissions` (bloqueado a fetch directo, verificado por búsqueda) que el texto exige explícitamente solo `.png` y numeración arábiga para figuras — coincide con lo implementado. Se corrigió la atribución de `03_Ejemplo_Formato_Figura_RIDE.png` en `01_Normas_Editoriales_RIDE_Guia_Cumplimiento.md`: el usuario confirmó que es parte del contenido oficial de esa misma página de "Envíos" (visual, no textual), no un ejemplo de una fuente aparte — por lo que el formato de título/fuente/nota de muestra que muestra es un requisito vinculante, no una convención inferida. |
| 27-jul-2026 | El usuario compartió el texto completo y literal de "Envíos", pegado directamente en la conversación. Se reescribió `01_Normas_Editoriales_RIDE_Guia_Cumplimiento.md` desde cero contra esa fuente, revirtiendo dos errores que una verificación anterior (basada en fragmentos de búsqueda de una página distinta) había introducido: el nombre de sección es "Materiales y Métodos" (no "Método"), y no existe una sección "Contribuciones a Futuras Líneas de Investigación" en "Envíos". Se retiraron también todas las notas de bitácora/corrección del documento, dejándolo como una guía limpia. |
| 27-jul-2026 | Se verificaron las 9 figuras esenciales contra la guía reescrita (formato, numeración, título no incrustado, nota de *n* presente, fuente no incrustada, sin duplicar datos tabla/figura): las 9 cumplen los 7 puntos de la sección 13 sin ninguna discrepancia. |
| 27-jul-2026 | Se completó la **primera versión completa** de `datos_18` con las tres secciones Materiales y Métodos, Resultados y Discusión. La Discusión interpreta los hallazgos de RQ1-RQ8 sin repetir los datos ya reportados, incluye las limitaciones del estudio, y señala explícitamente (en corchetes, sin inventar ninguna) los puntos donde falta una referencia bibliográfica verificada de un estudio comparable — pendiente de que el equipo la complete con fuentes primarias reales antes del envío. |
