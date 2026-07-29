# Arquitectura de secciones del manuscrito

**Artículo:** *Análisis de la demanda del Doctorado en Ciencias integrado a la Maestría
Profesionalizante en Paisaje y Turismo Rural*
**Revista:** RIDE · **Dictamen:** 8-ago-2025, publicable con modificaciones sustanciales (39/50)
**Base:** `4_manuscrito-base_20260628` + repositorio con cifras canónicas congeladas
(`datos_23`)

---

## 1. El problema

El manuscrito base metió seis apartados nuevos **dentro de Resultados** para atender el
dictamen: contexto ambiental, antecedentes institucionales, plan curricular, pertinencia, perfil
de egreso y comparativo internacional. Ninguno es resultado del estudio de demanda: son marco,
justificación y propuesta.

Eso explica tres de los rubros donde se perdió punto —2.3 coherencia objetivos-método-
resultados, 3.1 título que no refleja el contenido, 3.3 hilo conductor— y ninguno se repara
escribiendo mejor. Se reparan moviendo.

**Principio rector:** *el artículo es un estudio de demanda; la propuesta del programa es el
contexto que le da sentido, no el objeto de estudio.* Todo lo que se investigó con el
cuestionario va a Resultados; todo lo que fundamenta por qué valía la pena investigarlo va a
Introducción; todo lo que los hallazgos permiten decidir sobre el programa va a Discusión.

**Nota importante sobre el cumplimiento del dictamen.** El editor pidió que ciertos contenidos
*estuvieran*, no que estuvieran en Resultados. Reubicarlos no incumple: los conserva íntegros y
además repara los rubros de coherencia. Conviene decirlo así en la carta de respuesta.

---

## 2. Mapa: de dónde viene cada bloque

| Bloque del manuscrito base | Destino propuesto | Por qué |
|---|---|---|
| Resultados §1 — Contexto ambiental, cultural, socioeconómico | **Introducción 1.2** | Es el marco que justifica la pertinencia territorial; no se obtuvo del cuestionario |
| Resultados §2 — Antecedentes institucionales, PND, plan estatal | **Introducción 1.3** | Justificación de política pública; responde a la observación 1 del dictamen |
| Resultados §6 — Comparativo de programas doctorales *(vacío)* | **Introducción 1.4** | Establece el vacío formativo: es la premisa del estudio, no su hallazgo |
| Resultados §7 — Perfil que buscan los egresados | **Resultados completo** | Es el único bloque que sí proviene del cuestionario |
| Resultados §3 — Plan curricular y LGAC | **Discusión 4.2** | Es lo que los hallazgos permiten afinar, no lo que se midió |
| Resultados §5 — Perfil de egreso | **Discusión 4.3** | Igual; se conecta con motivación declarada y mercado laboral |
| Resultados §4 — Pertinencia del programa | **Discusión 4.5** | Interpretación, no dato |
| Discusión §1 — Contexto | **se disuelve** | Su contenido se integra a Introducción 1.2 y a Discusión 4.5 |
| *Limitaciones metodológicas (vacío)* | **Discusión 4.6** | Ya redactado en `datos_18` |

---

## 3. Estructura propuesta

### Sección de inicio (sin numerar)
Portada · Resumen/Abstract (≤250 palabras, 2 párrafos, BACKGROUND-OBJECTIVES-METHODS-
RESULTS-CONCLUSIONS) · Palabras clave (≤6)

### 1. Introducción
- **1.1** El posgrado en México y por qué un análisis de demanda precede a la creación de un
  programa *(de lo general a lo específico)*
- **1.2** Contexto ambiental, cultural y socioeconómico de la región de influencia
  *(con las citas verificadas: CONABIO 2023, INALI 2008, Gasperín-García et al. 2023,
  Rivera-Hernández et al. 2018, SEMARNAT)*
- **1.3** Antecedentes institucionales y alineación con los planes de desarrollo vigentes
- **1.4** La oferta doctoral existente y el vacío formativo → **Tabla 1**, comparativo de
  programas
- **1.5** Objetivo, preguntas de investigación (RQ1–RQ8) e hipótesis de trabajo

### 2. Materiales y Métodos
- **2.1** Diseño y enfoque — declarar el muestreo **no probabilístico** desde aquí
- **2.2** Población y participantes — los 32 posgrados consultados y los 16 seleccionados
- **2.3** Instrumento — 10 reactivos
- **2.4** Procedimiento de recolección (abril–mayo 2024)
- **2.5** Procesamiento y limpieza de datos
- **2.6** Plan y técnicas de análisis — Fisher simulado, V de Cramér, IC exacto, software
- **2.7** Transparencia, disponibilidad de datos y reproducibilidad

### 3. Resultados *(solo lo que salió del cuestionario)*
- **3.1** Panorama exploratorio multivariado (MCA) → **Figuras 1–2**
- **3.2** RQ1 Magnitud del interés → **Figura 3**
- **3.3** RQ2 Línea de mayor interés → **Figura 4**
- **3.4** RQ3 Perfil sociodemográfico y académico → **Tabla 2**
- **3.5** RQ4 Motivación principal → **Figura 5**
- **3.6** RQ5 Plazo estimado de inicio → **Figura 6**
- **3.7** RQ6 Situación laboral y su asociación con plazo y motivación → **Tabla 3**
- **3.8** RQ7 Coherencia entre formación previa y línea de interés → **Figura 7**
- **3.9** RQ8 Movilidad geográfica → **Figuras 8–9**

### 4. Discusión
- **4.1** Magnitud y coherencia del interés declarado *(RQ1, RQ7)* — incluye la corrección
  sobre la tendencia por edad
- **4.2** Implicaciones para el plan curricular y las LGAC *(RQ2, RQ4)*
- **4.3** Perfil de egreso y correspondencia con el mercado laboral y académico *(RQ3, RQ4)*
- **4.4** Planeación de cohortes y modalidad de impartición *(RQ5, RQ6, RQ8)*
- **4.5** Posicionamiento del programa frente a la oferta existente *(Tabla 1 + RQ2)*
- **4.6** Limitaciones del estudio

### 5. Conclusiones
### 6. Futuras líneas de investigación
### Agradecimientos · Referencias

---

## 4. Cómo esta arquitectura repara el tabulador

| Rubro | Perdido | Qué lo repara |
|---|---|---|
| 2.3 Coherencia objetivos-método-resultados | −1 | Resultados contiene solo resultados; cada apartado responde a una RQ declarada en 1.5 |
| 3.1 Título no refleja el contenido | −1 | Al ser el artículo un estudio de demanda, el título vigente **ya lo refleja**: no hay que cambiarlo, hay que ajustar el contenido a él |
| 3.3 Hilo conductor | −1 | 1.5 plantea las RQ, la sección 3 las responde en orden, la 4 las interpreta en el mismo orden |
| 4.2 Citas, discusión y conclusiones | −3 | Discusión con seis apartados y comparación explícita con literatura; eliminar sobrecitas (máx. 3 por aseveración) |
| 5.2 Futuras líneas no desarrolladas | −2 | Sección 6 propia, desarrollada, derivada de las limitaciones de 4.6 |
| 6.2 Referencias | −1 | Revisión APA 7 completa al final |

**Los 12 puntos perdidos son recuperables.** Ninguno exige datos nuevos.

---

## 5. Lo que hay que escribir desde cero

| Pieza | Estado | Fuente disponible |
|---|---|---|
| **Tabla 1 — comparativo de programas doctorales** | ❌ vacía en el base | Baltazar-Bernal (2025) mapeó 24 programas: 8 México, 8 Iberoamérica, 8 Norteamérica/Europa |
| **4.6 Limitaciones** | ❌ decía "NO TENGO IDEA" | Ya redactado en `datos_18` |
| **6. Futuras líneas** | ⚠️ enunciadas, no desarrolladas | Se derivan de 4.6 |
| **Resumen/Abstract** | ⚠️ dice "probabilística" | Reescribir con las cifras canónicas |
| **2.7 Transparencia** | ❌ no existe | Exigida por RIDE; el repositorio ya la sustenta |

**Sobre la Tabla 1, una advertencia.** El comparativo ya existe en Baltazar-Bernal (2025).
Reproducirlo completo duplicaría el artículo complementario. Lo correcto: citar ese trabajo por
el mapeo de los 24 programas y presentar aquí una **síntesis de ocho** —cinco nacionales y tres
internacionales, que es exactamente lo que pidió el editor— con la columna de costo estimado en
pesos, que es el dato que aquel artículo no trae. Así se cumple la observación sin duplicar, y
de paso se hace visible la articulación entre ambos trabajos.

---

## 6. Presupuesto de páginas — hay un problema

RIDE recomienda máximo **30 cuartillas incluyendo tablas, figuras y referencias**.

| Sección | Estimado |
|---|---|
| Portada + resumen/abstract | 2 |
| Introducción (con Tabla 1) | 6 |
| Materiales y Métodos | 4 |
| Resultados (9 figuras + 2 tablas) | 8 |
| Discusión | 5 |
| Conclusiones + futuras líneas | 2 |
| Referencias | 4 |
| **Total** | **~31** |

Estamos al límite o encima. Dos ajustes que lo resuelven sin sacrificar contenido:

1. **Mover a un anexo del repositorio la tabla de los 32 posgrados consultados.** Ocupa dos
   páginas del manuscrito enviado, con enlaces largos que además envejecen mal. En el
   manuscrito basta una síntesis —número de programas por entidad e institución— y una
   remisión al repositorio. Es usar el repositorio como activo real, no como apéndice
   decorativo, y es coherente con el argumento de transparencia.
2. **Consolidar las Figuras 8–9** (los dos mapas coropléticos) en una sola figura de dos
   paneles. Ahorra media página y se lee mejor comparativamente.

Con eso quedamos en ~28 cuartillas, con margen.

---

## 7. Pendientes administrativos, no de redacción

- **Autoría.** La versión dictaminada la firman Baltazar Bernal, **Tiscareño Ramírez** e
  Hidalgo Contreras. El manuscrito base sustituye a la Dra. Tiscareño por Zavala Ruiz. RIDE
  exige aprobación de todos los autores y explicación al editor para cualquier cambio posterior
  al envío. Hay que resolverlo antes de reenviar.
- **Título corto.** "Demanda de un Doctorado Concatenado" son 34 caracteres; el límite es 20.
  Propuesta: **"Demanda doctoral"** (16).
- **ORCID** de los tres autores en la portada — ya están.
- **Cuota de publicación** según número de autores, pagadera solo tras el dictamen final.

---

## 8. Orden de trabajo propuesto

Sección por sección, con confirmación antes de avanzar, como veníamos:

1. **Materiales y Métodos** — es el que ya está más maduro en `datos_18` y el que fija las
   cifras canónicas y el muestreo no probabilístico.
2. **Resultados** — con las cifras congeladas y la numeración final de figuras.
3. **Discusión** — incluye reubicar plan curricular y perfil de egreso.
4. **Introducción** — se escribe al final a propósito: solo cuando Resultados y Discusión están
   fijos se sabe qué debe prometer la Introducción.
5. **Conclusiones y futuras líneas.**
6. **Resumen/Abstract** — siempre al último.
7. **Referencias y revisión de formato** contra el checklist maestro.
8. **Carta de respuesta al editor**, con la tabla de conciliación de `datos_20`.
