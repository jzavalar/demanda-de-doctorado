# Referencias bibliográficas de fuentes externas

Este archivo reúne, en formato APA 7ª ed. (el exigido por RIDE), las fuentes externas usadas
para construir los datos y las figuras de este repositorio — para que no se pierdan en el
historial de conversaciones de trabajo y estén listas para copiarse directamente a la sección
de Referencias del artículo.

---

## Geometrías del mapa (`datos_13.geojson-entidades-mexico.geojson`)

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

## Historial de este archivo

| Fecha | Cambio |
|---|---|
| 26-jul-2026 | Creado, para dejar guardada de forma permanente la referencia del geojson usado en el mapa (antes solo se había dado en la conversación de trabajo, sin persistir en ningún archivo del repositorio). |
