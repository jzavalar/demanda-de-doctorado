# Reporte de validación del procedimiento de limpieza de datos

**Estudio:** Demanda potencial para un Doctorado en Ciencias (paisaje y turismo rural, desarrollo,
manejo y aprovechamiento del paisaje rural) — Universidad Autónoma Metropolitana (UAM)
**Última revisión:** 23 de julio de 2026
**Script auditado:** [`datos_03.limpieza-datos.R`](datos_03.limpieza-datos.R)

---

## 1. Alcance

Este reporte documenta la auditoría del proceso de limpieza de datos, desde el archivo crudo
(`datos_01.datos-brutos-cuestionario.xlsx`) hasta los archivos limpios finales
(`datos_04.datos-limpios-completos.*`, `datos_05.datos-interesados.*`), e indica qué hallazgos
quedaron corregidos en la versión final del script y cuáles requieren una decisión editorial
del equipo de investigación.

## 2. Resumen ejecutivo

- **Integridad:** 113 respuestas, sin registros duplicados y sin pérdida de filas en ningún
  paso de la limpieza (verificado automáticamente por el script, bloque de validación de
  integridad).
- **Dato faltante real vs. respuesta libre vs. no aplica:** el script distingue explícitamente
  estos tres casos (antes se mezclaban):
  - **Dato faltante real** → `NA` (p. ej. "No contesto" en `situacion_laboral`, 2 casos).
  - **No aplica por diseño del cuestionario** → `NA` (p. ej. `doctorado_de_interes` para las
    13 personas que respondieron "No" a `interes_en_doctorado`; la pregunta no les aplicaba).
  - **Respuesta libre válida sin categoría predefinida** → se conserva como `"Otro"` **y** el
    texto original íntegro en una columna espejo `..._otro_texto` (p. ej. "Sector privado",
    "no tengo interés, estoy por jubilarme", "Ninguno" en `motivacion_en_doctorado`).

## 3. Hallazgos y su estatus final

| # | Hallazgo | Variable(s) | Severidad original | Estatus en `datos_03.limpieza-datos.R` |
|---|---|---|---|---|
| 1 | El instrumento en Word no incluye la pregunta filtro Sí/No como ítem propio; el formulario en línea sí la aplicó. | `interes_en_doctorado` | Media | **Documentado**, no corregible por script — ver nota en [`datos_00.instrumento-cuestionario.md`](datos_00.instrumento-cuestionario.md). |
| 2 | `area_maestria` llega pre-codificada en el archivo fuente, no es una respuesta directa del cuestionario. | `area_maestria` | Media | **Documentado**; el script no la re-recodifica (evita doble codificación), solo normaliza texto. |
| 3 | El archivo limpio recortaba espacios en `estado_estudios`/`estado_residencia` sin que el script original lo documentara. | `estado_estudios`, `estado_residencia` | Baja | **Corregido**: ahora es un paso explícito y documentado (normalización Unicode NFC + `str_squish()`). |
| 4 | "Michoacán" vs. "Michoacan" (sin acento) como categorías distintas. | `estado_residencia` | Media | **Corregido** vía catálogo auditable — ver [`datos_02.catalogo-estandarizacion-entidades.csv`](datos_02.catalogo-estandarizacion-entidades.csv). |
| 5 | Valor ambiguo "México" (¿Edomex? ¿CDMX? ¿país?). | `estado_residencia` | Media | **Resuelto por decisión editorial**: se mapea a "Estado de México", justificado en el catálogo (esa misma persona reportó "Estado de México" en `estado_estudios`). |
| 6 | "Sector privado" se fusionaba con "Aplicación en campo" por una expresión regular demasiado amplia. | `motivacion_en_doctorado` | Alta | **Corregido**: patrones estrictos por categoría; "Sector privado" ahora es `"Otro"` con el texto original preservado en `motivacion_en_doctorado_otro_texto`. |
| 7 | "Indefinido" (plazo no definido, sí hay respuesta) se fusionaba con "No especifica" (dato faltante). | `tiempo_inicio_doctorado` | Alta | **Corregido**: "Indefinido" es ahora una categoría propia (24 casos), distinta de un `NA` real. |
| 8 | Variantes ortográficas sin normalizar en texto libre (con/sin acentos, mayúsculas). | `maestria_estudiada`, `universidad_estudios_maestria` | Baja | **Parcialmente corregido**: normalización Unicode/espacios aplicada; no se fuerzan a categorías (se conservan como texto libre, por diseño). |
| 9 | Sin duplicados ni valores faltantes no documentados en el archivo crudo. | Todas | N/A (hallazgo positivo) | Verificado, sin acción. |
| 10 | El archivo de interesados es exactamente el subconjunto `interes_en_doctorado = "Sí"`. | — | N/A (hallazgo positivo) | Verificado, sin acción. |

## 4. Verificaciones automatizadas incluidas en el script

- Validación de existencia del archivo de entrada y de las 13 columnas esperadas (detiene la
  ejecución con un mensaje explícito si falla).
- Validación de integridad: el número de filas al final debe coincidir con el del archivo
  crudo; si no coincide, el script se detiene antes de exportar nada.
- Advertencia automática (`warning()`) si algún valor de entidad federativa no está en el
  catálogo de estandarización, para que no pase inadvertido en levantamientos futuros.
- Captura del entorno de ejecución (versión de R y de cada paquete) en
  [`datos_08.sesion-r-reproducibilidad.txt`](datos_08.sesion-r-reproducibilidad.txt) cada vez
  que se corre el script.

## 5. Pendiente de decisión editorial (no resuelto por el script, a propósito)

- Confirmar si el manuscrito reportará los conteos de esta versión final (p. ej. 18 casos —no
  19— en "Aplicación en campo"; 24 casos de "Indefinido" en vez de "No especifica") y actualizar
  en consecuencia cualquier tabla, figura o texto ya redactado con la versión anterior de los
  datos.
- Si se desea, anexar la exportación exacta del formulario en línea (Google Forms) para cerrar
  la discrepancia de documentación del hallazgo #1.

## 6. Trazabilidad

Este reporte corresponde a la ejecución de `datos_03.limpieza-datos.R` sobre
`datos_01.datos-brutos-cuestionario.xlsx`, verificada línea por línea contra
`datos_04.datos-limpios-completos.csv`. El detalle completo de cada valor recodificado está en
la hoja `Codebook_v3_2pasos` de [`datos_06.diccionario-datos.xlsx`](datos_06.diccionario-datos.xlsx).
