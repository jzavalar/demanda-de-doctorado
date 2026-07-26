# Borrador: Materiales y Métodos / Resultados

**Artículo:** *Demanda Potencial para un Doctorado en Ciencias en Paisaje y Rurismo Rural*
**Revista de destino:** RIDE — Revista Iberoamericana para la Investigación y el Desarrollo Educativo
**Institución:** Colegio de Postgraduados, Campus Córdoba
**Estado de este documento:** borrador de trabajo para revisión del equipo, **no** es la versión
final maquetada en Word. Formato de entrega final (Times New Roman 12, interlineado 1.5,
encabezados 16/14 pts centrados en negritas, figuras/tablas numeradas con título arriba y
fuente abajo) se aplica al pasar este texto al documento del manuscrito — ver checklist en
`01_Normas_Editoriales_RIDE_Guia_Cumplimiento.md`, sección 17.
**Basado en:** `datos_11.plan-analisis-datos.md` (diseño), `datos_12.analisis-descriptivo.R` /
`datos_13.mapa-entidades.R` (ejecución), `datos_14.tablas-resultados.xlsx` (números fuente),
`datos_15.figuras/` (figuras finales), `datos_16.validacion-figuras-manuscrito.md`
(clasificación esencial/tabla ya aplicada), `datos_17.referencias-bibliograficas.md` (citas de
software y del geojson).
**Cifras verificadas el:** 26 de julio de 2026, con semilla fija (`set.seed(20260726)`) para que
los p-valores simulados de Fisher sean reproducibles byte a byte, no solo aproximados —
confirmado corriendo el script dos veces y comparando el resultado exacto.
**Pendiente:** la decisión sobre si el análisis de correspondencias múltiples (MCA) se integra
como técnica complementaria sigue abierta; este borrador **no** lo incluye. Si se integra, RQ7
tendría una segunda figura de apoyo (ver conversación de trabajo).

---

# Materiales y Métodos

## Diseño del estudio

Estudio observacional, descriptivo y transversal, de enfoque cuantitativo, sobre la demanda
potencial de un Doctorado en Ciencias orientado al paisaje y turismo rural y al desarrollo,
manejo y aprovechamiento del paisaje rural. Los datos se recolectaron mediante un cuestionario
autoadministrado en línea, aplicado del 4 de abril al 7 de mayo de 2024.

El muestreo fue **no probabilístico** (cuestionario difundido sin marco muestral definido). Esta
decisión de diseño tiene una consecuencia metodológica que se declara explícitamente y se
mantiene consistente en todo el análisis: los resultados descritos a continuación caracterizan
a **quienes respondieron el cuestionario**, no constituyen una estimación de un parámetro
poblacional con el rigor de una muestra probabilística. Cualquier intervalo de confianza
reportado (método de Wilson) debe interpretarse como una medida de precisión muestral dado el
tamaño de la muestra obtenida, no como un margen de error poblacional generalizable a todos los
posibles interesados en la región.

## Participantes

Se obtuvieron **113 respuestas completas**. De ellas, **100 personas (88.5 %)** declararon
interés en cursar el doctorado y **13 (11.5 %)** declararon no tener interés; estas últimas no
respondieron las preguntas subsecuentes sobre línea de interés, motivación y plazo de inicio,
por diseño del cuestionario (lógica de salto), por lo que los análisis de las secciones RQ2 a
RQ8 se basan en el subconjunto de **n = 100** personas interesadas, salvo que se indique lo
contrario.

## Instrumento

El instrumento fue un cuestionario de 10 preguntas (Google Forms), con una pregunta filtro
adicional de interés general no documentada como ítem independiente en la versión de difusión
del instrumento (ver nota de trazabilidad en `datos_00.instrumento-cuestionario.md`). Las
preguntas cubrieron: interés general y línea de doctorado de interés, género, edad por rangos
quinquenales, entidad federativa donde se cursó la maestría y entidad de residencia actual,
nombre de la maestría e institución de origen (texto libre), situación laboral, motivación
principal para cursar el doctorado, y plazo estimado para iniciarlo.

## Procedimiento de recolección y transparencia de datos

El cuestionario se difundió electrónicamente entre la población objetivo. Los datos brutos, el
instrumento completo, el catálogo de estandarización de entidades, el script de limpieza, los
datos limpios en tres formatos (`.csv`, `.xlsx`, `.rds`), el diccionario de datos y el reporte
de auditoría de la limpieza están depositados en un repositorio público con control de
versiones (ver Disponibilidad de datos, más abajo), en cumplimiento del punto 14 de las normas
editoriales de RIDE sobre transparencia de datos, métodos analíticos y materiales.

## Procesamiento y limpieza de datos

La limpieza y estandarización se realizó en R (versión 4.3.3), con un script automatizado y
documentado en dos pasos:

1. **Estandarización.** Normalización de texto (Unicode NFC, recorte y colapso de espacios) en
   todas las columnas; estandarización de los nombres de entidad federativa mediante un catálogo
   explícito y auditable (no por coincidencia difusa de patrones), documentando cada equivalencia
   con su justificación (p. ej., una entrada ambigua de residencia se resolvió por ser consistente
   con la entidad de estudios de la misma persona). El dato faltante se codificó como valor nulo
   (`NA`) únicamente cuando la persona genuinamente no respondió o la pregunta no le aplicaba por
   la lógica de salto del cuestionario; una respuesta libre que sí existía pero no encajaba en
   ninguna categoría predefinida se conservó íntegra como categoría "Otro" con el texto original
   preservado, para no perder información sustantiva en el proceso de limpieza.
2. **Automatización y validación.** Recodificación de variables categóricas con reglas
   estrictas y explícitas, diseñadas para no fusionar respuestas con significados distintos entre
   sí, y una validación de integridad automática que confirma que el número de registros no
   cambia entre el archivo crudo y el archivo limpio.

No se identificaron valores faltantes no documentados ni registros duplicados: las 113
respuestas se conservaron íntegras en todo el proceso, verificado automáticamente por el script
de limpieza y confirmado de forma independiente con un script de verificación de
reproducibilidad que compara, campo por campo, los archivos publicados contra los que el script
regenera desde el dato crudo.

## Plan y técnicas de análisis

El análisis se organizó alrededor de ocho preguntas de investigación (RQ1–RQ8), definidas y
argumentadas antes de programar cualquier script, para evitar decisiones estadísticas tomadas
sobre la marcha:

| # | Pregunta | Utilidad para el programa |
|---|---|---|
| RQ1 | ¿Cuál es la magnitud del interés declarado? | Justificar la apertura del programa |
| RQ2 | ¿Qué línea del doctorado concentra más interés? | Diseño curricular |
| RQ3 | ¿Perfil sociodemográfico y académico de quienes están interesados? | Público objetivo de difusión |
| RQ4 | ¿Motivaciones principales para cursarlo? | Enfoque del plan de estudios |
| RQ5 | ¿En qué plazo esperan iniciar? | Planeación de cohortes y fecha de apertura |
| RQ6 | ¿La situación laboral se asocia con el plazo de inicio o la motivación? | Modalidad (presencial/híbrida) y horarios |
| RQ7 | ¿La línea de interés es coherente con el área de la maestría previa? | Validar que el interés es informado, no aspiracional al azar |
| RQ8 | ¿Dispersión geográfica entre entidad de estudios y de residencia? | Viabilidad de una modalidad presencial vs. híbrida |

Dado que casi todas las variables son categóricas (nominales o de rango), el análisis fue
principalmente descriptivo y no paramétrico: frecuencias absolutas y relativas para el perfil
univariado (RQ1–RQ5), y tablas de contingencia con pruebas de independencia para las
asociaciones bivariadas pre-especificadas (RQ6–RQ8) — no se exploraron todos los cruces
posibles entre variables, únicamente los que responden a una pregunta de investigación
declarada de antemano, para no incurrir en comparaciones múltiples no declaradas.

**Reglas de decisión estadística**, fijadas de antemano para que el análisis sea reproducible y
defendible:

- Nivel de significancia α = 0.05, reportando siempre el p-valor exacto en vez de únicamente
  "significativo/no significativo".
- **Prueba de Fisher exacta** (con simulación Monte Carlo de 5,000 réplicas para las tablas de
  RQ6–RQ7, y 2,000 réplicas para la tabla más grande de RQ8) en lugar de la prueba de
  chi-cuadrada, aplicada automáticamente por tabla cuando más del 20 % de las celdas esperadas
  tuvieron una frecuencia menor a 5 (regla de Cochran), en vez de decidirlo caso por caso a
  criterio del equipo.
- **V de Cramér** como medida de tamaño de efecto en toda tabla de contingencia probada,
  independientemente de si el resultado fue estadísticamente significativo, ya que con un tamaño
  de muestra pequeño la significancia estadística y la relevancia práctica no son equivalentes.
- El **n efectivo** de cada prueba se declara explícitamente junto con el resultado, dado que
  algunas variables tienen valores faltantes reales y documentados (13 personas sin dato en
  línea de interés, por no aplicarles la pregunta; 2 personas sin dato en situación laboral, por
  no responderla) — sin imputación de ningún tipo.
- **Intervalo de confianza de Wilson** (no el normal-aproximado, menos adecuado para
  proporciones cercanas a los extremos o con n pequeño) para las proporciones clave: interés
  general, línea de doctorado más elegida, y proporción de permanencia geográfica.

Como complemento visual a RQ8, se generaron mapas coropléticos por entidad federativa. Las
geometrías estatales se construyeron disolviendo (unión geométrica) los límites municipales del
conjunto de shapefiles CONABIO 2020-2023, redistribuidos por PhantomInsights bajo licencia MIT
(referencia completa en `datos_17.referencias-bibliograficas.md`).

## Software

El análisis se realizó íntegramente en R (versión 4.3.3; R Core Team, 2024), usando los
paquetes `readxl`, `stringr`, `dplyr`, `writexl`, `openxlsx` y `stringi` para la limpieza de
datos; `ggplot2`, `scales` y `tidyr` para el análisis descriptivo y las figuras; y `sf` para el
procesamiento geoespacial y los mapas coropléticos. Las referencias completas de cada paquete,
con su número de versión exacto, están en `datos_17.referencias-bibliograficas.md`.

## Disponibilidad de datos y materiales

En congruencia con la política de acceso abierto de RIDE y el punto 14 de sus normas
editoriales, los datos brutos, los datos limpios, el catálogo de estandarización, los scripts
de limpieza y de análisis, el diccionario de datos, las figuras, las tablas de resultados y la
documentación de validación completa están disponibles públicamente en:
`https://github.com/jzavalar/demanda-de-doctorado` (licencia CC BY 4.0). El repositorio incluye
instrucciones de instalación del entorno para Windows, Ubuntu y Fedora, y un script que verifica
que los archivos publicados sean reproducibles byte a byte a partir del dato crudo.

---

# Resultados

Los resultados se presentan en el orden de las preguntas de investigación. Se reportan como
**descriptivos de las personas que respondieron**, no como una estimación poblacional
generalizable, dado el muestreo no probabilístico (ver Materiales y Métodos).

## Perfil sociodemográfico y profesional (RQ3)

**Tabla 1.** Perfil sociodemográfico y profesional de las personas interesadas en el doctorado (n = 100)

| Variable | Categoría más frecuente | n | % | Categorías totales |
|---|---|---|---|---|
| Género | Femenino | 59 | 59.0 | 2 (Femenino 59 %, Masculino 41 %) |
| Edad | 26 a 30 años | 34 | 34.0 | 8 rangos (26-30 y 31-35 concentran 57 %) |
| Área de la maestría previa | Social | 49 | 49.0 | 5 (Social 49 %, Agronómica 28 %, Otras 18 %, Economía 3 %, Alimentos 2 %) |
| Situación laboral | Solo estudia | 34 | 34.7 | 5 (sobre n = 98 efectivo; 2 sin dato) |

*Fuente: Elaboración propia, a partir de `Perfil_sintesis` y las hojas `Univ_*` de*
*`datos_14.tablas-resultados.xlsx`.*

La mayoría de las personas interesadas son mujeres (59 %) y se concentran en el rango de 26 a
30 años (34 %; junto con 31-35 años, ambos rangos suman 57 % de la muestra). Casi la mitad
(49 %) provienen de una maestría del área social, seguida por el área agronómica (28 %); solo
un 5 % proviene de un área directamente vinculada a alimentos. En cuanto a situación laboral,
34 % se dedica únicamente a estudiar, 21.4 % son docentes, 19.4 % son empleados, otro 19.4 %
combina trabajo y estudio, y 5.1 % tiene un negocio propio — es decir, casi dos terceras partes
de las personas interesadas (65.3 %) ya tienen una ocupación laboral activa además de, o en vez
de, dedicarse a estudiar.

En cuanto a la procedencia geográfica, Sonora concentra el mayor número tanto de estudios previos
(19 %) como de residencia actual (19 %), seguida de Estado de México, Nuevo León y Tabasco. El
detalle completo por entidad se presenta en las Figuras 6 y 7 (mapas) más adelante, en el
contexto de RQ8; no se repite aquí como tabla para no duplicar la misma información en dos
formatos.

## Interés general en el doctorado (RQ1)

**Figura 1.** Interés en cursar el doctorado

De las 113 respuestas, **100 (88.5 %; IC 95 % de Wilson: 81.3 %–93.2 %)** declararon interés en
cursar el doctorado, frente a 13 (11.5 %) que no lo manifestaron. Esta proporción, con su
intervalo de confianza, es consistente con una demanda potencial considerable dentro de la
población que respondió el cuestionario.

## Línea de doctorado de mayor interés (RQ2)

**Figura 2.** Línea de doctorado de interés

Entre las 100 personas interesadas, la línea **"Manejo y Aprovechamiento del Paisaje Rural"**
concentra más de la mitad del interés declarado (55 %; IC 95 % de Wilson: 45.2 %–64.4 %),
seguida, en empate técnico, por "Desarrollo del Paisaje Rural" y "Paisaje y Turismo Rural" (17 %
cada una). El resto del interés se distribuye en categorías minoritarias fuera de las tres
líneas originalmente propuestas por el instrumento (Desarrollo rural 6 %; Desarrollo Regional,
Energías, Sociología y Urbanismo y Relaciones de Poder, 1-2 % cada una), sugiriendo un interés
disperso pero minoritario en temáticas adyacentes no contempladas explícitamente en el diseño
original del programa.

## Motivación principal (RQ4)

**Figura 3.** Motivación principal para cursar el doctorado

La motivación declarada con mayor frecuencia fue la **investigación** (53 %), seguida de la
**docencia** (30 %) y de la **aplicación en campo** (16 %); solo un 1 % (una persona) declaró
una motivación fuera de estas tres categorías. Las tres respuestas de texto libre que no
encajaron en ninguna categoría predefinida (categoría "Otro" del proceso de limpieza) se
preservaron íntegras y muestran matices relevantes para la Discusión: interés en el sector
privado más que en el ámbito académico, cercanía a la jubilación sin proyección laboral futura,
y ausencia de una motivación adicional declarada (ver `Texto_libre_otro` en
`datos_14.tablas-resultados.xlsx`).

## Plazo estimado para iniciar el doctorado (RQ5)

**Figura 4.** Plazo estimado para iniciar el doctorado

Más de la mitad de las personas interesadas (55 %) manifestó disposición a iniciar el doctorado
**en el plazo de un año**; un 18 % declaró un plazo **indefinido** (es decir, sí tiene interés
pero no ha definido cuándo podría iniciar, una categoría distinta de la no-respuesta), 17 %
estimó dos años, 9 % tres años y únicamente 1 % cinco años. En conjunto, quienes estarían en
condiciones de iniciar dentro de los primeros dos años representan 72 % de las personas
interesadas, un dato relevante para la planeación de la primera cohorte del programa.

## Situación laboral y su asociación con el plazo de inicio y la motivación (RQ6)

**Tabla 2.** Cruces bivariados de situación laboral con plazo de inicio y motivación (n efectivo = 98)

| Cruce | Prueba | n efectivo | % celdas esperadas < 5 | Estadístico | p | V de Cramér |
|---|---|---|---|---|---|---|
| Situación laboral × Plazo de inicio | Fisher exacto (simulado, Monte Carlo) | 98 | 76 % | — | 0.297 | 0.211 |
| Situación laboral × Motivación | Fisher exacto (simulado, Monte Carlo) | 98 | 55 % | — | 0.079 | 0.240 |

*Fuente: Elaboración propia, a partir de `Bivariado_resumen` en `datos_14.tablas-resultados.xlsx`.*

Ninguno de los dos cruces alcanzó significancia estadística al nivel convencional de α = 0.05.
El tamaño de efecto (V de Cramér) fue pequeño para situación laboral × plazo de inicio (0.211) y
pequeño-moderado para situación laboral × motivación (0.240), este último más cercano al umbral
convencional de un efecto moderado (0.30) que el primero. Con un n efectivo de 98 y hasta un
76 % de celdas esperadas por debajo de 5 en la tabla más dispersa, estos resultados deben
interpretarse con cautela: la ausencia de significancia estadística en esta muestra no permite
descartar una asociación real de magnitud pequeña que un estudio con mayor n podría detectar.
Descriptivamente, se observa que el personal docente concentra más motivación por investigación
(15 de 21) y que quienes solo estudian se reparten de forma más pareja entre investigación
(16 de 34) y docencia (13 de 34) como motivación principal.

## Coherencia entre la línea de interés y la formación previa (RQ7)

**Figura 5.** Área de la maestría según línea de doctorado de interés

A diferencia de los cruces de RQ6, esta asociación **sí resultó estadísticamente
significativa** (Fisher exacto simulado, p = 0.034; V de Cramér = 0.417, efecto
moderado-alto, n = 100). Esto indica que la línea de doctorado elegida no es aspiracional al
azar, sino coherente con la formación de maestría previa: por ejemplo, la totalidad de quienes
provienen de una maestría en Alimentos (2 de 2) eligieron "Manejo y Aprovechamiento del Paisaje
Rural", y quienes provienen del área Social se inclinan también mayoritariamente hacia esa misma
línea (28 de 49) por encima de las otras siete opciones. Este hallazgo respalda que el interés
declarado en RQ2 está informado por la trayectoria académica de quienes respondieron, no
solamente por el atractivo nominal de cada línea.

## Dispersión geográfica entre entidad de estudios y de residencia (RQ8)

**Figura 6.** Distribución por entidad donde cursaron la maestría, personas interesadas en el doctorado
**Figura 7.** Distribución por entidad de residencia actual, personas interesadas en el doctorado

Sonora concentra la mayor proporción tanto de estudios previos (19 %) como de residencia actual
(19 %) entre las personas interesadas, seguida de Nuevo León, Estado de México y Tabasco (Figuras
6 y 7). La tabla de contingencia completa entre entidad de estudios y entidad de residencia
(17 × 24 categorías) mostró una asociación muy fuerte (Fisher exacto simulado, p = 0.0005; V de
Cramér = 0.890, n = 100) — resultado esperable dado que **82 % de las personas interesadas
residen en la misma entidad donde cursaron la maestría** (IC 95 % de Wilson: 73.3 %–88.3 %),
una alta permanencia geográfica que sostiene la diagonal principal de esa tabla. Dada la
dispersión y el tamaño de la tabla completa (con celdas de conteo muy bajo fuera de la
diagonal), este resultado se interpreta con cautela y se reporta principalmente a través de la
proporción de permanencia y de los dos mapas, más informativos visualmente que la tabla de
contingencia completa. Este patrón de alta permanencia geográfica es un elemento relevante para
evaluar la viabilidad de una modalidad presencial concentrada regionalmente, frente a una
modalidad híbrida que alcance a la minoría de personas interesadas dispersas en otras entidades
o, en un caso, fuera del país.

---

## Nota para el equipo (no forma parte del texto del manuscrito)

- Todas las cifras de esta sección son reproducibles ejecutando, en orden,
  `datos_03.limpieza-datos.R` → `datos_12.analisis-descriptivo.R` → `datos_13.mapa-entidades.R`
  sobre el repositorio publicado; el p-valor de Fisher ahora es idéntico entre corridas gracias
  a la semilla fija agregada hoy (antes variaba ligeramente por la simulación Monte Carlo sin
  semilla — se corrigió antes de fijar estos números en el texto).
- Los números de figura y tabla ya corresponden a la numeración **final** propuesta en
  `datos_16.validacion-figuras-manuscrito.md` (7 figuras esenciales, renumeradas 1–7; 2 tablas
  nuevas más la de perfil sociodemográfico). Falta actualizar `pies-de-figura.md` para que use
  esta misma numeración final antes de pegar las figuras en el documento de Word.
- Sección de Discusión: **no** incluida en este borrador (se pidió expresamente Métodos y
  Resultados). Los apuntes interpretativos dentro de Resultados son mínimos, siguiendo el
  criterio conservador ya documentado en la guía de cumplimiento editorial de RIDE (reportar
  resultados con una discusión robusta en su propio apartado, no fusionados).
- Pendiente de decisión: integración del MCA (ver conversación de trabajo). Si se integra,
  afectaría principalmente la sección de RQ7 (una figura adicional) y el plan de análisis.
