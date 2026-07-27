# Referencias bibliográficas de fuentes externas

Este archivo reúne, en formato APA 7ª ed. (el exigido por RIDE), las fuentes externas usadas
para construir los datos y las figuras de este repositorio — para que no se pierdan en el
historial de conversaciones de trabajo y estén listas para copiarse directamente a la sección
de Referencias del artículo.

---

## Fuentes de datos externas

### Geometrías del mapa (`datos_13.geojson-entidades-mexico.geojson`)

Usado en `datos_13.mapa-entidades.R` para generar `fig14_mapa_estado_estudios.png` y
`fig15_mapa_estado_residencia.png`.

> PhantomInsights. (2025). *mexico-geojson: GeoJSON files for all Mexico states from the
> CONABIO 2020-2023 shapefiles* [Conjunto de datos geoespaciales]. GitHub.
> https://github.com/PhantomInsights/mexico-geojson

**Nota de procesamiento** (para Materiales y Métodos, no para la lista de referencias): las
geometrías originales están a nivel municipio; se disolvieron (unión geométrica) a nivel
estatal y se simplificó la geometría antes de guardarlas localmente en
`datos_13.geojson-entidades-mexico.geojson`. Detalle completo del procesamiento en el
encabezado de `datos_13.mapa-entidades.R`.

**Procedencia original de los datos:** el repositorio de PhantomInsights, a su vez, deriva las
geometrías de los shapefiles municipales publicados por la **Comisión Nacional para el
Conocimiento y Uso de la Biodiversidad (CONABIO)**, actualización 2020-2023. Si el equipo
editorial de RIDE pidiera citar la fuente primaria en vez de (o además de) el repositorio que
la redistribuye, usar:

> Comisión Nacional para el Conocimiento y Uso de la Biodiversidad. (2023). *Shapefiles de
> división municipal de México, actualización 2020-2023* [Conjunto de datos geoespaciales].
> CONABIO.

*(Esta segunda referencia se da como respaldo; no se verificó una URL o DOI oficial y estable
de CONABIO para el shapefile exacto redistribuido por PhantomInsights — antes de publicarla,
confirmar en conabio.gob.mx o pedir la referencia exacta al equipo de GIS si el artículo la
requiere con ese nivel de precisión.)*

**Licencia:** MIT (repositorio de PhantomInsights); permite uso, redistribución y modificación
sin restricción, con atribución.

---

## Herramientas de software

Usadas en `datos_03.limpieza-datos.R`, `datos_12.analisis-descriptivo.R` y
`datos_13.mapa-entidades.R`. Versiones exactas verificadas contra
`datos_08.sesion-r-reproducibilidad.txt` (no supuestas). RIDE no exige explícitamente citar el
software en la sección de Materiales y Métodos, pero es buena práctica de reproducibilidad y
lo piden cada vez más revistas de ciencias sociales y educativas; se incluyen aquí listas por
si el equipo decide agregarlas.

**Lenguaje y entorno**

> R Core Team. (2024). *R: A language and environment for statistical computing* (Versión
> 4.3.3) [Software]. R Foundation for Statistical Computing. https://www.R-project.org/

> Posit team. (2024). *RStudio: Integrated development environment for R* [Software]. Posit
> Software, PBC. http://www.posit.co/ *(solo si el equipo trabajó con el IDE; no es
> indispensable citarlo si únicamente se usó `Rscript` en línea de comandos — ver
> `datos_09.instrucciones-entorno-windows-linux.md`)*

**Paquetes usados en `datos_03.limpieza-datos.R` (limpieza y estandarización)**

> Wickham, H., & Bryan, J. (2023). *readxl: Read Excel files* (Versión 1.4.3) [Paquete de R].
> https://CRAN.R-project.org/package=readxl

> Wickham, H. (2023). *stringr: Simple, consistent wrappers for common string operations*
> (Versión 1.5.1) [Paquete de R]. https://CRAN.R-project.org/package=stringr

> Wickham, H., François, R., Henry, L., Müller, K., & Vaughan, D. (2023). *dplyr: A grammar of
> data manipulation* (Versión 1.1.4) [Paquete de R]. https://CRAN.R-project.org/package=dplyr

> Ooms, J. (2024). *writexl: Export data frames to Excel 'xlsx' format* (Versión 1.5.0)
> [Paquete de R]. https://CRAN.R-project.org/package=writexl

> Schauberger, P., & Walker, A. (2023). *openxlsx: Read, write and edit xlsx files* (Versión
> 4.2.5.2) [Paquete de R]. https://CRAN.R-project.org/package=openxlsx

> Gagolewski, M. (2022). stringi: Fast and portable character string processing in R.
> *Journal of Statistical Software*, *103*(2), 1–59. https://doi.org/10.18637/jss.v103.i02

**Paquetes adicionales usados en `datos_12.analisis-descriptivo.R` (análisis descriptivo y
bivariado)**

> Wickham, H. (2016). *ggplot2: Elegant graphics for data analysis*. Springer-Verlag New York.
> https://ggplot2.tidyverse.org

> Wickham, H., Pedersen, T., & Seidel, D. (2023). *scales: Scale functions for visualization*
> (Versión 1.3.0) [Paquete de R]. https://CRAN.R-project.org/package=scales

> Wickham, H., Vaughan, D., & Girlich, M. (2024). *tidyr: Tidy messy data* (Versión 1.3.1)
> [Paquete de R]. https://CRAN.R-project.org/package=tidyr

**Paquete adicional usado en `datos_13.mapa-entidades.R` (mapas coropléticos)**

> Pebesma, E. (2018). Simple features for R: Standardized support for spatial vector data.
> *The R Journal*, *10*(1), 439–446. https://doi.org/10.32614/RJ-2018-009

**Paquetes adicionales usados en `datos_19.mca-exploratorio.R` (análisis exploratorio de
correspondencias múltiples)**

> Lê, S., Josse, J., & Husson, F. (2008). FactoMineR: An R package for multivariate analysis.
> *Journal of Statistical Software*, *25*(1), 1–18. https://doi.org/10.18637/jss.v025.i01

> Slowikowski, K. (2024). *ggrepel: Automatically position non-overlapping text labels with
> 'ggplot2'* (Versión 0.9.5) [Paquete de R]. https://CRAN.R-project.org/package=ggrepel

---

## Historial de este archivo

| Fecha | Cambio |
|---|---|
| 26-jul-2026 | Creado, para dejar guardada de forma permanente la referencia del geojson usado en el mapa (antes solo se había dado en la conversación de trabajo, sin persistir en ningún archivo del repositorio). |
| 26-jul-2026 | Se agregó la sección "Herramientas de software": R, RStudio y los 9 paquetes de R usados en `datos_03`, `datos_12` y `datos_13`, con versiones verificadas contra `datos_08.sesion-r-reproducibilidad.txt` (no supuestas) y obtenidas con `citation()` de cada paquete. |
