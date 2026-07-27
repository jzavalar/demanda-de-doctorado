# Primera versión completa: Materiales y Métodos / Resultados / Discusión

**Artículo:** *Demanda Potencial para un Doctorado en Ciencias en Paisaje y Rurismo Rural*
**Revista de destino:** RIDE — Revista Iberoamericana para la Investigación y el Desarrollo Educativo
**Institución:** Colegio de Postgraduados, Campus Córdoba
**Estado de este documento:** primera versión completa de estas tres secciones, para revisión del
equipo antes de integrarse al documento de Word del manuscrito. Formato de entrega final (Times
New Roman 12, interlineado 1.5, encabezados 16/14 pts centrados en negritas, figuras/tablas
numeradas con título arriba y fuente abajo) se aplica al pasar este texto al documento del
manuscrito — ver checklist en `01_Normas_Editoriales_RIDE_Guia_Cumplimiento.md`, sección 17.
**Basado en:** `datos_11.plan-analisis-datos.md` (diseño; revisado el 27-jul-2026, sin cambios
necesarios), `datos_12.analisis-descriptivo.R` / `datos_13.mapa-entidades.R` /
`datos_19.mca-exploratorio.R` (ejecución), `datos_14.tablas-resultados.xlsx` (números fuente de
RQ1-RQ8), `datos_15.figuras/` (figuras finales), `datos_16.validacion-figuras-manuscrito.md`
(clasificación esencial/tabla, numeración final, y validación editorial RIDE ya aprobada),
`datos_17.referencias-bibliograficas.md` (citas de software y del geojson).
**Cifras verificadas el:** 27 de julio de 2026, con semilla fija (`set.seed(20260726)`) para que
los p-valores simulados de Fisher sean reproducibles byte a byte — confirmado corriendo el
pipeline completo dos veces y comparando el resultado exacto.
**MCA:** integrado como panorama exploratorio al inicio de Resultados, antes de RQ1 — no como
prueba confirmatoria adicional, sino como introducción visual de conjunto, coherente con (no
redundante de) la prueba confirmatoria de RQ7.
**Pendiente antes de la versión para envío:** la sección de Discusión señala, en corchetes,
los puntos donde se necesita una referencia bibliográfica verificada de un estudio comparable
(demanda de posgrado, movilidad estudiantil, oferta educativa regional). No se inventó ninguna
cita para esta versión — el equipo debe completar esas referencias con fuentes primarias reales
antes del envío, siguiendo el mismo criterio de integridad de citas ya aplicado en el resto del
proyecto (ver `datos_17.referencias-bibliograficas.md`).

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

Como panorama exploratorio previo a las preguntas de investigación, se realizó además un
**análisis de correspondencias múltiples (MCA)** sobre las seis variables de demanda (género,
edad, área de maestría, situación laboral, motivación y plazo de inicio) del subconjunto de
personas interesadas. Se presenta explícitamente como una técnica **exploratoria, no
confirmatoria**: ofrece una vista de conjunto de cómo se agrupan las categorías en un espacio de
baja dimensión, pero no sustituye a las pruebas de independencia pre-especificadas de RQ6–RQ7,
que sí prueban asociaciones puntuales con un p-valor y un tamaño de efecto declarados. El MCA se
reporta junto con el porcentaje de inercia (variabilidad) que capturan sus dos primeras
dimensiones, para que quede explícito cuánta información del conjunto de datos resume — y
cuánta no.

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
datos; `ggplot2`, `scales` y `tidyr` para el análisis descriptivo y las figuras; `sf` para el
procesamiento geoespacial y los mapas; y `FactoMineR` y `ggrepel` para el análisis de
correspondencias múltiples y el etiquetado de sus figuras. Las referencias completas de cada
paquete, con su número de versión exacto, están en `datos_17.referencias-bibliograficas.md`.

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

## Panorama exploratorio multivariado

**Figura 1.** Panorama exploratorio de las variables de demanda (análisis de correspondencias múltiples): vista general.
**Figura 2.** Panorama exploratorio de las variables de demanda (análisis de correspondencias múltiples): detalle del cúmulo central.

Como introducción visual de conjunto antes de las preguntas de investigación específicas, se
presenta un análisis exploratorio de correspondencias múltiples sobre las seis variables de
demanda (género, edad, área de maestría, situación laboral, motivación y plazo de inicio),
calculado sobre **n = 98** personas interesadas (2 excluidas por dato faltante real en
situación laboral). Las dos primeras dimensiones explican **9.5 % y 7.9 % de la inercia**,
respectivamente (**17.4 % acumulado**) — es decir, el mapa resume solo una fracción modesta de
la variabilidad total entre categorías, y se presenta explícitamente como panorama
**exploratorio, no confirmatorio**.

Con esa salvedad, el patrón visible es coherente con el hallazgo confirmatorio de RQ7 (más
adelante): las categorías de área de maestría y línea de interés ocupan regiones cercanas del
mapa, mientras que motivaciones como "Aplicación en campo" aparecen asociadas con edades
intermedias-altas (51 a 60 años) y con plazos de inicio más largos. La Figura 2 amplía el
cúmulo central, donde se concentra la mayoría de las categorías con menor contribución
individual a las dos dimensiones, evitando la sobreposición de etiquetas de la vista general.
Este panorama no reemplaza ni añade evidencia estadística por sí mismo; su función es orientar
la lectura de los hallazgos confirmatorios que siguen.

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
detalle completo por entidad se presenta en las Figuras 8 y 9 (mapas) más adelante, en el
contexto de RQ8; no se repite aquí como tabla para no duplicar la misma información en dos
formatos.

## Interés general en el doctorado (RQ1)

**Figura 3.** Interés en cursar el doctorado

De las 113 respuestas, **100 (88.5 %; IC 95 % de Wilson: 81.3 %–93.2 %)** declararon interés en
cursar el doctorado, frente a 13 (11.5 %) que no lo manifestaron. Esta proporción, con su
intervalo de confianza, es consistente con una demanda potencial considerable dentro de la
población que respondió el cuestionario.

## Línea de doctorado de mayor interés (RQ2)

**Figura 4.** Línea de doctorado de interés

Entre las 100 personas interesadas, la línea **"Manejo y Aprovechamiento del Paisaje Rural"**
concentra más de la mitad del interés declarado (55 %; IC 95 % de Wilson: 45.2 %–64.4 %),
seguida, en empate técnico, por "Desarrollo del Paisaje Rural" y "Paisaje y Turismo Rural" (17 %
cada una). El resto del interés se distribuye en categorías minoritarias fuera de las tres
líneas originalmente propuestas por el instrumento (Desarrollo rural 6 %; Desarrollo Regional,
Energías, Sociología y Urbanismo y Relaciones de Poder, 1-2 % cada una), sugiriendo un interés
disperso pero minoritario en temáticas adyacentes no contempladas explícitamente en el diseño
original del programa.

## Motivación principal (RQ4)

**Figura 5.** Motivación principal para cursar el doctorado

La motivación declarada con mayor frecuencia fue la **investigación** (53 %), seguida de la
**docencia** (30 %) y de la **aplicación en campo** (16 %); solo un 1 % (una persona) declaró
una motivación fuera de estas tres categorías. Las tres respuestas de texto libre que no
encajaron en ninguna categoría predefinida (categoría "Otro" del proceso de limpieza) se
preservaron íntegras y muestran matices relevantes para la Discusión: interés en el sector
privado más que en el ámbito académico, cercanía a la jubilación sin proyección laboral futura,
y ausencia de una motivación adicional declarada (ver `Texto_libre_otro` en
`datos_14.tablas-resultados.xlsx`).

## Plazo estimado para iniciar el doctorado (RQ5)

**Figura 6.** Plazo estimado para iniciar el doctorado

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

**Figura 7.** Área de la maestría según línea de doctorado de interés

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

**Figura 8.** Distribución por entidad donde cursaron la maestría, personas interesadas en el doctorado
**Figura 9.** Distribución por entidad de residencia actual, personas interesadas en el doctorado

Sonora concentra la mayor proporción tanto de estudios previos (19 %) como de residencia actual
(19 %) entre las personas interesadas, seguida de Nuevo León, Estado de México y Tabasco (Figuras
8 y 9). La tabla de contingencia completa entre entidad de estudios y entidad de residencia
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

# Discusión

Esta sección interpreta los hallazgos ya presentados en Resultados, responde a las preguntas de
investigación planteadas en el plan de análisis, compara los resultados principales con
literatura comparable cuando fue posible verificarla, y analiza las limitaciones del estudio.
No se repiten aquí los datos ni los estadísticos ya reportados; se hace referencia a ellos de
forma conceptual, remitiendo a la figura o tabla correspondiente.

## Sobre la magnitud y la coherencia del interés declarado (RQ1, RQ7)

El hallazgo más relevante para justificar la apertura del programa no es un solo dato aislado,
sino la combinación de dos resultados independientes entre sí: una proporción alta de interés
general (Figura 3), y una asociación estadísticamente significativa entre la línea de doctorado
elegida y el área de la maestría previa de quienes respondieron (Figura 7). Que ambos resultados
apunten en la misma dirección —interés amplio y, además, informado por la trayectoria
académica— reduce la probabilidad de que el interés declarado sea aspiracional o producto de
deseabilidad social hacia el cuestionario, un riesgo inherente a cualquier consulta de demanda
autoadministrada. El panorama exploratorio (Figuras 1 y 2) es consistente con esta lectura,
aunque —como se señaló en Resultados— resume solo una fracción modesta de la variabilidad total
y no debe leerse como evidencia adicional por sí mismo.

[Cita pendiente de verificar: estudios sobre coherencia entre formación previa e intención de
continuar estudios de posgrado, para contrastar si la magnitud de la asociación encontrada aquí
(V de Cramér = 0.417) es comparable a la reportada en otros contextos educativos.]

## Sobre el diseño curricular y el perfil de quienes están interesados (RQ2, RQ3, RQ4)

La concentración de más de la mitad del interés en una sola línea curricular (Figura 4) es un
insumo directo para decidir con qué oferta iniciar el programa, más que para diseñar desde el
principio una oferta con múltiples líneas de igual peso. El perfil de quienes están interesados
—mayoritariamente mujeres, en el rango de edad típico de quienes ya concluyeron una maestría
recientemente, y con una motivación dominante hacia la investigación por encima de la docencia o
la aplicación en campo (Tabla 1, Figura 5)— sugiere que el público más receptivo para una
primera convocatoria coincide con el perfil de egreso reciente de maestría, más que con
profesionales ya consolidados en otras trayectorias.

Las tres respuestas de texto libre que no encajaron en las categorías de motivación
predefinidas —interés en el sector privado antes que en el ámbito académico, cercanía a la
jubilación sin proyección laboral futura, y ausencia de una motivación adicional declarada—
matizan ese perfil dominante: aunque minoritarias, muestran que no todas las personas
interesadas buscan necesariamente insertarse en una trayectoria académica convencional, algo que
conviene tener presente al diseñar el perfil de egreso para no excluir por diseño a ese segmento
minoritario.

## Sobre la planeación de cohortes y la modalidad (RQ5, RQ6, RQ8)

Casi tres cuartas partes de las personas interesadas estarían en condición de iniciar dentro de
los primeros dos años (Figura 6), lo que da un margen razonable para planear una primera
convocatoria sin necesidad de que el programa esté listo de inmediato. Sin embargo, la
situación laboral **no mostró una asociación estadísticamente significativa** ni con el plazo de
inicio ni con la motivación declarada (Tabla 2) — es decir, no se encontró evidencia, en esta
muestra, de que las personas empleadas o con negocio propio pospongan sistemáticamente su
inicio, o de que declaren una motivación distinta a quienes solo estudian. Este es un hallazgo
que **no confirma** una expectativa razonable de que la carga laboral condicionara la
disponibilidad de tiempo, y se reporta así, sin forzar una interpretación causal que los datos
no respaldan; los tamaños de efecto pequeños encontrados (Tabla 2) tampoco permiten descartar
por completo una asociación real que un estudio con mayor n pudiera detectar.

La muy alta permanencia geográfica encontrada (82 % permanece en la misma entidad donde cursó la
maestría; Figuras 8 y 9) es, junto con la concentración temporal de RQ5, el hallazgo con
implicación más directa para decidir la modalidad del programa: una oferta presencial
concentrada regionalmente alcanzaría a la gran mayoría de quienes están interesados, mientras
que una modalidad híbrida sería necesaria específicamente para la minoría dispersa en otras
entidades o, en un caso, residente fuera del país.

[Cita pendiente de verificar: literatura sobre movilidad estudiantil de posgrado en México y su
relación con la modalidad (presencial/híbrida) de programas doctorales regionales, para
contextualizar si un 82 % de permanencia es alto, típico o bajo frente a otros programas
similares.]

## Limitaciones del estudio

- **Muestreo no probabilístico.** Como se declaró en Materiales y Métodos, los resultados
  caracterizan a quienes respondieron el cuestionario, no constituyen una estimación
  poblacional con el rigor de una muestra probabilística. Los intervalos de confianza de Wilson
  reportados deben leerse como una medida de precisión muestral, no como un margen de error
  poblacional generalizable a todas las personas potencialmente interesadas en la región.
- **Diseño transversal, un solo corte temporal.** El cuestionario se aplicó en un periodo de
  poco más de un mes (abril-mayo de 2024); no permite observar si el interés declarado se
  sostiene en el tiempo o si respondió a un contexto coyuntural de ese periodo.
- **Sesgo de autoselección propio de cuestionarios de demanda.** Quienes ya tenían algún interés
  previo en el tema son, plausiblemente, más propensos a haber respondido, lo que puede inflar
  la proporción de interés general (RQ1) respecto de la población completa a la que se buscó
  llegar.
- **Celdas dispersas en las pruebas de asociación de RQ6.** Hasta 76 % de las celdas esperadas
  por debajo de 5 en la tabla más dispersa; aunque se usó la prueba de Fisher exacta con
  simulación Monte Carlo específicamente para manejar esta situación (en vez de la
  chi-cuadrada clásica, menos apropiada aquí), el poder estadístico para detectar asociaciones
  pequeñas en subgrupos con pocos casos sigue siendo limitado.
- **El panorama exploratorio (MCA) resume solo 17.4 % de la inercia total.** Se presentó de
  forma deliberadamente separada de los hallazgos confirmatorios, precisamente para no atribuirle
  un peso probatorio que no tiene; cualquier lectura de las Figuras 1 y 2 debe mantener esa
  salvedad.
- **Alcance institucional y geográfico del levantamiento.** El cuestionario se difundió desde una
  institución y una red de contactos específicas; la composición geográfica de quienes
  respondieron (concentrada en unas pocas entidades, Figuras 8 y 9) refleja en parte el alcance
  de esa difusión, no necesariamente la distribución real del interés potencial en el país.

[Cita pendiente de verificar: guías metodológicas sobre limitaciones típicas de estudios de
demanda educativa con muestreo no probabilístico, para enmarcar estas limitaciones dentro de
prácticas ya documentadas en el campo, en vez de presentarlas solo como limitaciones ad hoc de
este estudio particular.]

