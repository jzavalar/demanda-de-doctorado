### Datos y Scripts de Procesamiento para el Artículo *Demanda Potencial para un Doctorado en Ciencias en Paisaje y Rurismo Rural*

**Institución responsable:** Colegio de Postgraduados, Campus Córdoba  
**Responsable del proyecto de investigación:** Dra. Obdulia Baltazar Bernal  
**Contacto:*** [obduliabb@colpos.mx](mailto:obduliabb@colpos.mx)  
**Responsable del repositorio y sus productos:** Dr. Jesús Zavala Ruiz  
**Contacto:*** [jzr@xanum.uam.mx](mailto:jzr@xanum.uam.mx)  

**Periodo de levantamiento:** 4 de abril de 2024 – 7 de mayo de 2024  
**N total de respuestas:** 113 (100 con interés declarado en cursar el doctorado)  
**Licencia:** [CC BY 4.0](LICENSE.txt)  
**Última actualización de este repositorio:** 23 de julio de 2026  

> Este repositorio acompaña al artículo derivado de esta investigación y se publica para dar cumplimiento a la transparencia de datos, métodos y materiales solicitada por la revista de destino, y para que cualquier persona pueda **reproducir de principio a fin** el proceso de preparación de los datos, previo a su análisis y su posterior análisis.

---

#### 1. Contenido del repositorio

Todos los archivos de datos y de código siguen la nomenclatura `datos_NN.nombre-descriptivo.ext`,
numerados en el orden lógico del flujo de trabajo (00 = insumos de origen → 08 = trazabilidad
del entorno de ejecución). `README.md` y `LICENSE.txt` son la excepción intencional: se dejan
con esos nombres porque GitHub y la mayoría de los repositorios de datos los reconocen y
despliegan de forma especial en esa forma exacta.

| # | Archivo | Qué es | Formato |
|---|---|---|---|
| 00 | [`datos_00.instrumento-cuestionario.docx`](datos_00.instrumento-cuestionario.docx) | Instrumento de levantamiento de datos (cuestionario original) | Word |
| 00 | [`datos_00.instrumento-cuestionario.md`](datos_00.instrumento-cuestionario.md) | Transcripción en texto plano del instrumento, para lectura rápida en GitHub | Markdown |
| 01 | [`datos_01.datos-brutos-cuestionario.xlsx`](datos_01.datos-brutos-cuestionario.xlsx) | Respuestas crudas del formulario, **sin ninguna transformación** | Excel |
| 01 | [`datos_01.datos-brutos-cuestionario.csv`](datos_01.datos-brutos-cuestionario.csv) | Mismo contenido que el anterior, en texto plano UTF-8 | CSV |
| 02 | [`datos_02.catalogo-estandarizacion-entidades.csv`](datos_02.catalogo-estandarizacion-entidades.csv) | Tabla de equivalencias auditable para nombres de entidades federativas (acentos, espacios, casos ambiguos) usada por el script de limpieza | CSV |
| 03 | [`datos_03.limpieza-datos.R`](datos_03.limpieza-datos.R) | **Script de limpieza y estandarización**, comentado y automatizado en 3 pasos | R |
| 04 | [`datos_04.datos-limpios-completos.csv`](datos_04.datos-limpios-completos.csv) · [`.xlsx`](datos_04.datos-limpios-completos.xlsx) · [`.rds`](datos_04.datos-limpios-completos.rds) | Datos limpios, las 113 respuestas | CSV / Excel / R nativo |
| 05 | [`datos_05.datos-interesados.csv`](datos_05.datos-interesados.csv) · [`.rds`](datos_05.datos-interesados.rds) | Subconjunto de 04 filtrado a `interes_en_doctorado = "Sí"` (100 respuestas) | CSV / R nativo |
| 06 | [`datos_06.diccionario-datos.xlsx`](datos_06.diccionario-datos.xlsx) | **Diccionario de datos completo**: variables, codebook de recodificación, estadísticas descriptivas | Excel (5 hojas) |
| 07 | [`datos_07.reporte-validacion-limpieza.md`](datos_07.reporte-validacion-limpieza.md) | Reporte de auditoría del proceso de limpieza: hallazgos y su resolución | Markdown |
| 08 | [`datos_08.sesion-r-reproducibilidad.txt`](datos_08.sesion-r-reproducibilidad.txt) | Versión de R y de cada paquete usada para generar los archivos (se genera automáticamente al correr el script) | Texto plano |
| 09 | [`datos_09.instrucciones-entorno-windows-linux.md`](datos_09.instrucciones-entorno-windows-linux.md) | Instrucciones para reproducir el entorno de R **y de RStudio Desktop** en Windows 11, Ubuntu 24 y Fedora 44 (manual y automatizado, con solución de fallas) | Markdown |
| 09 | [`datos_09.instalar-entorno-windows.ps1`](datos_09.instalar-entorno-windows.ps1) | Script de instalación automatizada del entorno (R + RStudio vía winget, con respaldo de descarga directa), a prueba de fallas, para Windows 11 | PowerShell |
| 09 | [`datos_09.instalar-entorno-ubuntu.sh`](datos_09.instalar-entorno-ubuntu.sh) | Script de instalación automatizada del entorno (R + RStudio), a prueba de fallas, para Ubuntu 24.04 LTS | Bash |
| 09 | [`datos_09.instalar-entorno-fedora.sh`](datos_09.instalar-entorno-fedora.sh) | Script de instalación automatizada del entorno (R + RStudio vía Copr `iucar/rstudio`), a prueba de fallas, para Fedora Linux 44 | Bash |
| — | [`LICENSE.txt`](LICENSE.txt) | Licencia y forma de citar el conjunto de datos | Texto plano |

#### 2. El instrumento

El cuestionario ([`datos_00.instrumento-cuestionario.docx`](datos_00.instrumento-cuestionario.docx)) se aplicó en línea (Google Forms) y
consta de 10 preguntas: interés e línea de doctorado, género, edad por rangos, entidad de
estudios y de residencia, maestría e institución de origen, situación laboral, motivación y
plazo estimado para iniciar el doctorado. El detalle pregunta-por-pregunta y una nota sobre
una diferencia menor entre el documento y el formulario en línea están en la transcripción
Markdown ([`datos_00.instrumento-cuestionario.md`](datos_00.instrumento-cuestionario.md)).

#### 3. Proceso de limpieza de datos (2 pasos)

El script `datos_03.limpieza-datos.R` implementa el criterio acordado con el equipo de
investigación: **estandarizar sin perder significado ni riqueza de la información**.

**Paso 1 — Reglas de estandarización**
- Normalización de texto (Unicode NFC + recorte/colapso de espacios) en todas las columnas.  
- Estandarización de entidades federativas mediante un catálogo explícito y auditable
  (`datos_02.catalogo-estandarizacion-entidades.csv`), no por adivinación con expresiones
  regulares — cada equivalencia (p. ej. "Michoacan" → "Michoacán", "México" → "Estado de
  México") queda documentada con su justificación.  
- Manejo explícito del dato faltante: se usa `NA` únicamente cuando la persona genuinamente
  no respondió o la pregunta no le aplicaba (lógica de salto del cuestionario). Una respuesta
  libre que sí existe pero no encaja en ninguna categoría predefinida **nunca** se convierte en
  `NA`: se marca `"Otro"` y su texto original se conserva íntegro en una columna espejo
  `..._otro_texto`.  

**Paso 2 — Automatización y validación**
- Lectura y validación de estructura (columnas esperadas) con manejo de errores por bloque.  
- Recodificación de variables categóricas con reglas estrictas, una por una, para no fusionar
  respuestas con significados distintos (p. ej. "Indefinido" se mantiene separado de un dato
  faltante real; "Sector privado" ya no se agrupa con "Aplicación en campo").  
- Validación de integridad automática: el script se detiene si el número de filas cambia
  respecto al archivo crudo.  

**Paso 3 — Exportación en 3 formatos:** `.csv` (uso general), `.xlsx` (revisión manual /
coautores) y `.rds` (formato nativo de R, conserva los tipos de dato exactos).

El detalle completo de cada hallazgo de la auditoría y su resolución está en
[`datos_07.reporte-validacion-limpieza.md`](datos_07.reporte-validacion-limpieza.md).

#### 4. Hallazgos principales (resumen)

| Hallazgo | Resolución |
|---|---|
| "Michoacán" / "Michoacan" como categorías distintas | Unificadas vía catálogo |
| "México" ambiguo en estado de residencia | Resuelto como "Estado de México" (decisión documentada) |
| "Sector privado" fusionado con "Aplicación en campo" | Separado; ahora es `"Otro"` + texto original preservado |
| "Indefinido" fusionado con "No especifica" | "Indefinido" es ahora categoría propia |
| "No contesto" como texto literal | Convertido a `NA` real |
| Espacios en blanco en nombres de entidades | Corregidos y ahora documentados en el script |

Ningún hallazgo implicó pérdida de registros: las 113 respuestas se conservan íntegras en
todo el proceso (verificado automáticamente por el script).

#### 5. Diccionario de datos

`datos_06.diccionario-datos.xlsx` contiene 5 hojas:

1. **Portada** — presentación general y cómo usar el archivo.
2. **Variables** — catálogo de las 13 variables originales: tipo, pregunta de origen, valores
   posibles, notas de calidad.
3. **Codebook_Recodificacion** — mapeo valor crudo → valor limpio (versión inicial).
4. **Calidad_Datos** — hallazgos completos de la auditoría, con severidad y recomendación.
5. **Codebook_v3_2pasos** — mapeo valor crudo → valor final para las variables rediseñadas en
   el proceso de 2 pasos (situación laboral, motivación, tiempo de inicio, interés, entidad de
   residencia).
6. **Estadisticas_Descriptivas** — frecuencias y porcentajes por variable, listas para citar.

#### 6. Cómo reproducir el entorno y la limpieza de datos desde cero

##### 6.1 Preparar el entorno (nueva máquina, Windows 11, Ubuntu 24 o Fedora 44)

Para dejar instalado R y todos los paquetes necesarios de forma automatizada y a prueba de
fallas:

```powershell
# Windows 11 (PowerShell, idealmente como Administrador)
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
.\datos_09.instalar-entorno-windows.ps1
```

```bash
# Ubuntu 24.04 LTS
chmod +x datos_09.instalar-entorno-ubuntu.sh && ./datos_09.instalar-entorno-ubuntu.sh

# Fedora Linux 44
chmod +x datos_09.instalar-entorno-fedora.sh && ./datos_09.instalar-entorno-fedora.sh
```

Los tres scripts nunca detienen la instalación ante un fallo aislado: reportan cada paso como
`[OK]`, `[AVISO]` o `[FALLO]`, reintentan automáticamente vía CRAN cualquier paquete que no se
pueda instalar por el medio más rápido de cada sistema y verifican al final que R pueda cargar
los 6 paquetes antes de declarar éxito. También instalan **RStudio Desktop** de forma opcional:
en Windows, vía `winget` (con respaldo de descarga directa del instalador estable de Posit); en
Ubuntu, descargando el `.deb` estable de Posit; en Fedora, habilitando el repositorio Copr
comunitario [`iucar/rstudio`](https://copr.fedorainfracloud.org/coprs/iucar/rstudio/) e
instalando `rstudio-desktop`. Si ese paso no tiene éxito (p. ej. por falta de conexión en ese
momento), el script lo reporta como `[AVISO]` y continúa: RStudio no es necesario para correr
`datos_03.limpieza-datos.R`, que solo requiere `Rscript`. El detalle completo, la versión
manual paso a paso y una tabla de solución de fallas están en
[`datos_09.instrucciones-entorno-windows-linux.md`](datos_09.instrucciones-entorno-windows-linux.md).

##### 6.2 Ejecutar la limpieza de datos

```r
# 1. Clonar o descargar este repositorio completo en una sola carpeta

# 2. Abrir R o RStudio y fijar el directorio de trabajo a esa carpeta:
setwd("ruta/a/este/repositorio")

# 3. Ejecutar el script de limpieza:
source("datos_03.limpieza-datos.R")

# Alternativa desde terminal:
# Rscript datos_03.limpieza-datos.R
```

Requisitos: **R ≥ 4.3**. Los paquetes necesarios (`readxl`, `stringr`, `dplyr`, `writexl`,
`openxlsx`, `stringi`) se instalan automáticamente si faltan. El script:

- Lee `datos_01.datos-brutos-cuestionario.xlsx` y `datos_02.catalogo-estandarizacion-entidades.csv`.  
- Genera (o sobrescribe) `datos_04.datos-limpios-completos.*`, `datos_05.datos-interesados.*` y `datos_08.sesion-r-reproducibilidad.txt`.
- Se detiene con un mensaje explícito ante cualquier error (columnas faltantes, archivo corrupto, pérdida de registros), en vez de fallar en silencio.  
- Al terminar exitosamente imprime un reporte con conteos totales, valores `NA` por variable y las respuestas libres preservadas en las columnas `..._otro_texto`.  

Para verificar bajo qué versión exacta de R y de cada paquete se generaron los archivos aquí
publicados, ver `datos_08.sesion-r-reproducibilidad.txt` (se regenera cada vez que se corre
el script, con fecha y hora de ejecución).

#### 7. Privacidad

El conjunto de datos no contiene nombres, correos electrónicos ni identificadores directos de
las personas respondientes; solo variables demográficas agregadas por rango (edad) y categoría
(género, entidad, situación laboral). No se identificó riesgo de reidentificación relevante
para su publicación en acceso abierto.

#### 8. Licencia y forma de citar

Ver [`LICENSE.txt`](LICENSE.txt). Este material se distribuye bajo **CC BY 4.0**, en
concordancia con la política de acceso abierto de la revista de destino: [RIDE](https://www.ride.org.mx/).

#### 9. Historial de versiones

| Fecha | Cambio |
|---|---|
| 22-jul-2026 | Primera limpieza automatizada (script v1) y auditoría inicial de calidad de datos. |
| 22-jul-2026 | Rediseño en 2 pasos: catálogo de entidades auditable, manejo explícito de `NA` vs. respuesta libre, exportación en 3 formatos. |
| 23-jul-2026 | Empaquetado final para disposición pública: renombrado de archivos (`datos_NN.nombre-descriptivo.ext`), inclusión del instrumento, README consolidado y trazabilidad del entorno de ejecución (`datos_08`). |
| 23-jul-2026 | Instrucciones y scripts de instalación a prueba de fallas del entorno de R para Ubuntu 24.04 LTS y Fedora Linux 44 (`datos_09.*`), probados de extremo a extremo en un contenedor limpio de Ubuntu. |
| 23-jul-2026 | Se agregó la instalación opcional de RStudio Desktop a ambos scripts (`.deb` estable de Posit en Ubuntu; repositorio Copr `iucar/rstudio` en Fedora), con reintentos y sin detener el script si falla. |
| 23-jul-2026 | Se agregó `datos_09.instalar-entorno-windows.ps1` (instalación a prueba de fallas de R y RStudio en Windows 11 vía winget, con respaldo de descarga directa desde CRAN/Posit) y se completó `datos_09.instrucciones-entorno-windows-linux.md` con instrucciones para los tres sistemas operativos (Windows, Ubuntu, Fedora). |
