# 2. Materiales y Métodos

> **Documento de trabajo.** Redacción de la sección para revisión del equipo, en el registro
> acordado en `datos_25.registro-estilo.md`. Todas las cifras provienen de la corrida canónica
> congelada en `datos_23.cifras-canonicas-congeladas.md`. El formato de entrega (Times New
> Roman 12, interlineado 1.5, encabezados centrados en negritas) se aplica al pasar el texto al
> documento de Word.
>
> **Extensión:** ~1 900 palabras, aproximadamente 4 cuartillas con la Tabla 1.

---

## 2.1 Diseño del estudio

Se realizó un estudio observacional, descriptivo y transversal, de enfoque cuantitativo, cuyo
objetivo fue estimar la demanda potencial de un Doctorado en Ciencias concatenado a la Maestría
Profesionalizante en Paisaje y Turismo Rural (MPPTR) del Colegio de Postgraduados, Campus
Córdoba. La información se obtuvo mediante un cuestionario autoadministrado en línea, dirigido a
estudiantes y egresados de posgrados con perfil de formación afín al del programa propuesto.

El muestreo fue **no probabilístico**, de tipo intencional y con autoselección de los
participantes. Conviene detenerse en esta decisión, porque condiciona todo lo que sigue.

Un muestreo probabilístico habría exigido un marco muestral: un registro identificable de la
población de posibles aspirantes, del cual extraer una muestra con probabilidades de selección
conocidas. Ese registro no existe. No hay padrón nacional de estudiantes y egresados de
posgrado disponible para consulta, ni criterio operativo que delimite a priori quiénes son
"aspirantes potenciales" a un programa que aún no se ofrece. Ante esa restricción, se optó por
la vía practicable: contactar a las coordinaciones de programas afines y solicitar la difusión
del cuestionario entre su población estudiantil y egresada.

El costo de esa decisión es preciso y se declara de entrada: **los resultados caracterizan a
quienes respondieron y no estiman un parámetro poblacional**. Quienes contestaron lo hicieron
por decisión propia, de modo que es razonable suponer que el interés declarado esté sobrerre-
presentado respecto de la población de referencia; quien no piensa cursar un doctorado tiene
menos incentivo para responder un cuestionario sobre doctorados. Los intervalos de confianza
que se reportan más adelante deben leerse, por lo tanto, como medida de precisión muestral dado
el tamaño obtenido, y no como margen de error extrapolable al conjunto de posibles aspirantes.

Ahora bien, esa limitación no vacía el estudio: acota lo que puede afirmarse. Con estos datos no
se pretende establecer cuántas personas se inscribirían al programa, sino documentar la
magnitud, el perfil, la orientación temática, la motivación y la disposición temporal del
interés entre quienes ya cursan o cursaron un posgrado afín. Para decidir el diseño curricular,
la modalidad de impartición y el calendario de apertura de un programa, esa es la información
pertinente; una estimación poblacional, si fuera posible obtenerla, no sustituiría a ninguna de
esas cinco descripciones.

## 2.2 Población y participantes

El punto de partida fue el listado de programas del Sistema Nacional de Posgrados (SNP) del
entonces CONAHCyT, hoy SECIHTI. De ese listado se consultaron 32 posgrados y se seleccionaron
**16 maestrías** con base en un único criterio, aplicado de forma explícita: la afinidad de su
perfil de formación con las áreas de conocimiento de la MPPTR —gestión del paisaje, turismo
rural, desarrollo rural y regional, conservación y manejo de recursos naturales, y ordenación
del territorio—. La selección buscó además cobertura territorial amplia, de modo que la
consulta no quedara circunscrita al área de influencia inmediata del Campus Córdoba.

Se obtuvieron **113 respuestas completas**. Quienes respondieron declararon haber cursado su
maestría en 17 entidades federativas y residir en 24, incluido un caso de residencia en el
extranjero. El listado completo de los programas consultados, con su institución y entidad, se
encuentra en el repositorio de datos del estudio (véase la sección 2.7); no se reproduce aquí
por extensión.

## 2.3 Instrumento

El cuestionario constó de diez reactivos, de opción múltiple con una alternativa de respuesta
libre en la mayoría de los casos. Indagó: 1) la línea temática de doctorado de mayor interés,
entre tres opciones y una abierta; 2) género; 3) edad, por rangos quinquenales; 4) entidad
federativa donde cursa o cursó la maestría; 5) entidad federativa de residencia actual;
6) nombre de la maestría; 7) institución de procedencia; 8) situación laboral; 9) motivación
principal para cursar el doctorado; y 10) plazo estimado para iniciarlo. El formulario en línea
incluyó, además, una pregunta filtro sobre el interés general en cursar un doctorado con la
orientación propuesta.

El área disciplinaria de procedencia se obtuvo del reactivo 6: los nombres de los programas,
capturados como texto libre, se agruparon según su campo de conocimiento predominante en cinco
áreas —social, agronómica, económico-administrativa, de alimentos y otras—. La tabla de
correspondencia entre cada nombre de programa y el área asignada forma parte de los materiales
disponibles en el repositorio.

La pregunta filtro determinó el denominador de la mayor parte de los resultados: quienes
declararon no tener interés no continuaron con los reactivos sobre línea temática, motivación y
plazo, por lógica de salto del formulario. Este detalle, menor en apariencia, se retoma en la
sección 2.5.

## 2.4 Procedimiento de recolección

El cuestionario se aplicó en línea, mediante formulario electrónico, del **4 de abril al 7 de
mayo de 2024**. Se solicitó a las coordinaciones de los 16 programas seleccionados que
distribuyeran el enlace entre estudiantes vigentes y egresados. La participación fue voluntaria
y las respuestas se recibieron sin datos de identificación personal: el instrumento no recabó
nombre, correo electrónico ni ningún otro identificador directo.

## 2.5 Procesamiento y limpieza de datos

La limpieza se realizó mediante un script automatizado y documentado, organizado en dos pasos,
bajo un criterio explícito: **estandarizar sin fusionar respuestas de significado distinto**.

En el primer paso se normalizó el texto de todas las columnas (normalización Unicode, recorte y
colapso de espacios) y se estandarizaron los nombres de entidad federativa mediante un catálogo
de equivalencias auditable, no por coincidencia difusa de patrones; cada equivalencia quedó
registrada con su justificación. El dato faltante se codificó como valor nulo únicamente cuando
la persona genuinamente no respondió o cuando la pregunta no le aplicaba por la lógica de salto.
Las respuestas libres que no correspondían a ninguna categoría predefinida se conservaron como
categoría "Otro", con el texto original preservado en una columna acompañante; se registraron
tres casos.

En el segundo paso se recodificaron las variables categóricas con reglas estrictas y se verificó
automáticamente que el número de registros no cambiara entre el archivo crudo y el archivo
limpio. Las 113 respuestas se conservaron íntegras. No se identificaron registros duplicados ni
valores faltantes no documentados.

**El denominador.** De las 113 personas que respondieron, 100 declararon interés en el programa.
Las preguntas sobre línea temática, motivación y plazo de inicio se formularon únicamente a esas
100, de modo que sus porcentajes se calculan sobre esa base y no sobre el total de
respondientes. La distinción no es trivial: emplear 113 como denominador incorporaría al cálculo
a trece personas que no pudieron contribuir al numerador, y subestimaría de forma sistemática
cada proporción. Las variables sociodemográficas se reportan también sobre las 100 personas
interesadas, para que el perfil descrito corresponda a un mismo conjunto en todas sus
dimensiones. Dos de ellas no respondieron la pregunta de situación laboral; ese dato faltante se
declara de forma explícita en la tabla de perfil y reduce a 98 el tamaño efectivo de los cruces
que involucran esa variable.

## 2.6 Plan y técnicas de análisis

El análisis se organizó alrededor de ocho preguntas de investigación (RQ1–RQ8), definidas y
argumentadas **antes** de programar cualquier procedimiento de cálculo. Esta precedencia importa
por una razón metodológica: en un conjunto de datos con nueve variables categóricas es posible
formar decenas de cruces, y explorarlos todos para reportar después los que resultaron
significativos produciría hallazgos espurios con alta probabilidad. Fijar las preguntas de
antemano restringe el análisis a las asociaciones que tenían justificación sustantiva previa.

Las técnicas empleadas y la razón de cada elección se resumen en la Tabla 1.

**Tabla 1.** Decisiones analíticas, su justificación y sus implicaciones para la lectura de los
resultados

| Decisión | Por qué | Qué implica al leer los resultados |
|---|---|---|
| Muestreo no probabilístico | No existe marco muestral de aspirantes potenciales a un programa aún no ofertado | Los resultados describen a quienes respondieron; no se generalizan a una población |
| Porcentajes sobre 100 personas interesadas | Trece respondientes no contestaron las preguntas de demanda, por lógica de salto | Cada proporción indica la preferencia *entre quienes están interesados*, no entre todos los consultados |
| Prueba exacta de Fisher con simulación Monte Carlo | Entre 55 % y 100 % de las frecuencias esperadas son menores que cinco, condición en que la ji cuadrada clásica no es válida | El valor *p* es válido con celdas escasas, pero depende de una semilla aleatoria, que por ello se declara |
| V de Cramér junto a cada valor *p* | Un valor *p* indica si una asociación puede atribuirse al azar; no indica su intensidad | Un cruce sin significancia estadística puede describirse de todos modos: se sabe si la asociación, de existir, sería débil o fuerte |
| Intervalo exacto de Clopper-Pearson | Los métodos aproximados pierden cobertura con proporciones cercanas a los extremos | El intervalo es conservador: la incertidumbre real no es mayor que la reportada |
| Semilla y número de réplicas declarados | Un valor *p* simulado varía entre corridas si no se fija la semilla | Cualquier lector puede reproducir exactamente las cifras publicadas |
| Análisis de correspondencias múltiples como panorama exploratorio | Permite observar la estructura conjunta de seis variables, imposible de apreciar cruce por cruce | Es una lectura de conjunto, no una prueba: las proximidades sugieren asociación, no la confirman |

*Fuente: Elaboración propia.*

Cuatro precisiones sobre lo anterior.

**Sobre la prueba de asociación.** La regla aplicada fue la de Cochran: cuando más del 20 % de
las frecuencias esperadas resulta menor que cinco, se sustituye la ji cuadrada por la prueba
exacta de Fisher. En tablas mayores que 2×2 el cálculo exacto es computacionalmente inviable, de
modo que el valor *p* se obtuvo por simulación Monte Carlo con 200 000 réplicas —50 000 para la
tabla de mayor tamaño, la de RQ8—. El procedimiento tiene un error de simulación cercano a
0.001; las diferencias en el tercer decimal, en consecuencia, no admiten interpretación
sustantiva.

**Sobre el tamaño de efecto.** Se reporta la V de Cramér en todo cruce sometido a prueba, con o
sin significancia estadística. Con muestras del tamaño de esta, una asociación real puede no
alcanzar el umbral convencional; informar únicamente el valor *p* obligaría a descartar esos
cruces sin poder decir nada más sobre ellos.

**Sobre la tendencia por edad.** Se examinó mediante regresión logística, tomando el interés
declarado como variable dependiente y el rango de edad como predictor ordinal, y se contrastó
con el coeficiente de correlación de Spearman. Se emplearon dos procedimientos con supuestos
distintos porque la conclusión, en este caso, contradice lo señalado en trabajos previos sobre
la misma población; la coincidencia entre ambos refuerza el resultado.

**Sobre el análisis de correspondencias múltiples.** Se aplicó a las seis variables de demanda,
sobre las 98 personas con dato completo, y se presenta al inicio de los resultados como
introducción visual de conjunto. Los dos primeros ejes explican en conjunto el 17.4 % de la
inercia total, proporción que se declara de forma explícita: es un panorama exploratorio, no
evidencia confirmatoria, y así debe leerse.

## 2.7 Transparencia, disponibilidad de datos y reproducibilidad

El análisis se realizó íntegramente con **software libre y de código abierto**: R versión 4.5.3
sobre Fedora Linux 43. La elección no fue incidental. Un análisis ejecutado con software
propietario solo puede ser verificado por quien disponga de una licencia de ese software; uno
ejecutado con herramientas libres puede verificarlo cualquier lector, sin costo ni permiso. Para
un estudio cuyos resultados fundamentan una decisión académica —la apertura de un programa
doctoral—, esa diferencia es sustantiva.

En consecuencia, se ponen a disposición pública: 1) los datos brutos del cuestionario; 2) el
catálogo de estandarización de entidades, con la justificación de cada equivalencia; 3) los
datos limpios en tres formatos; 4) el diccionario de datos; 5) los scripts de limpieza, análisis
y generación de figuras; 6) el registro del entorno de ejecución, con la versión de R y de cada
paquete empleado; y 7) los archivos de instalación del entorno para tres sistemas operativos.
Los materiales se distribuyen bajo licencia Creative Commons Atribución 4.0 Internacional.

Todas las cifras del artículo se generaron en una corrida única, con semilla fija, y se
verificaron por dos vías independientes: la reejecución del procedimiento completo, que produjo
un resultado idéntico byte a byte, y una reimplementación en un segundo lenguaje de
programación, con bibliotecas y algoritmo de simulación distintos, cuyos resultados coinciden
con los del primero dentro del error de simulación. La segunda verificación es la más exigente
de las dos: la primera comprueba que el procedimiento es determinista; la segunda, que las
cifras no dependen de la herramienta con que se obtuvieron.

---

## Notas para el equipo (no forman parte del manuscrito)

**1. Problema con el arbitraje ciego.** RIDE exige que el cuerpo del manuscrito no contenga
datos que identifiquen a los autores. La dirección del repositorio incluye el nombre de usuario
de uno de ellos, de modo que **no puede citarse literalmente en la versión enviada a
dictamen**. Tres salidas posibles: a) depositar una copia del repositorio en Zenodo o en un
servicio equivalente y citar el DOI, que es anónimo y además da cita permanente —es la opción
que recomiendo—; b) declarar que los materiales se ponen a disposición del comité editorial y
se publicarán al momento de la aceptación; o c) crear un espejo anónimo para el periodo de
dictamen. La sección 2.7 quedó redactada sin la dirección, a la espera de esa decisión.

**2. Dato por verificar.** El manuscrito dictaminado afirma que los 16 programas provienen de
17 estados. Los datos indican que *quienes respondieron* declararon haber cursado su maestría en
17 entidades, que no es lo mismo. Redacté la versión conservadora, que es la que los datos
sostienen. Si se dispone del listado de las entidades donde se ubican los 16 programas, puede
afirmarse lo primero; conviene confirmarlo antes del envío.

**3. Pendiente de confirmación.** La cifra de 32 posgrados consultados proviene del manuscrito
dictaminado y no del repositorio. Convendría publicar ese listado como archivo del repositorio,
tanto para sostener la afirmación como para liberar las dos cuartillas que hoy ocupa la tabla en
el manuscrito.

**4. Referencias pendientes de esta sección.** Faltan las citas de: el instrumento o modelo de
análisis de demanda en que se apoya el diseño (el manuscrito dictaminado cita a Pallán y Marúm,
1997, y a Coca, 2011); R Core Team para la versión de R; y los paquetes empleados. Están
compilados en `datos_17.referencias-bibliograficas.md` y se integran al armar la sección de
Referencias.

**5. Anonimato del manuscrito.** Esta sección quedó redactada sin datos que identifiquen a los
autores ni a la institución de adscripción. Falta revisar el resto del manuscrito con el mismo
criterio: nombres de autores, agradecimientos, dirección del repositorio, y las
autorreferencias que puedan revelar la autoría —en particular la cita a Baltazar-Bernal (2025),
que en el cuerpo del texto debe redactarse en tercera persona, como cualquier otra fuente, sin
la fórmula "en un trabajo previo del equipo".
