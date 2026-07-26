# Justificación y validación editorial de las figuras del manuscrito

**Documento complementario a:** `datos_11.plan-analisis-datos.md` (fija el diseño analítico) y
`datos_12.analisis-descriptivo.R` / `datos_13.mapa-entidades.R` (generan las 15 figuras en
`datos_15.figuras/`). Este documento responde a una pregunta distinta: de esas 15 figuras,
**¿cuáles son realmente necesarias como figura y cuáles se pueden resumir en una tabla?** —
y valida el diseño resultante contra los criterios editoriales de RIDE.

**Revista de destino:** [RIDE](https://www.ride.org.mx/).
**Última actualización:** 26 de julio de 2026.

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

## 2. Clasificación de las 15 figuras generadas

### 2.1 Esenciales — se conservan como figura (7)

| Figura | Contenido | Por qué no admite tabla |
|---|---|---|
| **fig01 — Interés en el doctorado** | Sí/No, n = 113, con IC 95% Wilson | Resultado insignia del estudio (88.5 %); la figura comunica magnitud **e** incertidumbre a la vez |
| **fig02 — Línea de doctorado de interés** | 9 categorías, n = 100 | Informa directamente el diseño curricular; no está cubierta por ninguna otra figura |
| **fig09 — Motivación principal** | 4 categorías, n = 100 | Sustenta el perfil de egreso en la Discusión |
| **fig10 — Plazo estimado para iniciar** | 7 categorías ordinales, n = 100 | El hallazgo es la **forma** de la distribución (sesgo hacia "1 año"), no solo el número |
| **fig13 — Área de maestría × línea de interés (RQ7)** | Cruce 5×9, asociación significativa (Fisher simulado p = 0.037; V de Cramér = 0.417) | Es el único cruce bivariado con relación relevante y no trivial; visualizar el patrón de coherencia formación-interés es más claro en figura que en una tabla de 45 celdas |
| **fig14 — Mapa: entidad donde cursó la maestría** | Coroplético, n = 100 | Caso más claro de "no reemplazable por tabla": la dispersión espacial (RQ8) es precisamente lo que una tabla no puede mostrar de un vistazo |
| **fig15 — Mapa: entidad de residencia actual** | Coroplético, n = 100 | Ídem |

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

**15 figuras generadas → 7 esenciales para el manuscrito** (fig01, fig02, fig09, fig10, fig13,
fig14, fig15) **+ 1 tabla de perfil sociodemográfico** (consolidando fig03/04/07/08) **+ 2
tablas de cruce sin figura** (fig11, fig12) **+ 2 figuras de barras retiradas por redundancia
con mapa** (fig05, fig06). Ninguna de las 18 hojas de `datos_14.tablas-resultados.xlsx` se
pierde: las figuras retiradas simplemente no se duplican como imagen, su información ya vive
en la tabla correspondiente.

## 3. Checklist de validación editorial RIDE

| Criterio RIDE | Regla | Estatus |
|---|---|---|
| Formato de archivo | `.png` | ✅ Cumplido — las 15 imágenes se exportan con `ggsave(..., dpi = 300, bg = "white")` |
| Numeración | Consecutiva en arábigos | ✅ Cumplido — Figura 1 a Figura 15 en `pies-de-figura.md`; tras retirar las 8 redundantes, renumerar consecutivamente a Figura 1-7 en el manuscrito final |
| No duplicar datos entre tabla y figura | Sección 13 de la guía RIDE | ✅ Cumplido **tras aplicar la sección 2** de este documento — antes de esta revisión, fig05/fig06 sí duplicaban a fig14/fig15 |
| Evaluar necesidad de cada figura | Sección 13 | ✅ Cumplido — ver clasificación completa arriba |
| Fuente ("Fuente: Elaboración propia") debajo, como texto de Word | Sección 13 | ✅ Cumplido — no se encontró `caption =` en ninguno de los dos scripts generadores; la fuente vive únicamente en `pies-de-figura.md`, para pegarse como texto de Word, no está incrustada en el `.png` |
| Título arriba, en negritas, como texto de Word (no incrustado en el `.png`) | Sección 13 | ❌ **No cumplido — hallazgo real, ver sección 4** |

## 4. Hallazgo real: el título SÍ está incrustado en las 15 imágenes

Al revisar el código fuente de los dos scripts generadores se encontró:

```r
# datos_12.analisis-descriptivo.R, líneas 148 y 239
labs(x = ..., y = ..., title = etiqueta) +
theme(plot.title = element_text(face = "bold", size = 11), ...)

# datos_13.mapa-entidades.R, línea 102
labs(title = titulo_interno) +
theme(plot.title = element_text(face = "bold", size = 11, hjust = 0.5), ...)
```

Las 15 imágenes llevan el título **dibujado dentro del PNG** (bold, centrado). Al mismo tiempo,
`pies-de-figura.md` genera el mismo título como texto para pegar en Word ("**Figura N.**
Título..."). Esto significa que, si se sigue el flujo tal cual está hoy, **el título quedaría
duplicado**: una vez dentro de la imagen y otra vez como texto de Word arriba de ella — el
mismo problema que ya se había corregido en una iteración anterior del proyecto (el análisis
MCA), pero que reapareció en estos dos scripts nuevos.

**Corrección recomendada** (mínima, sin tocar el resto del pipeline): quitar `title = ...` de
cada `labs()` y la línea `theme(plot.title = ...)` correspondiente, en ambos scripts, para las
7 figuras que se conservan (fig01, fig02, fig09, fig10, fig13, fig14, fig15) — no hace falta
corregir fig03-fig08, fig11, fig12, fig05, fig06 si de todas formas se retiran del manuscrito.
El título y la fuente deben vivir exclusivamente en `pies-de-figura.md`, tal como ya lo hace la
fuente.

## 5. Observación menor (no bloqueante): nota de tamaño de muestra

El ejemplo oficial de RIDE (`03_Ejemplo_Formato_Figura_RIDE.png`) incluye una nota de tamaño de
muestra total dentro del área de la figura (p. ej. "180 RESPUESTAS"). Las figuras univariadas
(fig01, fig02, fig09, fig10) sí incluyen `n` y `%` como etiqueta de **cada barra**
(`geom_text(aes(label = paste0(n, " (", round(pct,1), "%)")))`), lo que comunica el tamaño de
muestra de forma más granular que el ejemplo oficial. No es un incumplimiento, pero si se
quiere replicar exactamente el formato del ejemplo, se puede añadir además una anotación única
con el total (`n total = 100`) en una esquina del gráfico. fig13 (cruce) y los dos mapas
(fig14, fig15) no llevan actualmente esa nota — recomendable agregarla si el espacio lo permite.

## 6. Pendientes antes de dar por cerrada esta validación

- [ ] Aplicar la corrección de la sección 4 (quitar título incrustado) en las 7 figuras que se
      conservan, y regenerar solo esas 7 imágenes.
- [ ] Actualizar `pies-de-figura.md` para incluir únicamente las 7 figuras finales, ya
      renumeradas consecutivamente (Figura 1 a Figura 7).
- [ ] Construir la Tabla de perfil sociodemográfico (fig03/04/07/08 consolidadas) a partir de
      las hojas `Univ_genero`, `Univ_edad`, `Univ_area_maestria` y `Univ_situacion_laboral` de
      `datos_14.tablas-resultados.xlsx` — no requiere volver a calcular nada.
- [ ] Confirmar en el manuscrito que las tablas de `Cruce_situacion_laboral__tie` y
      `Cruce_situacion_laboral__mot` (RQ6, no significativas) se citan en el texto aunque no
      tengan figura asociada.
