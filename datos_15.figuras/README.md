# `datos_15.figuras/` — Figuras del análisis descriptivo, bivariado y exploratorio

Este subdirectorio contiene las salidas gráficas generadas por
[`datos_19.mca-exploratorio.R`](../datos_19.mca-exploratorio.R) (fig16–fig17, panorama
exploratorio, se presentan primero en el manuscrito),
[`datos_12.analisis-descriptivo.R`](../datos_12.analisis-descriptivo.R) (fig01–fig13) y
[`datos_13.mapa-entidades.R`](../datos_13.mapa-entidades.R) (fig14–fig15), según el diseño de
[`datos_11.plan-analisis-datos.md`](../datos_11.plan-analisis-datos.md).

**No todas estas figuras van al manuscrito final.** Antes de citarlas o insertarlas en el
artículo, consulta [`datos_16.validacion-figuras-manuscrito.md`](../datos_16.validacion-figuras-manuscrito.md),
que aplica el criterio editorial de RIDE ("¿esta figura muestra un patrón que ninguna tabla
puede transmitir, o solo repite números que ya están en `datos_14.tablas-resultados.xlsx`?"),
clasifica cada una, y trae la numeración **final** del manuscrito (Figura 1 a Figura 9) lista
para pegar en Word en su sección 7. Este README solo describe el contenido con la numeración de
generación; la decisión de qué se conserva y con qué número final está en `datos_16`.

## Contenido de la carpeta

| Archivo | Contenido | n | Estatus (ver `datos_16`) |
|---|---|---|---|
| `fig16_mca_vista_general.png` | Panorama exploratorio multivariado (MCA), vista general de las 6 variables de demanda; inercia acumulada 17.4 % | 98 | ✅ Esencial — Figura 1 del manuscrito (exploratoria, al inicio de Resultados) |
| `fig17_mca_detalle_cumulo.png` | Panorama exploratorio multivariado (MCA), detalle del cúmulo central (15 categorías) | 98 | ✅ Esencial — Figura 2 del manuscrito |
| `fig01_interes_doctorado.png` | Interés general en cursar el doctorado (Sí/No), con IC 95% Wilson | 113 | ✅ Esencial |
| `fig02_linea_doctorado.png` | Línea de doctorado de interés (9 categorías); "Manejo y Aprovechamiento del Paisaje Rural" concentra 55 % | 100 | ✅ Esencial |
| `fig03_genero.png` | Género (Femenino/Masculino) | 113 | ↪️ Se retira — va en la tabla de perfil sociodemográfico |
| `fig04_edad.png` | Edad por rangos (9 categorías) | 113 | ↪️ Se retira — va en la tabla de perfil sociodemográfico |
| `fig05_estado_estudios.png` | Entidad donde cursó la maestría, en barras (17 categorías) | 100 | ↪️ Se retira — redundante con el mapa (`fig14`) |
| `fig06_estado_residencia.png` | Entidad de residencia actual, en barras (24 categorías) | 100 | ↪️ Se retira — redundante con el mapa (`fig15`) |
| `fig07_area_maestria.png` | Área temática de la maestría (5 categorías) | 100 | ↪️ Se retira — va en la tabla de perfil sociodemográfico |
| `fig08_situacion_laboral.png` | Situación laboral (6 categorías) | 100 | ↪️ Se retira — va en la tabla de perfil sociodemográfico |
| `fig09_motivacion.png` | Motivación principal (Investigación 53 %, Docencia 30 %, Aplicación en campo 16 %, Otro 1 %) | 100 | ✅ Esencial |
| `fig10_tiempo_inicio.png` | Plazo estimado para iniciar el doctorado (En 1 año 55 %, Indefinido 18 %, En 2 años 17 %...) | 100 | ✅ Esencial |
| `fig11_situacion_x_tiempo.png` | Cruce situación laboral × plazo de inicio (RQ6) | 98 | ↪️ Se retira — sin asociación significativa (Fisher p = 0.297, V = 0.211); se reporta como tabla |
| `fig12_situacion_x_motivacion.png` | Cruce situación laboral × motivación (RQ6) | 98 | ↪️ Se retira — sin asociación significativa (Fisher p = 0.079, V = 0.24); se reporta como tabla |
| `fig13_area_x_linea.png` | Cruce área de maestría × línea de doctorado de interés (RQ7) | 100 | ✅ Esencial — única asociación significativa entre las variables categóricas (Fisher p = 0.034, V = 0.417) |
| `fig14_mapa_estado_estudios.png` | Mapa coroplético: entidad donde cursaron la maestría (personas interesadas) | 100 | ✅ Esencial |
| `fig15_mapa_estado_residencia.png` | Mapa coroplético: entidad de residencia actual (personas interesadas) | 100 | ✅ Esencial |
| `pies-de-figura.md` | Título y fuente de las 17 figuras, en el formato de generación (no el final — ver `datos_16` sección 7), formato RIDE ("**Figura N.** Título" / "*Fuente: Elaboración propia.*"), listos para pegar como texto de Word encima/debajo de cada imagen | — | Texto de apoyo, no es figura |
| `datos_15.mapa-estado-estudios.csv` | Tabla de apoyo del mapa `fig14`: n por entidad | 100 | Tabla de apoyo, no es figura |
| `datos_15.mapa-estado-residencia.csv` | Tabla de apoyo del mapa `fig15`: n por entidad | 100 | Tabla de apoyo, no es figura |
| `datos_15.mca-dimensiones.csv` | Tabla de apoyo del MCA: valor propio y % de inercia por dimensión | — | Tabla de apoyo, no es figura |
| `datos_15.mca-coordenadas.csv` | Tabla de apoyo del MCA: coordenadas y contribución de cada categoría | 29 categorías | Tabla de apoyo, no es figura |

**Resultado:** de las 17 figuras, **9 son esenciales para el manuscrito**
(fig16, fig17, fig01, fig02, fig09, fig10, fig13, fig14, fig15); las otras 8 quedan cubiertas
por tablas ya existentes en `datos_14.tablas-resultados.xlsx` (ver detalle y justificación
completa en `datos_16.validacion-figuras-manuscrito.md`).

Nota: existe una cuarta asociación bivariada relevante — entidad de estudios × entidad de
residencia (RQ8, movilidad), Fisher p = 0.0005, V = 0.89 — pero se reporta únicamente como
tabla (`RQ8_movilidad` en `datos_14.tablas-resultados.xlsx`); no tiene una figura propia porque
los dos mapas (`fig14`/`fig15`) ya visualizan cada entidad por separado.

## Corrección de formato aplicada (26-jul-2026)

Las 15 imágenes llevaban el título dibujado **dentro** del `.png` (no solo como texto de
`pies-de-figura.md`), lo que lo duplicaba con el texto que va en Word. Se corrigió quitando
`title = ...` de `labs()` en `datos_12.analisis-descriptivo.R` y `datos_13.mapa-entidades.R`
(las 15 figuras, para que el código quede consistente), se regeneró toda la carpeta desde cero,
y se verificó con análisis de imagen (no solo visual) que ya no hay texto de título incrustado.
Detalle completo en la sección 4 de `datos_16.validacion-figuras-manuscrito.md`.

## Corrección de robustez aplicada (26-jul-2026)

Los tres scripts que escriben en `pies-de-figura.md` (`datos_12`, `datos_13`, `datos_19`) ahora
usan un esquema de bloques con marcadores HTML, para que el orden final (MCA → `datos_12` →
mapas) quede garantizado sin importar en qué orden se ejecuten, y sin que uno borre lo que otro
ya escribió. Antes de esta corrección, volver a correr `datos_12` borraba por completo los
pies de figura que `datos_13` ya hubiera agregado.

## Cómo regenerar esta carpeta

```bash
# Desde la carpeta raíz del repositorio (el orden entre estos tres ya no importa
# gracias a la corrección de robustez de arriba, pero datos_03 debe correr primero):
Rscript datos_03.limpieza-datos.R        # datos limpios (requisito previo)
Rscript datos_12.analisis-descriptivo.R  # genera fig01-fig13 + datos_14.tablas-resultados.xlsx
Rscript datos_13.mapa-entidades.R        # genera fig14-fig15 + las 2 tablas de apoyo del mapa
Rscript datos_19.mca-exploratorio.R      # genera fig16-fig17 (panorama exploratorio) + 2 tablas de apoyo
```

Los tres scripts son idempotentes: pueden volver a correrse, en cualquier orden, sin duplicar
ni perder contenido en `pies-de-figura.md` ni en `datos_14.tablas-resultados.xlsx`.
