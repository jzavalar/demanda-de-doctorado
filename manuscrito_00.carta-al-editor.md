# Carta de respuesta al dictamen editorial

> **Documento de trabajo.** Borrador para revisión del equipo. Los campos entre corchetes
> requieren confirmación antes del envío.

---

**Dra. Fca. Angélica Monroy García**
Directora Editorial
RIDE. Revista Iberoamericana para la Investigación y el Desarrollo Educativo

**Asunto:** Respuesta al dictamen del manuscrito DE1516, *Análisis de la demanda del Doctorado
en Ciencias integrado a la Maestría Profesionalizante en Paisaje y Turismo Rural*

[Ciudad], [fecha]

Estimada Dra. Monroy García:

Le agradecemos el dictamen del 8 de agosto de 2025 y, en particular, el detalle de sus
observaciones. El cuadro de evaluación y las ocho recomendaciones para los autores nos
permitieron identificar con precisión qué debía corregirse; esta carta describe cómo se atendió
cada punto y qué otros cambios introdujimos por iniciativa propia.

Le anticipamos que la revisión resultó más profunda de lo que las observaciones exigían. Además
de incorporar los contenidos solicitados, rehicimos el análisis estadístico completo desde los
datos brutos y reorganizamos la estructura del artículo. Ambas decisiones tienen consecuencias
que conviene explicar antes del punto por punto, y a ello dedicamos los dos primeros apartados.

---

## 1. Reorganización estructural del manuscrito

Las observaciones nos pidieron incorporar cuatro contenidos nuevos: justificación con
antecedentes institucionales y planes de desarrollo, propuesta de plan curricular y líneas de
generación y aplicación del conocimiento, perfil de egreso, y análisis comparativo de programas
afines. Al integrarlos advertimos un problema de arquitectura: ninguno de esos contenidos es
resultado del estudio de demanda. Son marco, justificación y propuesta.

Ubicarlos dentro de la sección de Resultados —como habíamos hecho en un primer intento—
producía justamente lo que su dictamen señaló en tres criterios: debilitaba la relación entre
objetivos, metodología y resultados (2.3), hacía que el título no reflejara el contenido (3.1) y
afectaba el hilo conductor (3.3).

Optamos por una solución distinta. El artículo se organiza ahora bajo un principio explícito:
**es un estudio de demanda; la propuesta del programa es el contexto que le da sentido, no el
objeto de estudio.** En consecuencia, los contenidos solicitados se conservan íntegros, pero
cada uno ocupa la sección que le corresponde: 1) los antecedentes institucionales, los planes de
desarrollo y el análisis comparativo fundamentan el vacío formativo en la Introducción; 2) el
plan curricular, las líneas de generación y aplicación del conocimiento y el perfil de egreso
aparecen en la Discusión, como aquello que los hallazgos permiten precisar; y 3) la sección de
Resultados contiene únicamente lo que se obtuvo del cuestionario.

Con esta organización, el título de la versión dictaminada sí refleja el contenido del artículo,
por lo que se conserva sin cambios.

---

## 2. Reanálisis de los datos y conciliación de cifras

La versión dictaminada analizó los datos con software propietario. Decidimos rehacer el análisis
íntegramente con software libre y de código abierto, por una razón que consideramos pertinente
para un artículo cuyos resultados fundamentan una decisión académica: un análisis ejecutado con
software propietario solo puede ser verificado por quien disponga de una licencia; uno ejecutado
con herramientas libres puede verificarlo cualquier lector, sin costo ni permiso.

El reanálisis partió de los datos brutos e incluyó limpieza, recodificación, análisis
estadístico y generación de figuras. Los datos, los scripts, el diccionario de datos y el
registro del entorno de ejecución se depositaron en un repositorio público bajo licencia
Creative Commons Atribución 4.0. Todas las cifras se generaron en una corrida única con semilla
fija, y se verificaron por dos vías: la reejecución completa del procedimiento, que produjo un
resultado idéntico, y una reimplementación independiente en un segundo lenguaje de programación,
con algoritmo de simulación distinto, cuyos resultados coinciden con los del primero dentro del
error de simulación.

**Este reanálisis modificó algunas cifras respecto de la versión dictaminada.** Como
consideramos que ocultar ese hecho sería impropio, lo declaramos con detalle. Los cambios son de
tres tipos y ninguno afecta la conclusión del estudio.

### 2.1 Cambio de denominador

De las 113 personas que respondieron, 100 declararon interés. Las preguntas sobre línea
temática, motivación y plazo de inicio se formularon únicamente a esas 100, por lógica de salto
del formulario. La versión dictaminada calculó todos los porcentajes sobre 113, lo que
incorporaba al denominador a trece personas que no podían contribuir al numerador y subestimaba
de forma sistemática cada proporción.

| Indicador | Versión dictaminada | Versión revisada |
|---|---|---|
| Línea de mayor interés | 49 % | **55.0 %** |
| Segunda y tercera líneas | 15 % cada una | **17.0 %** cada una |
| Motivación: investigación | 54 % | **53.0 %** |
| Motivación: docencia | 27 % | **30.0 %** |
| Plazo de inicio menor a un año | 53 % | **55.0 %** |

Se trata de una única causa identificable: cada cifra de la columna izquierda se reproduce
exactamente dividiendo el recuento entre 113. El artículo declara ahora el denominador de cada
proporción de forma explícita.

### 2.2 Cambio de técnica estadística

Entre el 55 % y el 100 % de las frecuencias esperadas de las tablas de contingencia resultan
menores que cinco, condición en la que la prueba de ji cuadrada clásica no es válida. Se
sustituyó por la prueba exacta de Fisher con simulación Monte Carlo, con semilla y número de
réplicas declarados, y se añadió el tamaño de efecto (V de Cramér) en todos los cruces
sometidos a prueba.

### 2.3 Correcciones sustantivas

Tres afirmaciones de la versión dictaminada no se sostienen con los datos, y se corrigen.

**Primera.** El resumen calificaba el estudio como probabilístico. El muestreo fue no
probabilístico, intencional y con autoselección de los participantes. Lo señalamos con
franqueza, tanto más cuanto que la declaración de apertura de su dictamen recogió esa misma
calificación a partir de nuestro texto. La versión revisada lo declara desde el resumen y
desarrolla sus implicaciones en Materiales y Métodos y en el apartado de limitaciones. Esta
corrección responde también a la primera debilidad señalada en el dictamen.

**Segunda.** El texto afirmaba, en Resultados y en Discusión, que el interés por cursar el
doctorado aumenta conforme aumenta el rango de edad. Los datos no lo sostienen: la proporción de
personas interesadas asciende hasta los 40 años y después oscila sin dirección definida, y la
prueba de tendencia arroja una pendiente negativa y no significativa (β = −0.037; p = 0.157),
confirmada por un segundo procedimiento con supuestos distintos (ρ de Spearman = −0.047;
p = 0.623). La afirmación se retira y se sustituye por la descripción que los datos permiten.

**Tercera.** El texto presentaba una medida de asociación de Cramér igual a la unidad como
evidencia de asociación alta entre la intención de cursar el doctorado y las temáticas del plan
de estudios. Un valor unitario indica asociación perfecta y, en este caso, era un artefacto de
cálculo. Se retira. El hallazgo que esa afirmación buscaba sostener —que el interés declarado es
coherente con la formación previa— sí se sostiene, con la prueba adecuada: la asociación entre
el área de la maestría cursada y la línea doctoral de interés resulta significativa
(p = 0.034) y de intensidad moderada-alta (V de Cramér = 0.417).

**La conclusión del estudio no se modifica.** El 88.5 % de las personas consultadas declaró
interés en el programa, con intervalo de confianza exacto de 95 % entre 81.1 % y 93.7 %, y
ninguna de las cifras que cambiaron sostiene esa conclusión.

Adjuntamos como anexo la tabla completa de conciliación, con cada cifra modificada, su valor
anterior, su valor nuevo y su causa.

---

## 3. Respuesta punto por punto a las observaciones

| # | Observación del dictamen | Atención | Ubicación |
|---|---|---|---|
| 1 | Sección de justificación con antecedentes institucionales, PND vigente, Plan de Desarrollo Estatal y planes institucionales | Incorporada | Introducción, §1.3 |
| 2 | Propuesta de plan curricular y desarrollo de las LGAC | Incorporada | Discusión, §4.2 |
| 3 | Vincular la pertinencia con las necesidades no cubiertas por otras instituciones | Incorporada | Introducción §1.4 (evidencia) y Discusión §4.5 (interpretación) |
| 4 | Análisis del perfil de egreso y su correspondencia con el mercado laboral o académico | Incorporado | Discusión, §4.3 |
| 5 | Estandarizar el formato de las figuras y describir ejes y unidades | Atendida | Todas las figuras regeneradas con formato uniforme, título sobre la imagen, fuente al pie, ejes y unidades rotulados, y sin texto incrustado en la imagen |
| 6 | Mejorar la precisión de las citas según normas APA | Atendida | Referencias revisadas íntegramente contra fuente primaria |
| 7 | Apartado más explícito de limitaciones metodológicas | Incorporado | Discusión, §4.6 |
| 8 | Tabla comparativa de ≥5 programas nacionales y ≥3 internacionales, con nombre, institución, país, objetivo, perfil de egreso y costo estimado en pesos | Incorporada | Introducción, Tabla 1 |

Sobre la observación 8, una precisión. El mapeo de programas doctorales afines fue desarrollado
en un trabajo previo del equipo, citado en el manuscrito como *Autor/a* (2025) por razones de
arbitraje ciego (véase el apartado 6), que documenta 24 programas: ocho en
México, ocho en Iberoamérica y ocho en Norteamérica y Europa. Reproducirlo íntegro habría
duplicado esa publicación. La Tabla 1 presenta, por tanto, la síntesis de los ocho programas más
próximos al perfil propuesto —cinco nacionales y tres internacionales, conforme a lo
solicitado—, con las seis columnas requeridas, e incorpora el costo estimado en pesos mexicanos,
dato que aquel trabajo no incluía. Se cita la fuente del mapeo original.

---

## 4. Respuesta a las debilidades señaladas

**Representatividad de la muestra.** Es la observación que motivó el cambio de mayor alcance. La
versión revisada no atenúa la limitación: la declara desde el resumen, explica en Materiales y
Métodos por qué no era posible un muestreo probabilístico —no existe marco muestral de
aspirantes potenciales a un programa que aún no se oferta—, precisa que los intervalos de
confianza deben leerse como medida de precisión muestral y no como margen de error extrapolable,
y desarrolla en el apartado de limitaciones el sesgo de autoselección previsible.

**Sobrecitas.** Se revisó el texto completo con el criterio de una fuente por aseveración, salvo
cuando la comparación entre fuentes es el punto que se argumenta. Se eliminaron los casos de
citas múltiples para una misma idea.

**Numeración y descripción de figuras.** Las figuras se regeneraron por completo. Cada una lleva
número y título en el formato de la revista, ejes y unidades rotulados, y el tamaño de muestra
sobre el que se calcula. Se redujo su número de diecisiete a nueve, conservando las que aportan
información no redundante.

---

## 5. Cambio en la autoría

El manuscrito dictaminado fue firmado por la Dra. Obdulia Baltazar Bernal, la
[Dra. Tiscareño Ramírez] y el Dr. [Hidalgo Contreras]. La versión revisada incorpora al
Dr. Jesús Zavala Ruiz, responsable del reanálisis estadístico, la construcción del repositorio
de datos y la verificación de reproducibilidad, y no incluye a la [Dra. Tiscareño Ramírez].

Sometemos este cambio a su consideración conforme a las normas de la revista. Todos los autores
de la versión dictaminada fueron informados y manifestaron su conformidad; adjuntamos la
constancia correspondiente. [**Pendiente de confirmar antes del envío.**]

---

## 6. Referencias anonimizadas para el arbitraje

Dos de las referencias citadas en el manuscrito están firmadas por autores de este trabajo. Para
no comprometer el arbitraje ciego, en el cuerpo del artículo aparecen como *Autor/a* y, en la
lista de referencias, sustituidas por un marcador. Las proporcionamos aquí íntegras, y quedamos
a la espera de su indicación para restituirlas en la versión definitiva una vez concluido el
proceso de dictamen:

> **(Autor/a, 2025)** — Baltazar-Bernal, O. (2025). Needs analysis of a PhD program concatenated
> with a professional master's in landscape and rural tourism in Mexico. *Education Sciences*,
> *15*(6), 646.

> **(Autor/a, 2015)** — Baltazar Bernal, O. y Zavala Ruiz, J. (2015). El turismo rural como
> experiencia significativa y su estudio desde la fenomenología existencial. *Revista Mexicana
> de Ciencias Agrícolas*, *6*(6), 1387–1401.

La primera es especialmente pertinente para la evaluación: es el trabajo del que procede el
mapeo de programas doctorales afines que sustenta la Tabla 1, elaborada en atención a la octava
observación del dictamen. Si el comité considera preferible que ambas referencias aparezcan
completas desde esta versión, las restituimos de inmediato.

## 7. Disponibilidad de los materiales

Los datos, los scripts de limpieza y análisis, el diccionario de datos, el registro del entorno
de ejecución y los archivos de instalación se encuentran depositados en un repositorio público
bajo licencia CC BY 4.0. Su dirección se comunica en esta carta y no en el cuerpo del
manuscrito, para no comprometer el anonimato del proceso de arbitraje:
[**dirección o DOI, a definir**].

Quedamos atentos a sus indicaciones y agradecemos de antemano el tiempo dedicado a la revisión.

Atentamente,

**Dra. Obdulia Baltazar Bernal**
Autora de correspondencia
Colegio de Postgraduados, Campus Córdoba
obduliabb@colpos.mx

**Anexos:** 1) Tabla de conciliación de cifras. 2) Constancia de conformidad de los autores.

---

## Notas para el equipo (no forman parte de la carta)

**1. Confirmar antes del envío:** nombres completos y grados de los coautores de la versión
dictaminada; la constancia de conformidad sobre el cambio de autoría; y el DOI o la dirección
anónima del repositorio.

**2. Sobre el anexo de conciliación:** puede enviarse tal como está en
`datos_20.conciliacion-cifras.md`, o resumirse a las tablas A y B si se prefiere un documento
más breve. Recomiendo enviarlo completo: es la evidencia de que el cambio de cifras fue
auditado y no improvisado.

**3. Decisión pendiente sobre el tono del apartado 2.3.** La carta declara los tres errores de
forma directa. Es la opción que recomiendo —una revista que descubre por su cuenta una
corrección no declarada reacciona mucho peor que ante una declarada—, pero es una decisión de
los autores y admite una redacción más discreta si así lo prefieren.

**4. Variable de área disciplinaria — resuelto.** El área de la maestría se obtiene del reactivo
6 del cuestionario (nombre del programa, texto libre), agrupado por campo de conocimiento
predominante. Materiales y Métodos lo declara ahora en dos oraciones, como la operacionalización
de rutina que es. Queda un solo pendiente operativo: publicar en el repositorio la tabla de
correspondencia entre cada nombre de programa y su área, que es lo que vuelve verificable la
clasificación y desactiva por completo cualquier objeción sobre ella.

**5. Manuscrito anónimo.** El cuerpo del artículo se redacta sin datos de autoría. Esta carta,
en cambio, sí los lleva: no forma parte del material que ve el árbitro.

**6. Referencias verificadas contra fuente primaria** (ambas correctas tal como están en el
manuscrito base):

> Coca Carasila, A. M. (2011). La demanda. Una perspectiva de marketing: reflexiones
> conceptuales y aplicaciones. *Perspectivas*, (28), 171–191.
> *Verificada:* SciELO Bolivia y sitio de la revista (Universidad Católica Boliviana), núm. 28,
> julio–diciembre de 2011, ISSN 1994-3733. Semantic Scholar la indexa con el año 2007 y el
> nombre del autor alterado; es un error de esa base, no de la referencia.

> Pallán, C. y Marúm, E. (1997). Demanda de posgrado y competitividad del personal académico de
> la educación superior en México. *Revista de la Educación Superior*, *26*(102), 1–10.
> *Verificada:* índice del número 102 en el sitio de publicaciones de la ANUIES, vol. 26,
> abril–junio de 1997.
