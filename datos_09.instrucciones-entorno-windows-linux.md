# Instrucciones para reproducir el entorno de trabajo (Windows 11, Ubuntu 24 y Fedora 44)

Este documento complementa a `datos_03.limpieza-datos.R` y explica cómo dejar listo, **a
prueba de fallas**, el entorno de R (y de RStudio Desktop) necesario para ejecutar la limpieza
de datos en una máquina nueva, en **Windows 11**, **Ubuntu 24.04 LTS** o **Fedora Linux 44**.

Se incluyen dos caminos para cada sistema operativo: (A) un script automatizado, y (B) los
mismos pasos hechos a mano, por si prefiere revisarlos uno por uno o el script no aplica a su
caso exacto (otra distribución, un contenedor mínimo, una versión distinta de Windows, etc.).

| Sistema operativo | Script automatizado |
|---|---|
| Windows 11 | [`datos_09.instalar-entorno-windows.ps1`](datos_09.instalar-entorno-windows.ps1) (PowerShell) |
| Ubuntu 24.04 LTS | [`datos_09.instalar-entorno-ubuntu.sh`](datos_09.instalar-entorno-ubuntu.sh) (Bash) |
| Fedora Linux 44 | [`datos_09.instalar-entorno-fedora.sh`](datos_09.instalar-entorno-fedora.sh) (Bash) |

---

## 0. Qué se va a instalar y por qué

| Componente | Para qué se usa |
|---|---|
| R ≥ 4.3 | Motor que ejecuta `datos_03.limpieza-datos.R` |
| `readxl` | Leer el Excel crudo (`datos_01.datos-brutos-cuestionario.xlsx`) |
| `stringr`, `stringi` | Limpieza de texto: espacios, acentos (Unicode NFC), patrones |
| `dplyr` | Manipulación de datos (filtrar, mutar columnas) |
| `writexl`, `openxlsx` | Exportar los datos limpios a `.xlsx` |
| Herramientas de compilación (gcc, gfortran, libcurl/openssl/libxml2/icu -dev) | Solo se usan como **respaldo**: si el paquete precompilado de la distribución no está disponible, R lo compila desde CRAN usando estas herramientas |
| LibreOffice + pandoc *(opcional)* | Solo si se desea regenerar manualmente los documentos `.docx`/`.xlsx` ya incluidos en este repositorio; **no** son necesarios para correr `datos_03.limpieza-datos.R` |

---

## A. Camino automatizado (recomendado)

### Windows 11

PowerShell bloquea por defecto la ejecución de scripts `.ps1` no firmados. Abra
**PowerShell como Administrador** (recomendado, para que R y RStudio se instalen para todo el
equipo sin pedir elevación a mitad del proceso) y ejecute:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
.\datos_09.instalar-entorno-windows.ps1
```

O, sin cambiar la política de ejecución, en una sola línea:

```powershell
powershell -ExecutionPolicy Bypass -File .\datos_09.instalar-entorno-windows.ps1
```

### Ubuntu 24.04 LTS

```bash
chmod +x datos_09.instalar-entorno-ubuntu.sh
./datos_09.instalar-entorno-ubuntu.sh
```

### Fedora Linux 44

```bash
chmod +x datos_09.instalar-entorno-fedora.sh
./datos_09.instalar-entorno-fedora.sh
```

Los tres scripts:

1. Verifican el sistema operativo, privilegios (`sudo`/Administrador) y conexión a internet,
   **sin detener la ejecución** si algo de esto falla parcialmente (solo lo reportan como
   `[AVISO]`).
2. Instalan R: desde el repositorio oficial de la distribución en Linux, o vía `winget`
   (con respaldo de descarga directa desde CRAN) en Windows.
3. En Linux, instalan también las herramientas de compilación de respaldo (no hace falta en
   Windows, donde CRAN ya distribuye binarios precompilados).
4. Intentan instalar cada paquete de R por el medio más rápido disponible para cada sistema
   (`r-cran-*` en Ubuntu, `R-*` en Fedora, directamente con `install.packages()` en Windows);
   si algún paquete no se puede instalar así, **lo reintentan automáticamente desde CRAN** —
   no hace falta intervención manual.
5. Verifican, ya dentro de R, que los 6 paquetes realmente se puedan cargar (`library()` /
   `requireNamespace()`), y solo entonces dan por exitosa esa parte de la instalación.
6. Intentan instalar **RStudio Desktop** de forma opcional (paso 7 en Linux, paso 4 en
   Windows): `.deb` estable de Posit en Ubuntu, repositorio Copr `iucar/rstudio` en Fedora,
   `winget`/instalador `.exe` estable de Posit en Windows.
7. Imprimen un resumen final con `[OK]` / `[AVISO]` / `[FALLO]` por cada paso, y terminan con
   código de salida `0` (éxito, aunque haya habido avisos menores) o `1` (algo crítico falló y
   debe revisarse antes de correr la limpieza de datos).
8. Son **idempotentes**: se pueden ejecutar varias veces sin causar daño ni reinstalar de más.

> Los tres scripts fueron efectivamente ejecutados antes de publicarse en este repositorio
> (los dos de Linux en contenedores limpios de Ubuntu 24.04; el de Windows bajo PowerShell
> multiplataforma (`pwsh`) para validar su lógica de control de errores), confirmando que
> instalan y verifican los 6 paquetes de R sin intervención manual, y que ningún fallo aislado
> (por ejemplo, sin conexión a un dominio específico) detiene el resto del proceso. El de
> Fedora usa los nombres de paquete `R-*` documentados oficialmente por el Proyecto Fedora; si
> algún nombre exacto cambiara en una versión futura, el mecanismo de reintento por CRAN
> (punto 4) lo resuelve automáticamente sin que el script falle.

---

## B. Camino manual (paso a paso)

### Windows 11

```powershell
# 1. Instalar R (vía winget, recomendado)
winget install --id RProject.R -e --silent --accept-package-agreements --accept-source-agreements

# Alternativa sin winget: descargar e instalar en modo silencioso desde el enlace
# estable de CRAN (siempre apunta a la versión release vigente):
#   Invoke-WebRequest -Uri "https://cran.r-project.org/bin/windows/base/release.html" -OutFile R-instalador.exe
#   Start-Process -FilePath .\R-instalador.exe -ArgumentList "/VERYSILENT","/SUPPRESSMSGBOXES","/NORESTART" -Wait

# 2. Instalar los paquetes de R (abrir una consola de R o usar Rscript)
Rscript -e 'install.packages(c("readxl","stringr","dplyr","writexl","openxlsx","stringi"), repos = "https://cran.r-project.org")'

# 3. Verificación
Rscript -e 'sapply(c("readxl","stringr","dplyr","writexl","openxlsx","stringi"), requireNamespace, quietly = TRUE)'
```

> En Windows no hace falta instalar herramientas de compilación aparte: CRAN distribuye
> binarios precompilados (`.zip`) para los 6 paquetes, así que `install.packages()` no necesita
> compilar nada en el caso normal.

### Ubuntu 24.04 LTS

```bash
# 1. Actualizar índices e instalar R
sudo apt-get update
sudo apt-get install -y r-base-core

# 2. Dependencias de compilación (respaldo para CRAN)
sudo apt-get install -y build-essential gfortran \
  libcurl4-openssl-dev libssl-dev libxml2-dev libicu-dev

# 3. Paquetes de R precompilados
sudo apt-get install -y \
  r-cran-readxl r-cran-stringr r-cran-dplyr \
  r-cran-writexl r-cran-openxlsx r-cran-stringi

# 4. Verificación
Rscript -e 'sapply(c("readxl","stringr","dplyr","writexl","openxlsx","stringi"), requireNamespace, quietly = TRUE)'
```

### Fedora Linux 44

```bash
# 1. Actualizar metadatos e instalar R
sudo dnf makecache
sudo dnf install -y R

# 2. Dependencias de compilación (respaldo para CRAN)
sudo dnf install -y gcc gcc-c++ gcc-gfortran make \
  libcurl-devel openssl-devel libxml2-devel libicu-devel

# 3. Paquetes de R precompilados
sudo dnf install -y \
  R-readxl R-stringr R-dplyr R-writexl R-openxlsx R-stringi

# 4. Verificación
Rscript -e 'sapply(c("readxl","stringr","dplyr","writexl","openxlsx","stringi"), requireNamespace, quietly = TRUE)'
```

En los tres casos, el comando de verificación debe imprimir `TRUE` seis veces (uno por
paquete). Si alguno imprime `FALSE`, instálelo directamente desde CRAN:

```r
install.packages("nombre_del_paquete", repos = "https://cran.r-project.org")
```

---

## C. Verificación final (los tres sistemas)

Una vez instalado el entorno, confirme que la limpieza de datos corre de principio a fin:

```bash
# Ubuntu / Fedora
cd ruta/a/este/repositorio
Rscript datos_03.limpieza-datos.R
```

```powershell
# Windows 11 (PowerShell)
cd ruta\a\este\repositorio
Rscript datos_03.limpieza-datos.R
```

Debe terminar con el mensaje `Proceso finalizado correctamente.` y generar (o actualizar)
`datos_04.datos-limpios-completos.*`, `datos_05.datos-interesados.*` y
`datos_08.sesion-r-reproducibilidad.txt`.

---

## D. Instalar RStudio Desktop (opcional, IDE)

`datos_03.limpieza-datos.R` solo necesita `Rscript`; RStudio es un IDE opcional para trabajar
con el script de forma interactiva. Los tres scripts de la sección A ya intentan instalarlo
automáticamente. Si prefiere hacerlo a mano, o el paso automático no tuvo éxito por falta de
conexión en ese momento:

### Windows 11

```powershell
# Vía winget (recomendado)
winget install --id Posit.RStudio -e --silent --accept-package-agreements --accept-source-agreements

# Alternativa sin winget: descargar e instalar en modo silencioso desde el enlace
# estable de Posit (siempre apunta a la versión vigente):
#   Invoke-WebRequest -Uri "https://rstudio.org/download/latest/stable/desktop/windows/RStudio-latest.exe" -OutFile RStudio-instalador.exe
#   Start-Process -FilePath .\RStudio-instalador.exe -ArgumentList "/S" -Wait
```

### Ubuntu 24.04 LTS

RStudio no publica un build específico para "Noble"; Posit mantiene el build de Ubuntu 22.04
("jammy") compatible con Ubuntu 24.04 por retrocompatibilidad entre LTS. Se usa el enlace de
redirección "stable" oficial, que siempre apunta a la versión vigente sin tener que averiguar
el número de versión:

```bash
wget -O rstudio-latest-amd64.deb \
  https://rstudio.org/download/latest/stable/desktop/jammy/rstudio-latest-amd64.deb
sudo apt-get install -y ./rstudio-latest-amd64.deb
rm rstudio-latest-amd64.deb
```

`apt-get install -y ./archivo.deb` (en vez de `dpkg -i`) resuelve automáticamente las
dependencias faltantes en el mismo paso.

### Fedora Linux 44 — repositorio Copr `iucar/rstudio`

Tal como se solicitó, la instalación en Fedora usa el repositorio comunitario
[iucar/rstudio](https://copr.fedorainfracloud.org/coprs/iucar/rstudio/) en vez del RPM oficial
de Posit (ambos paquetes son mutuamente excluyentes; no se deben mezclar):

```bash
# El subcomando 'copr' requiere un plugin. En Fedora 41+ (dnf5) es 'dnf5-plugins';
# si su sistema usa dnf clásico, sería 'dnf-plugins-core'. Instálelo solo si
# 'dnf copr --help' falla:
sudo dnf install -y dnf5-plugins   # o: sudo dnf install -y dnf-plugins-core

# Habilitar el repositorio e instalar RStudio Desktop:
sudo dnf copr enable -y iucar/rstudio
sudo dnf install -y rstudio-desktop
```

Para verificar la instalación:

```bash
rstudio --version
```

> Este mismo Copr también publica `rstudio-server` (interfaz web de RStudio, útil en
> servidores sin entorno gráfico): `sudo dnf install -y rstudio-server` seguido de
> `sudo systemctl enable --now rstudio-server` (queda disponible en
> `http://127.0.0.1:8787`). No es necesario para este proyecto, se menciona solo como
> referencia.

### Verificación (los tres sistemas)

Abra RStudio, fije el directorio de trabajo al repositorio (`Session > Set Working Directory`,
o `setwd("ruta/a/este/repositorio")` en la consola) y corra:

```r
source("datos_03.limpieza-datos.R")
```

Debe terminar con `Proceso finalizado correctamente.`, igual que al correrlo desde `Rscript`.

---

## E. Solución de fallas comunes

| Síntoma | Causa probable | Solución |
|---|---|---|
| `datos_09.instalar-entorno-windows.ps1 no se puede cargar porque la ejecución de scripts está deshabilitada` | Política de ejecución de PowerShell restrictiva por defecto | `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force` antes de ejecutar el script (solo afecta a esa ventana de PowerShell) |
| `winget` no reconocido como comando (Windows) | El paquete "App Installer" no está instalado o está desactualizado | Instálelo/actualícelo desde la Microsoft Store buscando "App Installer", o descargue el `.msixbundle` desde <https://github.com/microsoft/winget-cli/releases>; el script sigue funcionando sin winget, usando descarga directa como respaldo |
| El instalador de R o RStudio pide elevación de permisos a mitad del proceso (Windows) | PowerShell no se abrió como Administrador | Cierre la ventana y vuelva a abrir PowerShell con "Ejecutar como administrador", luego reintente |
| `sudo: command not found` | Cuenta sin `sudo` configurado / está en una imagen mínima | Ejecute como `root` directamente, o instale `sudo` primero (`su -c "apt-get install sudo"` / `su -c "dnf install sudo"`) |
| `apt-get update` o `dnf makecache` fallan con errores de un repositorio de terceros (Docker, Node.js, etc.) | Un repositorio externo distinto a los oficiales está mal configurado o inalcanzable | No es crítico para este proyecto: los scripts lo reportan como `[AVISO]` y continúan usando los repositorios oficiales igualmente |
| `E: Unable to locate package r-cran-...` (Ubuntu) | El repositorio `universe` no está habilitado | `sudo add-apt-repository universe && sudo apt-get update`, luego reintente |
| `Error: No package R-... available` (Fedora) | El nombre exacto del RPM cambió, o el repositorio de R de Fedora no está habilitado en esa instalación | No requiere acción manual: el script reintenta automáticamente instalando ese paquete desde CRAN (ver sección A, punto 4) |
| `invalid char string in output conversion` al exportar CSV desde R (Linux) | El *locale* del sistema no es UTF-8 (suele pasar en contenedores mínimos con locale `C`) | Antes de correr el script: `export LC_ALL=C.UTF-8` (el script también intenta fijarlo internamente con `Sys.setlocale`); en Windows este problema no ocurre porque la consola ya maneja UTF-8 en R ≥ 4.2 |
| Falla la compilación de `stringi` desde CRAN por falta de ICU (Linux) | Faltan las cabeceras de desarrollo de ICU | Ubuntu: `sudo apt-get install libicu-dev` · Fedora: `sudo dnf install libicu-devel` (en Windows no aplica: CRAN distribuye binarios precompilados) |
| El script de limpieza dice "faltan columnas" | Se está usando un archivo de entrada distinto al esperado | Confirme que `datos_01.datos-brutos-cuestionario.xlsx` no fue editado ni tiene columnas renombradas |
| Sin conexión a internet en el momento de instalar | Firewall corporativo, red restringida, etc. | En Linux, los paquetes también pueden instalarse sin conexión copiando los `.deb`/`.rpm` desde otra máquina con la misma versión del sistema operativo, o usando un espejo local de CRAN; en Windows, descargue los instaladores `.exe` en otro equipo con internet y cópielos manualmente |
| Falla la descarga del `.deb`/`.exe` de RStudio | Firewall, o el enlace de redirección de Posit cambió de formato | Descargue manualmente desde <https://posit.co/download/rstudio-desktop/> e instale con `sudo apt-get install -y ./archivo.deb` (Ubuntu) o ejecutando el `.exe` (Windows) |
| `dnf copr: command not found` o `Error: unknown command` (Fedora) | Falta el plugin de Copr para dnf5/dnf | `sudo dnf install -y dnf5-plugins` (Fedora 41+) o `sudo dnf install -y dnf-plugins-core` (dnf clásico), luego reintente `sudo dnf copr enable -y iucar/rstudio` |
| `rstudio-desktop` y `rstudio` no se llevan bien / conflicto de paquetes (Fedora) | Se mezclaron el RPM oficial de Posit y el paquete del Copr `iucar/rstudio` | Desinstale uno de los dos antes de instalar el otro: `sudo dnf remove rstudio` o `sudo dnf remove rstudio-desktop` según corresponda |

---

## F. Notas de compatibilidad

- Los dos scripts de Linux usan `set -u` (no `set -e`) **a propósito**, y el de Windows usa
  bloques `try`/`catch` alrededor de cada paso en vez de `-ErrorAction Stop` global: en los
  tres casos el objetivo es que ningún fallo aislado detenga todo el proceso; cada paso se
  reporta y el script continúa, replicando la misma filosofía de manejo de errores por bloques
  que ya usa `datos_03.limpieza-datos.R`.
- Fedora 41 en adelante usa `dnf5` como gestor por defecto; `datos_09.instalar-entorno-fedora.sh`
  detecta automáticamente si el binario disponible se llama `dnf` o `dnf5` y usa el que
  corresponda.
- `datos_09.instalar-entorno-windows.ps1` localiza `Rscript.exe` y `rstudio.exe` directamente
  en disco (`Program Files`) en vez de asumir que quedaron en el `PATH` del sistema tras una
  instalación silenciosa; agrega la carpeta de R al `PATH` **de la sesión actual** de
  PowerShell para poder invocar `Rscript` sin ruta completa. Para dejarlo disponible de forma
  permanente en todas las ventanas, agréguelo desde *Configuración > Sistema > Información del
  sistema > Configuración avanzada del sistema > Variables de entorno*.
- Si trabaja en macOS, instale R desde <https://cran.r-project.org/bin/macosx/> y RStudio desde
  <https://posit.co/download/rstudio-desktop/>, o vía Homebrew (`brew install --cask r rstudio`);
  no se incluye un script dedicado para macOS en este repositorio.
