# Justificación y validación editorial de las figuras del manuscrito

**Documento complementario a:** `datos_11.plan-analisis-datos.md` (fija el diseño analítico),
`datos_12.analisis-descriptivo.R` / `datos_13.mapa-entidades.R` (generan 15 figuras) y
`datos_19.mca-exploratorio.R` (genera 2 figuras exploratorias adicionales) — 17 figuras en
total en `datos_15.figuras/`. Este documento responde a una pregunta distinta: de esas 17
figuras, **¿cuáles son realmente necesarias como figura y cuáles se pueden resumir en una
tabla?** — y valida el diseño resultante contra los criterios editoriales de RIDE.

**Revista de destino:** [RIDE](https://www.ride.org.mx/).
**Última actualización:** 27 de julio de 2026 (nota de tamaño de muestra y consistencia
tipográfica corregidas en las 9 figuras esenciales; ver secciones 5 y 6).

---

## 1. Criterio de selección

RIDE pide explícitamente evaluar si **todas** las tablas y figuras son realmente necesarias, y
prohíbe repetir los datos de una tabla en una figura (o viceversa). Se aplica el mismo criterio
de dos condiciones acordado para este proyecto — una figura se conserva si cumple **al menos
una**:

1. **Visualiza un hallazgo central** que sostiene la hipótesis o las conclusiones (no una
   variable descriptiva incidental).
2. **Muestra un patrón** (espacial, de asociación, de forma de la distribución) que una tabla
   no puede transmitir sin perder el hallazgo.

Con `datos_14.tablas-resultados.xlsx` ya generado (18 hojas, con **todas** las frecuencias
univariadas y cruces bivariados calculados), el criterio se puede aplicar de forma estricta:
si una figura solo repite números que ya están en una hoja de ese archivo, sin agregar un
patrón visual que la tabla no muestre, la figura sobra.

## 2. Clasificación de las 17 figuras generadas

### 2.1 Esenciales — se conservan como figura (9)

Se agregan primero las 2 figuras del MCA exploratorio (acordado con el equipo el 26-jul-2026
para presentarse **al inicio de Resultados**, antes de RQ1, como panorama general — no como
prueba confirmatoria; ver `datos_18.borrador-metodologia-resultados.md`). Esto desplaza la
numeración final del manuscrito en +2 respecto a la versión anterior de este documento.

| # final | Figura | Contenido | Por qué no admite tabla |
|---|---|---|---|
| **Figura 1** | fig16 — MCA, vista general | Panorama exploratorio, n = 98, 6 variables de demanda | Un MCA existe precisamente para mostrar relaciones geométricas entre categorías de varias variables a la vez — imposible tabular sin perder el hallazgo. **Explica solo 17.4 % de la inercia total; se presenta como exploratorio, no confirmatorio** |
| **Figura 2** | fig17 — MCA, detalle del cúmulo | Acercamiento a las 15 categorías centrales, mismo análisis | Evita la sobreposición de etiquetas de la Figura 1; mismo argumento que arriba |
| **Figura 3** | fig01 — Interés en el doctorado | Sí/No, n = 113, con IC 95% Wilson | Resultado insignia del estudio (88.5 %); la figura comunica magnitud **e** incertidumbre a la vez |
| **Figura 4** | fig02 — Línea de doctorado de interés | 9 categorías, n = 100 | Informa directamente el diseño curricular; no está cubierta por ninguna otra figura |
| **Figura 5** | fig09 — Motivación principal | 4 categorías, n = 100 | Sustenta el perfil de egreso en la Discusión |
| **Figura 6** | fig10 — Plazo estimado para iniciar | 7 categorías ordinales, n = 100 | El hallazgo es la **forma** de la distribución (sesgo hacia "1 año"), no solo el número |
| **Figura 7** | fig13 — Área de maestría × línea de interés (RQ7) | Cruce 5×9, asociación significativa (Fisher simulado p = 0.034; V de Cramér = 0.417) | Es el único cruce bivariado confirmatorio con relación relevante; visualizar el patrón de coherencia formación-interés es más claro en figura que en una tabla de 45 celdas — y coherente con el panorama ya insinuado en la Figura 1 |
| **Figura 8** | fig14 — Mapa: entidad donde cursó la maestría | Coroplético, n = 100 | Caso más claro de "no reemplazable por tabla": la dispersión espacial (RQ8) es precisamente lo que una tabla no puede mostrar de un vistazo |
| **Figura 9** | fig15 — Mapa: entidad de residencia actual | Coroplético, n = 100 | Ídem |

### 2.2 Redundantes con una tabla ya existente — se retiran como figura (6)

Estas seis variables univariadas **ya están completamente cubiertas** por las hojas
`Univ_genero`, `Univ_edad`, `Univ_area_maestria` y `Univ_situacion_laboral` de
`datos_14.tablas-resultados.xlsx`. Graficarlas además como figura sería la duplicación que
RIDE prohíbe explícitamente.

| Figura | Por qué se retira |
|---|---|
| **fig03 — Género** | 2 categorías; tabla suficiente (`Univ_genero`) |
| **fig04 — Edad** | 9 rangos, sin patrón adicional al orden natural; tabla suficiente (`Univ_edad`) |
| **fig07 — Área de maestría** | 5 categorías; tabla suficiente (`Univ_area_maestria`) |
| **fig08 — Situación laboral** | 6 categorías; tabla suficiente (`Univ_situacion_laboral`) |

**Recomendación:** consolidar estas cuatro en una sola **Tabla de perfil sociodemográfico**
(Variable | Categoría | n | %), igual que en la versión previa del manuscrito — no hace falta
generar nada nuevo, los números ya están en `datos_14`.

| Figura | Por qué se retira |
|---|---|
| **fig05 — Entidad donde cursó la maestría (barras)** | Redundante con **fig14** (mapa): ambas visualizan la misma variable; el mapa comunica el patrón geográfico mejor que un gráfico de barras de 17 categorías, así que la versión de barras sobra |
| **fig06 — Entidad de residencia actual (barras)** | Redundante con **fig15** (mapa), mismo argumento |

### 2.3 Bivariado sin asociación significativa — se retiran como figura (2)

| Figura | Resultado | Por qué se retira |
|---|---|---|
| **fig11 — Situación laboral × plazo de inicio (RQ6)** | Sin asociación significativa (p = 0.278, V = 0.211) | Sin un patrón que justifique una figura; se reporta como tabla de contingencia + prueba (`Cruce_situacion_laboral__tie`), con su propia salvedad de no significancia |
| **fig12 — Situación laboral × motivación (RQ6)** | Sin asociación significativa (p = 0.080, V = 0.240) | Mismo argumento (`Cruce_situacion_laboral__mot`) |

> Nota metodológica: un resultado no significativo también es un hallazgo legítimo de RQ6 y
> debe reportarse en el texto con su tabla — lo que no se justifica es dedicarle una *figura*
> cuando no hay un patrón visual que mostrar más allá de lo que ya dice la tabla.

### 2.4 Resumen

**17 figuras generadas → 9 esenciales para el manuscrito** (2 exploratorias del MCA + fig01,
fig02, fig09, fig10, fig13, fig14, fig15) **+ 1 tabla de perfil sociodemográfico** (consolidando
fig03/04/07/08) **+ 2 tablas de cruce sin figura** (fig11, fig12) **+ 2 figuras de barras
retiradas por redundancia con mapa** (fig05, fig06). Ninguna de las 18 hojas de
`datos_14.tablas-resultados.xlsx` se pierde: las figuras retiradas simplemente no se duplican
como imagen, su información ya vive en la tabla correspondiente.

## 3. Checklist de validación editorial RIDE

| Criterio RIDE | Regla | Estatus |
|---|---|---|
| Formato de archivo | `.png` | ✅ Cumplido — las 17 imágenes se exportan con `ggsave(..., dpi = 300, bg = "white")` |
| Numeración | Consecutiva en arábigos | ✅ Cumplido — tras retirar las 8 redundantes, la numeración final del manuscrito es Figura 1 a Figura 9 (ver tabla de la sección 2.1) |
| No duplicar datos entre tabla y figura | Sección 13 de la guía RIDE | ✅ Cumplido **tras aplicar la sección 2** de este documento — antes de esta revisión, fig05/fig06 sí duplicaban a fig14/fig15 |
| Evaluar necesidad de cada figura | Sección 13 | ✅ Cumplido — ver clasificación completa arriba |
| Fuente ("Fuente: Elaboración propia") debajo, como texto de Word | Sección 13 | ✅ Cumplido — no se encontró `caption =` en ninguno de los tres scripts generadores (incluido `datos_19.mca-exploratorio.R`, que ya se escribió sin este problema desde el inicio); la fuente vive únicamente en `pies-de-figura.md`, para pegarse como texto de Word, no está incrustada en el `.png` |
| Título arriba, en negritas, como texto de Word (no incrustado en el `.png`) | Sección 13 | ✅ **Corregido el 26-jul-2026** — ver sección 4 (actualizada) |
| Nota de tamaño de muestra dentro del área de la figura | Sección 13 (ejemplo oficial) | ✅ **Corregido el 27-jul-2026** — ver sección 5 |
| Consistencia tipográfica entre figuras (no exigida explícitamente por RIDE, pero relevante frente al cuerpo en Times New Roman 12) | Sección 12 (formato general) | ✅ **Corregido el 27-jul-2026** — ver sección 6 |

## 4. Hallazgo de formato — RESUELTO el 26 de julio de 2026

Al revisar el código fuente de los dos scripts generadores se encontró que las 15 imágenes
llevaban el título **dibujado dentro del PNG** (bold, centrado):

```r
# datos_12.analisis-descriptivo.R, líneas 148 y 239 (ANTES)
labs(x = ..., y = ..., title = etiqueta) +
theme(plot.title = element_text(face = "bold", size = 11), ...)

# datos_13.mapa-entidades.R, línea 102 (ANTES)
labs(title = titulo_interno) +
theme(plot.title = element_text(face = "bold", size = 11, hjust = 0.5), ...)
```

Esto duplicaba el título con el que `pies-de-figura.md` ya genera como texto para pegar en
Word — el mismo problema que ya se había corregido en una iteración anterior del proyecto (el
análisis MCA), pero que había reaparecido en estos dos scripts nuevos.

**Corrección aplicada:** se quitó `title = ...` de cada `labs()` y la línea
`theme(plot.title = ...)` correspondiente, en las tres funciones generadoras de figura de
ambos scripts (barras univariadas, barras apiladas bivariadas, y el mapa coroplético) — es
decir, en las **15** figuras, no solo en las 7 que se conservan, para que el código quede
consistente y cualquier figura que se regenere en el futuro (incluidas las 8 que hoy se
retiran) nazca ya sin este problema.

**Verificación aplicada, no solo visual:** se regeneraron las 15 figuras desde cero
(`datos_03` → `datos_12` → `datos_13`) y se comparó, con Python/Pillow, la franja superior
(filas 0-30 px) de cada imagen antes y después del cambio. Antes del cambio, esa franja tenía
miles de píxeles oscuros (el texto del título); después, 0 píxeles oscuros en las 7 figuras
esenciales — confirmando que el título ya no está incrustado, sin depender solo de una
inspección visual.

## 5. Nota de tamaño de muestra — RESUELTO el 27 de julio de 2026

El ejemplo oficial de RIDE (`03_Ejemplo_Formato_Figura_RIDE.png`) incluye una nota de tamaño de
muestra total dentro del área de la figura (p. ej. "180 RESPUESTAS"). Se detectó que esto era
inconsistente entre las 9 figuras esenciales: fig01/02/09/10 solo tenían `n`/`%` por categoría
(no un total), y fig13 (cruce RQ7) y los dos mapas (fig14, fig15) no llevaban ninguna nota.

**Corrección aplicada:** se agregó una nota `n = N` dentro del área de cada una de las 9
figuras, usando el espacio de subtítulo de ggplot2 (`labs(subtitle = ...)`) — no el de título,
que se eliminó a propósito por el hallazgo de la sección 4. Es una nota de dato (análoga a
"180 RESPUESTAS" del ejemplo oficial), no un título editorial, así que no reintroduce el
problema ya corregido.

**Verificación:** se comprobó con análisis de imagen que la nota aparece en las 9 figuras
(dentro de la franja superior correspondiente a cada tipo de gráfico — los mapas la muestran un
poco más abajo que las barras, por cómo `theme_void()` reserva espacio) y que la franja más
externa (filas 0-12 px) sigue sin contenido, confirmando que el título no se reintrodujo.

## 6. Consistencia tipográfica — RESUELTO el 27 de julio de 2026

Se detectó que `datos_12.analisis-descriptivo.R` y `datos_13.mapa-entidades.R` no especificaban
`family` en sus temas (usaban la fuente sans-serif por defecto del sistema, DejaVu Sans),
mientras que `datos_19.mca-exploratorio.R` sí usaba `family = "Times"` (resuelto a TeX Gyre
Termes). Esto habría producido 7 de las 9 figuras del manuscrito en una tipografía distinta a
las otras 2, y distinta también del cuerpo del texto (Times New Roman 12, exigido en la
sección 12 de las normas de RIDE).

**Corrección aplicada:** se agregó `base_family = "Times"` (y `family = "Times"` en las
etiquetas de texto y leyendas) a las tres funciones generadoras de figura de `datos_12` y a la
función de mapas de `datos_13`, igualando el estilo tipográfico de las 9 figuras esenciales.


## 7. Pendientes antes de dar por cerrada esta validación

- [x] ~~Aplicar la corrección de la sección 4 (quitar título incrustado)~~ — **Hecho el
      26-jul-2026**, en las 15 figuras (no solo las 7 esenciales), con verificación por
      análisis de imagen (no solo visual).
- [x] ~~Integrar el MCA exploratorio~~ — **Hecho el 26-jul-2026**: `datos_19.mca-exploratorio.R`
      recalculado contra los datos actuales (n=98 tras excluir 2 sin dato en situación laboral),
      con `Sys.setlocale` corregido (el script compartido originalmente producía advertencias de
      codificación y un error de parseo sin ese ajuste). Figuras 1-2 del manuscrito final.
- [ ] Actualizar `pies-de-figura.md` para incluir únicamente las 9 figuras finales, ya
      renumeradas consecutivamente (Figura 1 a Figura 9) — ver sección 8 de este documento para
      el texto ya listo; el archivo generado automáticamente sigue mostrando las 17 figuras con
      su numeración de generación (correcto mientras conviven en este repositorio, ver nota al
      inicio de `pies-de-figura.md`).
- [ ] Construir la Tabla de perfil sociodemográfico (fig03/04/07/08 consolidadas) a partir de
      las hojas `Univ_genero`, `Univ_edad`, `Univ_area_maestria` y `Univ_situacion_laboral` de
      `datos_14.tablas-resultados.xlsx` — no requiere volver a calcular nada.
- [ ] Confirmar en el manuscrito que las tablas de `Cruce_situacion_laboral__tie` y
      `Cruce_situacion_laboral__mot` (RQ6, no significativas) se citan en el texto aunque no
      tengan figura asociada.

## 8. Numeración final y texto listo para pegar en Word (9 figuras)

**Figura 1.** Panorama exploratorio de las variables de demanda (análisis de correspondencias múltiples): vista general.

*Nota:* n = 98 personas interesadas (2 excluidas por dato faltante en situación laboral). Análisis exploratorio, no confirmatorio. La proximidad entre categorías sugiere asociación; el color indica la contribución de cada categoría a la formación de las dos dimensiones mostradas, que en conjunto explican solo el 17.4 % de la inercia (variabilidad) total entre categorías — se presenta como panorama general, no como evidencia confirmatoria. El área sombreada corresponde a la región ampliada en la Figura 2.

*Fuente: Elaboración propia.*

**Figura 2.** Panorama exploratorio de las variables de demanda (análisis de correspondencias múltiples): detalle del cúmulo central (n = 15 categorías).

*Nota:* ampliación de la región sombreada en la Figura 1, para evitar la sobreposición de etiquetas. El color indica la contribución de cada categoría a la formación de las dos dimensiones.

*Fuente: Elaboración propia.*

**Figura 3.** Interés en cursar el doctorado

*Fuente: Elaboración propia.*

**Figura 4.** Línea de doctorado de interés

*Fuente: Elaboración propia.*

**Figura 5.** Motivación principal para cursar el doctorado

*Fuente: Elaboración propia.*

**Figura 6.** Plazo estimado para iniciar el doctorado

*Fuente: Elaboración propia.*

**Figura 7.** Área de la maestría según línea de doctorado de interés (RQ7)

*Fuente: Elaboración propia.*

**Figura 8.** Distribución por entidad donde cursaron la maestría, personas interesadas en el doctorado.

*Fuente: Elaboración propia.*

**Figura 9.** Distribución por entidad de residencia actual, personas interesadas en el doctorado.

*Fuente: Elaboración propia.*

**Correspondencia archivo → figura final:**

| Figura final | Archivo |
|---|---|
| Figura 1 | `fig16_mca_vista_general.png` |
| Figura 2 | `fig17_mca_detalle_cumulo.png` |
| Figura 3 | `fig01_interes_doctorado.png` |
| Figura 4 | `fig02_linea_doctorado.png` |
| Figura 5 | `fig09_motivacion.png` |
| Figura 6 | `fig10_tiempo_inicio.png` |
| Figura 7 | `fig13_area_x_linea.png` |
| Figura 8 | `fig14_mapa_estado_estudios.png` |
| Figura 9 | `fig15_mapa_estado_residencia.png` |
