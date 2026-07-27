# Plan de análisis de datos (finalizado)

**Estudio:** Demanda Potencial para un Doctorado en Ciencias en Paisaje y Rurismo Rural
**Precede a:** el/los scripts de análisis (`datos_12.*`)
**Decisiones confirmadas con el equipo:** 26 de julio de 2026

Este documento fija el diseño analítico antes de programar nada, para que las decisiones
metodológicas queden argumentadas y trazables — no elegidas sobre la marcha mientras se
escribe código.

---

## 1. Naturaleza del estudio y su implicación metodológica

Estudio de demanda potencial por **muestreo no probabilístico** (cuestionario difundido, sin
marco muestral): 113 respuestas, 100 con interés declarado. Consecuencias que se declaran
explícitamente en cada salida del análisis (tablas, figuras y en el propio artículo):

- Los resultados describen a **quienes respondieron**, no estiman un parámetro poblacional con
  el rigor de una muestra probabilística. Cualquier intervalo de confianza reportado es una
  medida de precisión muestral, no un margen de error poblacional generalizable.
- Casi todas las variables son **categóricas** (nominales o de rango) → estadística
  principalmente no paramétrica: frecuencias, proporciones, tablas de contingencia.
- El **n es pequeño para desagregar mucho**: los subgrupos de interés caen fácilmente por
  debajo de 20-30 casos, lo que exige reportar tamaño de efecto además de significancia, y
  elegir la prueba de independencia correcta según el tamaño esperado de celda.

## 2. Preguntas de investigación (RQ1–RQ8)

| # | Pregunta | Para qué sirve |
|---|---|---|
| RQ1 | ¿Cuál es la magnitud del interés declarado? | Justificar la apertura del programa |
| RQ2 | ¿Qué línea del doctorado concentra más interés? | Diseño curricular |
| RQ3 | ¿Perfil sociodemográfico y académico de quienes están interesados? | Público objetivo de difusión |
| RQ4 | ¿Motivaciones principales (investigación/docencia/aplicación en campo/otro)? | Enfoque del plan de estudios |
| RQ5 | ¿En qué plazo esperan iniciar? | Planeación de cohortes y fecha de apertura |
| RQ6 | ¿La situación laboral se asocia con el plazo de inicio o la motivación? | Modalidad (presencial/híbrida, horarios) |
| RQ7 | ¿La línea de interés es coherente con el área de la maestría previa? | Validar que el interés es informado |
| RQ8 | ¿Dispersión geográfica entre estado de estudios y de residencia? | Viabilidad de modalidad presencial vs. híbrida |

Los cruces bivariados están **pre-especificados** a partir de estas preguntas (no se exploran
todos los cruces posibles) para no incurrir en comparaciones múltiples no declaradas.

## 3. Decisiones confirmadas

1. **Sí se incluyen pruebas de asociación** (chi-cuadrado / Fisher exacto) en los cruces
   bivariados de RQ6–RQ8, con las salvedades de la sección 1 declaradas junto a cada resultado
   — nunca se presenta un p-valor sin esa salvedad ni sin su tamaño de efecto.
2. **Sí se incluye un mapa coroplético** por entidad (estado de estudios y estado de
   residencia), como complemento visual a RQ8.
3. **Formato de entrega:** script(s) de R + tablas y figuras exportadas como archivos,
   siguiendo la misma convención `datos_NN.nombre-descriptivo.ext` y el mismo estándar de
   manejo de errores por bloques que `datos_03.limpieza-datos.R`.

## 4. Reglas de decisión estadística (para que sea reproducible y defendible ante árbitros)

- α = 0.05, pero siempre se reporta el p-valor exacto, no solo "significativo/no significativo".
- **Fisher exacto** en vez de chi-cuadrado cuando más del 20% de las celdas esperadas de una
  tabla tengan frecuencia <5 (regla de Cochran); se evalúa automáticamente por tabla, no a
  criterio manual.
- **V de Cramér** como tamaño de efecto en toda tabla de contingencia probada, independientemente
  de si el resultado es significativo — con n pequeño, significancia y relevancia práctica no
  son lo mismo.
- N efectivo declarado en cada tabla (por los `NA` reales ya documentados: 13 en
  `doctorado_de_interes`, 2 en `situacion_laboral`); sin imputación.
- Intervalo de Wilson (no el normal-aproximado) para las proporciones clave con n pequeño
  (interés Sí/No, línea de doctorado).

## 5. Etapas de implementación

1. **Descriptivo univariado** — frecuencias + gráfico de barras por variable; IC de Wilson en
   las proporciones clave.
2. **Bivariado (RQ6–RQ8)** — tabla de contingencia + prueba de independencia + V de Cramér +
   N efectivo, para cada cruce pre-especificado.
3. **Perfil síntesis** ("ficha del candidato típico") — tabla-resumen no inferencial de quienes
   están interesados, para alimentar la Discusión del artículo.
4. **Texto libre preservado** (`..._otro_texto`) — revisión y agrupación temática breve, para
   no desperdiciar la información conservada deliberadamente en la limpieza.
5. **Mapa coroplético** por entidad (estado de estudios y de residencia).
   - Fuente geográfica: se descargará **una sola vez** un GeoJSON de las 32 entidades de
     México y se guardará como archivo del repositorio (no como dependencia de red en tiempo
     de análisis), para que el mapa se pueda regenerar sin conexión a internet en el futuro —
     mismo criterio de reproducibilidad ya aplicado al resto del proyecto.
   - Librería: `sf` (ya disponible vía `r-cran-sf`/`R-sf` en los scripts de entorno existentes).

## 6. Vínculo con las normas editoriales de RIDE

- **Resultados**: cada bloque de resultados se redacta listo para llevar su interpretación
  junto con la tabla/figura (la norma de RIDE pide discusión embebida en Resultados, no solo al
  final).
- **Discusión**: se nutre directamente de la etapa 3 (perfil síntesis) y de las limitaciones de
  la sección 1 (muestreo no probabilístico, tamaño de muestra, autoselección por difusión).
- **Materiales y Métodos**: software y versión ya documentados vía `datos_08`; este plan se cita
  como el diseño analítico seguido.

## 7. Siguiente paso

Implementar `datos_12.analisis-descriptivo.R` (etapas 1–4) y `datos_13.mapa-entidades.R` (etapa
5), con exportación de tablas a `.xlsx`/`.csv` y figuras a `.png` (formato requerido por RIDE:
título arriba, fuente abajo, ver `01_Normas_Editoriales_RIDE_Guia_Cumplimiento.md`).

> **Estado: implementado el 26 de julio de 2026.** Ver `datos_12.analisis-descriptivo.R`,
> `datos_13.mapa-entidades.R`, resultados en `datos_14.tablas-resultados.xlsx` y figuras en
> `datos_15.figuras/`. Resumen de hallazgos en `README.md`, sección 9.

## 8. Adición: panorama exploratorio multivariado (MCA)

**Decisión (26-jul-2026):** se agrega un análisis de correspondencias múltiples (MCA) sobre las
seis variables de demanda (género, edad, área de maestría, situación laboral, motivación,
tiempo de inicio), como **panorama exploratorio al inicio de Resultados**, antes de RQ1 — no
como prueba confirmatoria adicional ni como reemplazo de las pruebas pareadas de RQ6-RQ7.

**Argumento:** para un lector no especializado en estadística (el perfil típico de un lector de
RIDE interesado en gestión educativa, no necesariamente en inferencia estadística), un mapa
donde se observa qué categorías tienden a agruparse es más intuitivo de leer de un vistazo que
una tabla de p-valores. Se decidió colocarlo como introducción visual, no mezclado con RQ6-RQ7,
para que no se confunda un hallazgo exploratorio con uno confirmatorio.

**Salvedad obligatoria, declarada explícitamente en el texto (no en nota al pie):** las dos
dimensiones del MCA explican en conjunto solo 17.4 % de la inercia (variabilidad) total entre
categorías. Un lector sin entrenamiento estadístico tiende a leer "cercanía en el mapa" como
"relación fuerte", cuando en realidad el mapa captura una fracción modesta de la variabilidad
completa. Por eso el MCA se presenta como *exploratorio*, enmarcado como coherente con (no como
evidencia adicional de) el hallazgo confirmatorio de RQ7, y no se le atribuye ningún p-valor ni
conclusión que no tenga respaldo de una prueba de hipótesis pre-especificada.

**Relación con un análisis previo de una iteración anterior del proyecto:** existió, en una
etapa metodológica anterior de este proyecto (antes de adoptarse el diseño RQ1-RQ8 de este
plan), una matriz exploratoria más amplia de V de Cramér entre los 15 pares posibles de estas
mismas 6 variables, calculada específicamente como respaldo cuantitativo de un MCA. Esa matriz
amplia **no se retoma** aquí, de forma consistente con la decisión ya tomada en la sección 4 de
no explorar todos los cruces posibles entre variables sin una pregunta de investigación
declarada de antemano. Los dos pares de esa matriz antigua que sí responden a una pregunta de
investigación (situación laboral × tiempo de inicio; situación laboral × motivación) ya están
cubiertos, recalculados con el método más riguroso de este plan (Fisher exacto + Monte Carlo),
como RQ6.

**Ejecución:** `datos_19.mca-exploratorio.R`, adaptado del script compartido por el equipo
(v14, dos paneles independientes con leyenda propia). Se corrigieron dos problemas reales
detectados al recalcularlo contra los datos actuales: (1) faltaba fijar el *locale* a UTF-8,
lo que producía advertencias de codificación y un error de parseo; (2) se cargaba el paquete
`factoextra` sin usar ninguna de sus funciones. Resultados: n = 98 (2 excluidos por dato
faltante real en situación laboral), Dimensión 1 = 9.5 %, Dimensión 2 = 7.9 %, inercia
acumulada = 17.4 %. Figuras: `datos_15.figuras/fig16_mca_vista_general.png` y
`fig17_mca_detalle_cumulo.png`; clasificación editorial y numeración final (Figuras 1-2 del
manuscrito) en `datos_16.validacion-figuras-manuscrito.md`, sección 2.1 y 7.
