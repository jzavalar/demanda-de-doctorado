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
