# Cifras canónicas congeladas

**Corrida canónica:** 27 de julio de 2026, 20:01:41 (America/Mexico_City)
**Entorno:** R 4.5.3 (2026-03-11) · x86_64-redhat-linux-gnu · **Fedora Linux 43 (Workstation Edition)**
**Réplicas Monte Carlo:** 200 000 (RQ6, RQ7) · 50 000 (RQ8)
**Semilla:** 20260726 + desplazamiento por prueba (20260727 a 20260730)
**Origen:** `datos_22.reporte-cifras-canonicas.R`, sobre `datos_04`/`datos_05` regenerados
por `datos_03.limpieza-datos.R` en la misma sesión.

**Estado:** ✅ congeladas. Todo archivo del repositorio y toda cifra del manuscrito deben
coincidir con esta tabla. Cualquier valor distinto es obsoleto.

---

## 0. Validación cruzada por implementación independiente

Antes de congelar, cada cifra se contrastó contra un recálculo independiente en Python
(`scipy`/`numpy`), programado sin mirar el código de R y partiendo de los mismos CSV. Las
medidas deterministas coinciden dígito por dígito; los p-valores simulados coinciden dentro
del error de simulación de ambas implementaciones.

| Cantidad | R (canónica) | Python (independiente) | |
|---|---|---|---|
| IC 95 % Wilson del interés | [81.31, 93.15] | [81.31, 93.15] | ✅ |
| IC 95 % Clopper-Pearson | [81.13, 93.73] | [81.13, 93.73] | ✅ |
| Género × interés (χ² sin corrección) | 0.7228 | 0.7228 | ✅ |
| Género × interés (Fisher) | 0.7705 | 0.7705 | ✅ |
| Tendencia edad: β por año | −0.03727 | −0.03728 | ✅ |
| Tendencia edad: z / p | −1.4150 / 0.1571 | −1.4150 / 0.1571 | ✅ |
| Spearman ρ / p | −0.0467 / 0.6234 | −0.0467 / 0.6234 | ✅ |
| V de Cramér (RQ6a, RQ6b, RQ7, RQ8) | 0.2105 · 0.2403 · 0.4168 · 0.8900 | idénticos | ✅ |
| RQ6a p simulado | 0.2894 | 0.2884 ± 0.0029 | ✅ |
| RQ6b p simulado | 0.0788 | 0.0794 ± 0.0017 | ✅ |
| RQ7 p simulado | 0.0341 | 0.0353 ± 0.0011 | ✅ |
| Permanencia geográfica | 82/100 | 82/100 | ✅ |

Esto es más fuerte que una segunda corrida del mismo código: dos implementaciones distintas,
en dos lenguajes distintos, con dos algoritmos de simulación distintos, llegan al mismo
resultado. Vale la pena mencionarlo en la declaración de reproducibilidad.

---

## 1. Cifras para Resultados

### RQ1 — Interés declarado

| | Valor |
|---|---|
| Interés en cursar el doctorado | **88.5 %** (100 de 113) |
| IC 95 % Clopper-Pearson | **[81.1 %, 93.7 %]** ← recomendado |
| IC 95 % Wilson | [81.3 %, 93.2 %] |

### RQ2 — Línea de doctorado (base: 100 interesados)

| Línea | n | % |
|---|---|---|
| Manejo y Aprovechamiento del Paisaje Rural | 55 | **55.0** |
| Desarrollo del Paisaje Rural | 17 | 17.0 |
| Paisaje y Turismo Rural | 17 | 17.0 |
| Desarrollo rural | 6 | 6.0 |
| Desarrollo Regional | 2 | 2.0 |
| Energías | 1 | 1.0 |
| Sociología | 1 | 1.0 |
| Urbanismo y Relaciones de Poder | 1 | 1.0 |

Las tres primeras líneas —las que forman el núcleo temático del programa propuesto— suman
**89.0 %**. Es una cifra que conviene reportar: dice que el interés no está disperso.

### RQ3 — Perfil sociodemográfico (Tabla 1; base: 100 interesados)

| Variable | Categoría | n | % |
|---|---|---|---|
| Género | Femenino | 59 | 59.0 |
| | Masculino | 41 | 41.0 |
| Edad | 26 a 30 | 34 | 34.0 |
| | 31 a 35 | 23 | 23.0 |
| | 36 a 40 | 12 | 12.0 |
| | 51 a 55 | 8 | 8.0 |
| | 46 a 50 | 7 | 7.0 |
| | 21 a 25 | 6 | 6.0 |
| | 41 a 45 | 6 | 6.0 |
| | 56 a 60 | 4 | 4.0 |
| Área de la maestría | Social | 49 | 49.0 |
| | Agronómica | 28 | 28.0 |
| | Otras | 18 | 18.0 |
| | Economía | 3 | 3.0 |
| | Alimentos | 2 | 2.0 |
| Situación laboral | Solo estudia | 34 | 34.0 |
| | Docente | 21 | 21.0 |
| | Empleado | 19 | 19.0 |
| | Trabaja y estudia | 19 | 19.0 |
| | Negocio propio | 5 | 5.0 |
| | *Sin dato* | *2* | *2.0* |

Cifras derivadas útiles: los rangos de **26 a 35 años concentran el 57.0 %**; con actividad
laboral (docente, empleado, trabaja y estudia, negocio propio) el **64.0 %**.

### RQ4 — Motivación (base: 100 interesados)

| Motivación | n | % |
|---|---|---|
| Investigación | 53 | 53.0 |
| Docencia | 30 | 30.0 |
| Aplicación en campo | 16 | 16.0 |
| Otro | 1 | 1.0 |

Investigación y docencia suman **83.0 %**.

### RQ5 — Plazo de inicio (base: 100 interesados)

| Plazo | n | % |
|---|---|---|
| En 1 año | 55 | 55.0 |
| Indefinido | 18 | 18.0 |
| En 2 años | 17 | 17.0 |
| En 3 años | 9 | 9.0 |
| En 5 años | 1 | 1.0 |

En dos años o menos: **72.0 %**.

### RQ6 y RQ7 — Pruebas de asociación

| Cruce | n | Dim. | Esp. < 5 | χ² (gl) | p | V de Cramér | Semilla |
|---|---|---|---|---|---|---|---|
| RQ6a Situación laboral × plazo | 98 | 5×5 | 76.0 % | 17.372 (16) | **0.289** | 0.211 | 20260727 |
| RQ6b Situación laboral × motivación | 98 | 5×4 | 55.0 % | 16.978 (12) | **0.079** | 0.240 | 20260728 |
| RQ7 Área de maestría × línea | 100 | 5×8 | 87.5 % | 69.499 (28) | **0.034** | **0.417** | 20260729 |
| RQ8 Entidad estudios × residencia | 100 | 17×24 | 100.0 % | 1267.406 (368) | **< 0.001** | 0.890 | 20260730 |

RQ7 es la única asociación significativa. Los χ² se reportan como referencia descriptiva: el
p-valor no proviene de ellos, sino de la prueba exacta de Fisher simulada.

### RQ8 — Movilidad geográfica

| | Valor |
|---|---|
| Permanece en la misma entidad | **82.0 %** (82 de 100) |
| IC 95 % Clopper-Pearson | **[73.1 %, 89.0 %]** |
| IC 95 % Wilson | [73.3 %, 88.3 %] |
| Entidades de estudios | 17 |
| Entidades de residencia | 24 |

Concentración: **Sonora 19 %, Estado de México 12 %, Nuevo León 11 %, Tabasco 10 %**; las diez
entidades principales reúnen el **85 %** de quienes están interesados. Hay **un caso de
residencia en el extranjero** (Estados Unidos de América).

### Corrección de la afirmación sobre edad

| Prueba | Resultado |
|---|---|
| Regresión logística, tendencia lineal | β = **−0.0373** por año · OR por 5 años = **0.830** · z = −1.415 · **p = 0.157** |
| Correlación de Spearman | ρ = **−0.047** · **p = 0.623** |

Pendiente negativa y no significativa. La afirmación de la versión dictaminada —que el interés
aumenta con la edad— **no se sostiene**. Patrón observado: sube hasta los 40 años (75.0 % →
89.5 % → 95.8 % → 100 %) y después oscila sin dirección (85.7 %, 100 %, 72.7 %, 100 %, 0 %).

### Género × interés

χ² sin corrección **p = 0.723** (reproduce la cifra dictaminada) · con Yates p = 0.956 ·
Fisher exacto **p = 0.771** · V de Cramér 0.033. Los tres métodos coinciden: no hay asociación.
Se recomienda reportar Fisher, por coherencia con el resto del análisis.

---

## 2. Tres correcciones que la corrida hizo visibles

### 2.1 Es Fedora 43, no 44

`sessionInfo()` reporta **Fedora Linux 43 (Workstation Edition)**. El manuscrito debe declarar
esa versión. (Y `datos_18` sigue diciendo R 4.3.3; corregir a 4.5.3.)

### 2.2 `p = 0.0000` en RQ8 es un artefacto de formato, no un resultado

Con B = 50 000 réplicas, el p-valor mínimo que la prueba puede producir es 1/(B+1) = 2 × 10⁻⁵.
El valor obtenido está en ese piso: la simulación no encontró **ninguna** tabla tan extrema
como la observada. Imprimirlo como `0.0000` afirma un cero exacto que la prueba no puede
establecer.

**En el manuscrito debe ir como `p < 0.001`.** Es el uso estándar y es lo que el dato sostiene.
(De paso: el indicador de "decimales defendibles" del script falla en este caso, porque la
fórmula √(p(1−p)/B) tiende a cero cuando p toca el borde. Es una limitación de mi script, no
del resultado.)

### 2.3 La situación laboral no suma 100 %

Sobre base 100, las categorías suman **98 %**: hay 2 personas sin dato. Un árbitro suma la
columna y encuentra el faltante.

Dos salidas, ambas correctas, pero hay que elegir una y aplicarla en toda la tabla:

- **(a)** Base n = 98 para esa variable, con nota al pie: *"n = 98; dos personas no
  respondieron"*. Los porcentajes cambian ligeramente (34.7 %, 21.4 %, 19.4 %, 19.4 %, 5.1 %).
- **(b)** Base n = 100 con una fila explícita *"Sin dato — 2 (2.0 %)"*.

**Recomiendo (b)**: mantiene una base única para toda la Tabla 1, hace visible el dato faltante
en vez de esconderlo en una nota, y es coherente con el principio de limpieza del proyecto —el
`NA` significa algo y se muestra.

---

## 3. Sobre los decimales de los p-valores simulados

Conviene distinguir dos cosas que se confunden con facilidad.

**Reproducibilidad.** Con la semilla fija, `p = 0.2894` se reproduce byte a byte cuantas veces
se ejecute. En ese sentido, los tres decimales son exactos.

**Estabilidad ante otra semilla.** El error de simulación de RQ6a es de 0.001, así que con una
semilla distinta el valor caería en torno a 0.287–0.291. El tercer decimal no es una propiedad
del dato, sino de esa semilla.

Ambas cosas son ciertas y no se contradicen. La forma honesta de reportarlo en Métodos:

> Los p-valores de las pruebas exactas de Fisher se obtuvieron por simulación Monte Carlo con
> 200 000 réplicas (50 000 para la tabla de RQ8) y semilla fija, documentada en el repositorio,
> de modo que son exactamente reproducibles. El error de simulación asociado es de
> aproximadamente 0.001, por lo que las diferencias en el tercer decimal no deben interpretarse
> sustantivamente.

Con eso, los valores publicados quedan a la vez verificables y correctamente calificados —que
es exactamente lo que el argumento metodológico del artículo necesita.

---

## 4. Pendientes

| Paso | Estado |
|---|---|
| Corrida canónica en el entorno declarado | ✅ hecha |
| Validación cruzada por implementación independiente | ✅ hecha |
| Segunda corrida y verificación byte a byte | ⬜ pendiente |
| Aplicar parches A1, A2, B1, B2 a `datos_12` y regenerar figuras | ⬜ pendiente |
| Propagar estas cifras a `README.md`, `datos_16`, `datos_18`, `datos_15.figuras/README.md`, `pies-de-figura.md` | ⬜ pendiente |
| Decisión: Clopper-Pearson vs. Wilson | ⬜ pendiente |
| Decisión: cómo reportar el dato faltante de situación laboral | ⬜ pendiente |
