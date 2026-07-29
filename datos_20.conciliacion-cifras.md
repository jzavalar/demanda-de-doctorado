# Conciliación de cifras entre la versión dictaminada y el reanálisis reproducible

**Artículo:** *Análisis de la demanda del Doctorado en Ciencias integrado a la Maestría
Profesionalizante en Paisaje y Turismo Rural*
**Revista:** RIDE — Revista Iberoamericana para la Investigación y el Desarrollo Educativo
**Dictamen de referencia:** 8 de agosto de 2025 — "publicable con modificaciones sustanciales"
**Versión dictaminada:** `2_manuscrito_version_1_20250526` (análisis en Minitab 21)
**Versión reanalizada:** repositorio `jzavalar/demanda-de-doctorado` (R, pipeline reproducible)

**Para qué sirve este documento.** No forma parte del manuscrito. Es el respaldo de la carta de
respuesta al editor: documenta, cifra por cifra, qué cambió entre la versión dictaminada y la
nueva, y por qué. Sin él, un árbitro que compare ambas versiones encontrará números distintos
sin explicación — que es el peor escenario posible para un artículo cuyo argumento central de
método es la trazabilidad.

**Cómo se verificó.** Todas las frecuencias y medidas de asociación de este documento se
recalcularon de forma independiente desde `datos_04.datos-limpios-completos.csv` y
`datos_05.datos-interesados.csv`, sin usar las tablas ya publicadas como fuente. Las cifras de la
versión dictaminada se tomaron del texto del PDF enviado.

---

## 1. Hallazgo principal: la causa dominante es un cambio de denominador

La versión dictaminada calculó **todos** los porcentajes sobre las 113 personas que respondieron
el cuestionario. El reanálisis calcula los porcentajes de las variables de demanda sobre las
**100 personas que declararon interés**, porque las 13 restantes no contestaron esas preguntas
(lógica de salto del cuestionario): estaban entrando al denominador sin poder entrar al
numerador.

Esto no es una corrección cosmética. Es la diferencia entre "el 49 % de los encuestados prefiere
la línea de Manejo y Aprovechamiento del Paisaje Rural" y "el 55 % de quienes están interesados
prefiere esa línea". La segunda es la afirmación que el dato sostiene.

### Tabla A — Cifras que cambian solo por el denominador

| Variable / categoría | Dictaminada (n = 113) | Reanálisis (n = 100) | Recuento | Causa |
|---|---|---|---|---|
| Línea: Manejo y Aprov. del Paisaje Rural | 49 % | **55.0 %** | 55 | denominador |
| Línea: Paisaje y Turismo Rural | 15 % | **17.0 %** | 17 | denominador |
| Línea: Desarrollo del Paisaje Rural | 15 % | **17.0 %** | 17 | denominador |
| Área de maestría: Social | 47 % | **49.0 %** | 49 | denominador |
| Área de maestría: Agronómica | 28 % | **28.0 %** | 28 | denominador |
| Área de maestría: Otras | 19 % | **18.0 %** | 18 | denominador |
| Área de maestría: Economía | 4 % | **3.0 %** | 3 | denominador |
| Área de maestría: Alimentos | 2 % | **2.0 %** | 2 | denominador |
| Situación laboral: solo estudia | 34 % | **34.0 %** | 34 | denominador |
| Situación laboral: docente | 21 % | **21.0 %** | 21 | denominador |
| Situación laboral: trabaja y estudia | 20 % | **19.0 %** | 19 | denominador |
| Situación laboral: empleado | 19 % | **19.0 %** | 19 | denominador |
| Situación laboral: negocio propio | 4 % | **5.0 %** | 5 | denominador |
| Motivación: investigación | 54 % | **53.0 %** | 53 | denominador |
| Motivación: docencia | 27 % | **30.0 %** | 30 | denominador |
| Motivación: aplicación en campo | 16 % | **16.0 %** | 16 | denominador |
| Plazo: en 1 año | 53 % | **55.0 %** | 55 | denominador |
| Plazo: en 2 años | 17 % | **17.0 %** | 17 | denominador |
| Plazo: en 3 años | 8 % | **9.0 %** | 9 | denominador |
| Plazo: en 5 años | 1 % | **1.0 %** | 1 | denominador |
| Plazo: indefinido / no especificó | 21 % | **18.0 %** | 18 | denominador |
| Género: femenino | 58 % | **59.0 %** | 59 | denominador |
| Género: masculino | 42 % | **41.0 %** | 41 | denominador |

Cada cifra de la columna "dictaminada" se reprodujo exactamente dividiendo el recuento entre
113. Esto confirma que el cambio tiene una única causa identificable, no una acumulación de
ajustes.

**Nota sobre género.** La variable se preguntó a todas las personas, no solo a las interesadas,
así que admite legítimamente los dos denominadores. La tabla de perfil sociodemográfico del
manuscrito nuevo la reporta sobre n = 100 para que todo el perfil use una base única y
comparable; sobre las 113 respuestas el reparto es 58.4 % / 41.6 %.

---

## 2. Cifras que no cambian

Conviene decirlas explícitamente en la carta: no todo se movió, y lo que sostiene la conclusión
central del artículo es lo que **no** se movió.

| Afirmación | Dictaminada | Reanálisis | Estado |
|---|---|---|---|
| Interés en cursar el doctorado | 88 % (88.5 % en Conclusiones) | **88.5 %** (100 de 113) | idéntico |
| Personas con actividad laboral | 64 % | **64.0 %** (n = 100) / 64.6 % (n = 113) | idéntico |
| Género × interés: independientes | p = 0.723 | **p = 0.7228** (χ² sin corrección) | reproducido |
| Línea de mayor interés | Manejo y Aprov. del Paisaje Rural | **la misma** | idéntico |
| Motivación dominante | investigación, luego docencia | **la misma** | idéntico |
| Plazo dominante | menos de un año | **el mismo** | idéntico |

La conclusión del artículo —que el programa tiene demanda— no depende de ninguna cifra que haya
cambiado.

---

## 3. Cambios de método (no de dato)

### Tabla B

| Elemento | Dictaminada | Reanálisis | Justificación |
|---|---|---|---|
| Software | Minitab 21 (propietario) | R (libre y de código abierto) | trazabilidad y repetibilidad por terceros |
| IC 95 % del interés | [81.13, 93.73] | [81.31, 93.15] | el intervalo dictaminado es **Clopper-Pearson exacto**; el nuevo es **Wilson**, preferible para proporciones altas con n moderado |
| Prueba de asociación | χ² clásico | Fisher exacto con simulación Monte Carlo | 55 % a 100 % de las celdas esperadas < 5 según el cruce; el χ² clásico no es válido en esas condiciones |
| Tamaño de efecto | no reportado | V de Cramér en todo cruce probado | el dictamen penalizó la coherencia objetivos-método-resultados |
| Naturaleza del muestreo | "probabilística" | **no probabilística** | responde a la observación del editor sobre representatividad |

**Decisión pendiente.** Los dos intervalos son defendibles. Si se prefiere no introducir una
diferencia adicional respecto de la versión dictaminada, se puede conservar Clopper-Pearson
—que además es el exacto— y declararlo. Recomiendo esa opción: reduce la superficie de cambio
sin costo metodológico.

---

## 4. Correcciones sustantivas (esto sí son errores)

Tres afirmaciones de la versión dictaminada no se sostienen con los datos. No son cambios de
denominador ni de método: son correcciones, y deben declararse como tales.

### 4.1 La tendencia por edad — corrección mayor

La versión dictaminada afirma, en Resultados y de nuevo en Discusión:

> "conforme aumenta el rango de edad también aumenta la tendencia por buscar estudiar un doctorado"

**El dato no lo sostiene, ni en dirección ni en significancia.** Proporción de personas
interesadas por rango de edad:

| Rango | n | % interesados |
|---|---|---|
| 21 a 25 | 8 | 75.0 % |
| 26 a 30 | 38 | 89.5 % |
| 31 a 35 | 24 | 95.8 % |
| 36 a 40 | 12 | 100.0 % |
| 41 a 45 | 7 | 85.7 % |
| 46 a 50 | 7 | 100.0 % |
| 51 a 55 | 11 | 72.7 % |
| 56 a 60 | 4 | 100.0 % |
| 61 o más | 2 | 0.0 % |

El patrón no es monótono: sube hasta los 40 años y luego oscila. La prueba de tendencia lineal
por regresión logística da **β = −0.186, OR = 0.830, p = 0.157** —pendiente negativa y no
significativa— y la correlación de Spearman da **ρ = −0.047, p = 0.623**, es decir, ausencia de
asociación.

**Redacción sustituta propuesta:** no se observó una tendencia significativa entre el rango de
edad y el interés declarado; las personas interesadas se concentran en los rangos de 26 a 35
años, que es también donde se concentra la muestra.

### 4.2 La V de Cramér igual a 1

La versión dictaminada afirma:

> "Basado en la medida de asociación de Cramer (𝑝 = 1) se muestra una alta asociación entre la
> intención de estudiar un doctorado y las temáticas que se abordarán en el plan de estudios"

Una V de Cramér de exactamente 1 indica asociación perfecta, lo cual solo ocurre si una variable
determina completamente a la otra —el artefacto que se produce al cruzar una variable consigo
misma. **Se retira.** En su lugar, el reanálisis reporta la matriz de V de Cramér entre las seis
variables de demanda, cuyo valor sustantivo es el cruce área de maestría × línea de interés
(RQ7): **V = 0.417**, efecto moderado-alto, con asociación estadísticamente significativa.

El hallazgo que la afirmación original quería sostener —que el interés es coherente con la
formación previa— **sí se sostiene**, pero con la prueba correcta.

### 4.3 Dos imprecisiones menores

| Afirmación dictaminada | Valor correcto | Nota |
|---|---|---|
| "El intervalo de edad con mayor porcentaje (30 %) fue 26 a 30 años" | **33.6 %** (38 de 113) o **34.0 %** (34 de 100) | el 30 % resulta de dividir el recuento de interesados (34) entre el total de respondientes (113): denominadores mezclados |
| "ocho estados concentran 75 %" | **79.0 %** (n = 100) / 78.8 % (n = 113) | el conjunto de entidades citado es correcto; el porcentaje estaba subestimado |

---

## 5. Divergencias internas del repositorio — y su resolución

Antes de reescribir hay que resolver que el mismo dato aparezca con dos valores según el
archivo. El diagnóstico es tranquilizador.

### Lo que es idéntico en todas las corridas

Recalculé de forma independiente las medidas deterministas. Coinciden con lo publicado hasta el
tercer decimal:

| Cruce | n | Dimensión | % celdas esperadas < 5 | V de Cramér |
|---|---|---|---|---|
| Situación laboral × plazo (RQ6a) | 98 | 5 × 5 | 76.0 % | **0.211** |
| Situación laboral × motivación (RQ6b) | 98 | 5 × 4 | 55.0 % | **0.240** |
| Área de maestría × línea (RQ7) | 100 | 5 × 8 | 87.5 % | **0.417** |
| Entidad estudios × residencia (RQ8) | 100 | 17 × 24 | 100.0 % | **0.890** |

También coinciden todas las frecuencias univariadas y la permanencia geográfica (82 de 100,
82.0 %).

### Lo que diverge, y por qué

**Solo los p-valores simulados.** Estimé cada uno por permutación independiente con 100 000
réplicas:

| Cruce | Estimación independiente (IC 95 %) | Valores publicados en el repositorio |
|---|---|---|
| RQ6a | **0.288** [0.286, 0.291] | 0.278 · 0.297 |
| RQ6b | **0.079** [0.078, 0.081] | 0.079 · 0.080 |
| RQ7 | **0.035** [0.034, 0.037] | 0.034 · 0.037 |

Los valores publicados son **ruido Monte Carlo alrededor del mismo valor verdadero**, no errores
de cálculo ni versiones distintas de los datos. Con 20 000 réplicas el error estándar de
simulación hace que el tercer decimal no sea estable: para RQ6a el margen es de ±0.006, lo que
explica holgadamente la distancia entre 0.278 y 0.297.

**Consecuencia metodológica, y es importante:** reportar tres decimales de un p-valor simulado
con 20 000 réplicas comunica una precisión que el procedimiento no tiene. Dos recomendaciones,
compatibles entre sí:

1. **Elevar el número de réplicas a 200 000.** El costo computacional es trivial y estabiliza el
   tercer decimal.
2. **Declarar el número de réplicas y la semilla junto a cada p-valor simulado.** Es lo que
   convierte una cifra irrepetible en una cifra auditable — y es exactamente el argumento del
   artículo.

### Corrida canónica: protocolo

Ninguno de los tres valores publicados debe darse por bueno. Hay que congelar una corrida y
propagarla. Que la ejecute usted, no yo: el punto de la declaración de reproducibilidad es que
las cifras publicadas provengan del entorno declarado.

- [ ] Ejecutar en **R 4.5.3 / RStudio 2026.06.0 Build 242 / Fedora 44** — el entorno que se
      declarará en el manuscrito. Hoy `datos_18` declara R 4.3.3, que es el del contenedor donde
      se probó el pipeline, no el suyo.
- [ ] Elevar las réplicas Monte Carlo a 200 000 en `datos_12.analisis-descriptivo.R`.
- [ ] Correr en orden: `datos_03` → `datos_12` → `datos_13` → `datos_19`.
- [ ] Correr una segunda vez y comparar byte a byte (`datos_10.verificar-reproducibilidad.R`).
- [ ] Guardar la salida de `sessionInfo()` como nueva `datos_08.sesion-r-reproducibilidad.txt`.
- [ ] Propagar los valores resultantes a: `README.md`, `datos_16`, `datos_18`,
      `datos_15.figuras/README.md` y `pies-de-figura.md`.
- [ ] Verificar que ningún archivo conserve un valor anterior (búsqueda de `0.037`, `0.297`,
      `0.079`, `0.278`, `0.034`, `0.080`).

---

## 6. Insumo para la carta de respuesta al editor

Borrador del párrafo que explica el cambio de cifras. Va en la carta, no en el artículo:

> En atención a las observaciones del dictamen, y con el propósito de hacer la investigación
> íntegramente trazable y repetible, el análisis se rehízo desde los datos brutos utilizando
> exclusivamente software libre y de código abierto. Los datos, los scripts de limpieza y
> análisis, y las figuras están disponibles en un repositorio público, de modo que cualquier
> lector puede reproducir cada cifra del artículo.
>
> Este reanálisis produjo tres tipos de cambio respecto de la versión dictaminada, que se
> detallan en el anexo de conciliación. Primero, los porcentajes de las variables de demanda se
> calculan ahora sobre las 100 personas que declararon interés y no sobre las 113 que
> respondieron el cuestionario, ya que las 13 restantes no contestaron esas preguntas por la
> lógica de salto del instrumento. Segundo, las pruebas de asociación se sustituyeron por la
> prueba exacta de Fisher con simulación Monte Carlo, dado que entre el 55 % y el 100 % de las
> frecuencias esperadas son menores que cinco, condición en la que la ji cuadrada clásica no es
> válida; se añade el tamaño de efecto. Tercero, se corrigen dos afirmaciones de la versión
> anterior que la nueva evidencia no sostiene: la tendencia creciente del interés con la edad,
> que no es estadísticamente significativa y cuya pendiente estimada es negativa, y una medida de
> asociación de Cramér igual a la unidad, que era un artefacto de cálculo.
>
> La conclusión central del estudio no se modifica: el 88.5 % de las personas consultadas declaró
> interés en el programa, y ninguna de las cifras que cambiaron sostiene esa conclusión.

---

## 7. Estado

| Paso | Estado |
|---|---|
| Conciliación de frecuencias univariadas | ✅ verificada de forma independiente |
| Conciliación de medidas de asociación deterministas | ✅ verificada de forma independiente |
| Identificación de correcciones sustantivas | ✅ tres identificadas y documentadas |
| Diagnóstico de divergencias internas | ✅ atribuidas a ruido Monte Carlo |
| **Corrida canónica en el entorno declarado** | ⬜ pendiente — bloquea la reescritura de Resultados |
| Propagación a los archivos del repositorio | ⬜ pendiente |
| Decisión sobre método de IC (Wilson vs. Clopper-Pearson) | ⬜ pendiente |
