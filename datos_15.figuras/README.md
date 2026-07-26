# `datos_15.figuras/` — Figuras del análisis descriptivo y bivariado

Este subdirectorio contiene las salidas gráficas generadas por
[`datos_12.analisis-descriptivo.R`](../datos_12.analisis-descriptivo.R) (fig01–fig13) y
[`datos_13.mapa-entidades.R`](../datos_13.mapa-entidades.R) (fig14–fig15), según el diseño de
[`datos_11.plan-analisis-datos.md`](../datos_11.plan-analisis-datos.md).

**No todas estas figuras van al manuscrito final.** Antes de citarlas o insertarlas en el
artículo, consulta [`datos_16.validacion-figuras-manuscrito.md`](../datos_16.validacion-figuras-manuscrito.md),
que aplica el criterio editorial de RIDE ("¿esta figura muestra un patrón que ninguna tabla
puede transmitir, o solo repite números que ya están en `datos_14.tablas-resultados.xlsx`?") y
clasifica cada una. Este README solo describe el contenido; la decisión de qué se conserva está
en `datos_16`.

## Contenido de la carpeta

| Archivo | Contenido | n | Estatus (ver `datos_16`) |
|---|---|---|---|
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
| `fig11_situacion_x_tiempo.png` | Cruce situación laboral × plazo de inicio (RQ6) | 98 | ↪️ Se retira — sin asociación significativa (Fisher p = 0.275, V = 0.211); se reporta como tabla |
| `fig12_situacion_x_motivacion.png` | Cruce situación laboral × motivación (RQ6) | 98 | ↪️ Se retira — sin asociación significativa (Fisher p = 0.084, V = 0.24); se reporta como tabla |
| `fig13_area_x_linea.png` | Cruce área de maestría × línea de doctorado de interés (RQ7) | 100 | ✅ Esencial — única asociación significativa entre las variables categóricas (Fisher p = 0.031, V = 0.417) |
| `fig14_mapa_estado_estudios.png` | Mapa coroplético: entidad donde cursaron la maestría (personas interesadas) | 100 | ✅ Esencial |
| `fig15_mapa_estado_residencia.png` | Mapa coroplético: entidad de residencia actual (personas interesadas) | 100 | ✅ Esencial |
| `pies-de-figura.md` | Título y fuente de las 15 figuras, en el formato exacto de RIDE ("**Figura N.** Título" / "*Fuente: Elaboración propia.*"), listos para pegar como texto de Word encima/debajo de cada imagen | — | Texto de apoyo, no es figura |
| `datos_15.mapa-estado-estudios.csv` | Tabla de apoyo del mapa `fig14`: n por entidad | 100 | Tabla de apoyo, no es figura |
| `datos_15.mapa-estado-residencia.csv` | Tabla de apoyo del mapa `fig15`: n por entidad | 100 | Tabla de apoyo, no es figura |

**Resultado:** de las 15 figuras, **7 son esenciales para el manuscrito**
(fig01, fig02, fig09, fig10, fig13, fig14, fig15); las otras 8 quedan cubiertas por tablas ya
existentes en `datos_14.tablas-resultados.xlsx` (ver detalle y justificación completa en
`datos_16.validacion-figuras-manuscrito.md`).

Nota: existe una cuarta asociación bivariada relevante — entidad de estudios × entidad de
residencia (RQ8, movilidad), Fisher p = 0.0005, V = 0.89 — pero se reporta únicamente como
tabla (`RQ8_movilidad` en `datos_14.tablas-resultados.xlsx`); no tiene una figura propia porque
los dos mapas (`fig14`/`fig15`) ya visualizan cada entidad por separado.

## Pendiente antes de usarse en el manuscrito

Las 15 imágenes llevan actualmente el título dibujado **dentro** del `.png` (no solo como texto
de `pies-de-figura.md`), lo que lo duplicaría con el texto que va en Word. La corrección exacta
(quitar `title = ...` de `labs()` en `datos_12.analisis-descriptivo.R` y
`datos_13.mapa-entidades.R`, solo para las 7 figuras esenciales) está documentada en la sección
4 de `datos_16.validacion-figuras-manuscrito.md` y sigue pendiente de aplicarse.

## Cómo regenerar esta carpeta

```bash
# Desde la carpeta raíz del repositorio, en este orden:
Rscript datos_03.limpieza-datos.R        # datos limpios (requisito previo)
Rscript datos_12.analisis-descriptivo.R  # genera fig01-fig13 + datos_14.tablas-resultados.xlsx
Rscript datos_13.mapa-entidades.R        # genera fig14-fig15 + las 2 tablas de apoyo del mapa
```

Ambos scripts son idempotentes: pueden volver a correrse sin duplicar contenido en
`pies-de-figura.md` ni en `datos_14.tablas-resultados.xlsx`.
