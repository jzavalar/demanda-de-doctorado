<#
==============================================================================
datos_09.instalar-entorno-windows.ps1
Instalación a prueba de fallas del entorno de R (y RStudio Desktop) necesario
para ejecutar datos_03.limpieza-datos.R, en Windows 11.

Mismo diseño "a prueba de fallas" que los scripts de Ubuntu/Fedora:
  - Ningún paso detiene el script; cada uno se reporta [OK] / [AVISO] / [FALLO]
    y se continúa con el siguiente.
  - R y RStudio se intentan primero vía winget (Windows Package Manager,
    preinstalado en Windows 11); si winget no está disponible o falla, se
    reintenta automáticamente descargando el instalador oficial (CRAN para R,
    Posit para RStudio) e instalándolo en modo silencioso.
  - Verificación real final: se localiza Rscript.exe en disco y se confirma
    que los 6 paquetes de R se puedan cargar, antes de declarar éxito.
  - Idempotente: se puede ejecutar varias veces sin causar daño.

CÓMO EJECUTAR ESTE SCRIPT
--------------------------
PowerShell bloquea la ejecución de scripts .ps1 sin firmar por defecto
("Restricted"/"AllSigned" en muchos equipos). Esto ocurre ANTES de que
cualquier lógica interna del script pueda actuar, así que se resuelve desde
fuera, con una de estas dos opciones:

  Opción A (recomendada, una sola vez, solo para esta sesión de PowerShell):
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
    .\datos_09.instalar-entorno-windows.ps1

  Opción B (sin cambiar la política, en una sola línea):
    powershell -ExecutionPolicy Bypass -File .\datos_09.instalar-entorno-windows.ps1

Se recomienda abrir PowerShell como Administrador ("Ejecutar como
administrador") para que R y RStudio se instalen para todo el equipo sin
solicitudes de elevación a mitad del proceso; el script funciona igual sin
privilegios de administrador, pero lo reporta como [AVISO].
==============================================================================
#>

$TempDir = if ($env:TEMP) { $env:TEMP } elseif ($env:TMP) { $env:TMP } else { [System.IO.Path]::GetTempPath() }

$OK   = "[OK]"
$WARN = "[AVISO]"
$FAIL = "[FALLO]"
$Resumen = New-Object System.Collections.Generic.List[string]
$HuboFalloCritico = $false

function Log($m)  { Write-Host $m }
function Paso($m) { Write-Host "`n--- $m ---" }
function Registrar($etiqueta, $estado) { $Resumen.Add("$estado $etiqueta") }

# ------------------------------------------------------------------------------
# 0. Verificaciones previas (SO, privilegios, red)
# ------------------------------------------------------------------------------
Paso "0. Verificaciones previas"

try {
  $os = Get-CimInstance -ClassName Win32_OperatingSystem -ErrorAction Stop
  Log "Sistema detectado: $($os.Caption) (build $($os.BuildNumber))"
  if ($os.Caption -notmatch "Windows 11") {
    Log "$WARN Este script está pensado para Windows 11; se detectó '$($os.Caption)'. Puede continuar, pero winget podría no estar preinstalado en versiones anteriores de Windows."
  }
} catch {
  Log "$WARN No se pudo determinar la versión de Windows ($($_.Exception.Message)). Se continúa de todas formas."
}

$esAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if ($esAdmin) {
  Log "Ejecutando con privilegios de Administrador."
  Registrar "Privilegios de administrador" "OK"
} else {
  Log "$WARN No se detectaron privilegios de Administrador. Si algún paso de instalación falla más abajo, vuelva a ejecutar este script desde una consola abierta con 'Ejecutar como administrador'."
  Registrar "Privilegios de administrador" "AVISO"
}

try {
  $null = Invoke-WebRequest -Uri "https://cran.r-project.org" -Method Head -TimeoutSec 8 -UseBasicParsing -ErrorAction Stop
  Log "Conexión a CRAN (cran.r-project.org): OK"
  Registrar "Conexión a internet / CRAN" "OK"
} catch {
  Log "$WARN No se pudo alcanzar CRAN en este momento. Se reintentará cada paso que dependa de la red de todas formas."
  Registrar "Conexión a internet / CRAN" "AVISO"
}

# ------------------------------------------------------------------------------
# 1. Verificar winget (Windows Package Manager)
# ------------------------------------------------------------------------------
Paso "1. Verificando Windows Package Manager (winget)"
$tieneWinget = $null -ne (Get-Command winget -ErrorAction SilentlyContinue)
if ($tieneWinget) {
  try {
    $verWinget = winget --version
    Log "$OK winget disponible: $verWinget"
    Registrar "winget" "OK"
  } catch {
    Log "$WARN winget se detectó pero no respondió correctamente. Se usará descarga directa como respaldo."
    $tieneWinget = $false
    Registrar "winget" "AVISO"
  }
} else {
  Log "$WARN winget no está disponible. En Windows 11 normalmente viene preinstalado (paquete 'App Installer' de la Microsoft Store); si falta, instálelo/actualícelo buscando 'App Installer' en la Store, o descargue el paquete desde https://github.com/microsoft/winget-cli/releases. Este script usará descarga directa como respaldo para R y RStudio."
  Registrar "winget" "AVISO"
}

# ------------------------------------------------------------------------------
# 2. Instalar R
# ------------------------------------------------------------------------------
Paso "2. Instalando R"

function Buscar-Rscript {
  $candidatos = @()
  $candidatos += Get-ChildItem "$env:ProgramFiles\R\R-*\bin\x64\Rscript.exe" -ErrorAction SilentlyContinue
  $candidatos += Get-ChildItem "$env:ProgramFiles\R\R-*\bin\Rscript.exe" -ErrorAction SilentlyContinue
  $candidatos = $candidatos | Where-Object { $_ }
  if ($candidatos.Count -gt 0) {
    return ($candidatos | Sort-Object LastWriteTime -Descending | Select-Object -First 1).FullName
  }
  return $null
}

$rscriptPath = (Get-Command Rscript -ErrorAction SilentlyContinue).Source
if (-not $rscriptPath) { $rscriptPath = Buscar-Rscript }

if ($rscriptPath) {
  Log "$OK R ya está instalado: $rscriptPath"
  Registrar "R" "OK"
} else {
  $instalado = $false

  if ($tieneWinget) {
    Log "Instalando R vía winget (RProject.R)..."
    try {
      winget install --id RProject.R -e --silent --accept-package-agreements --accept-source-agreements | Out-Null
      $instalado = ($null -ne (Buscar-Rscript))
    } catch {
      Log "$WARN winget install RProject.R falló: $($_.Exception.Message). Se reintentará por descarga directa."
    }
  }

  if (-not $instalado) {
    Log "Descargando el instalador de R desde el enlace estable de CRAN (release.html, redirige siempre a la versión vigente)..."
    $rExe = Join-Path $TempDir "R-instalador.exe"
    $descargaOk = $false
    for ($i = 1; $i -le 3; $i++) {
      Log "Intento $i de 3..."
      try {
        Invoke-WebRequest -Uri "https://cran.r-project.org/bin/windows/base/release.html" -OutFile $rExe -TimeoutSec 120 -UseBasicParsing -ErrorAction Stop
        if ((Test-Path $rExe) -and (Get-Item $rExe).Length -gt 1MB) { $descargaOk = $true; break }
      } catch {
        Log "$WARN Intento $i fallido: $($_.Exception.Message)"
      }
      Start-Sleep -Seconds 3
    }

    if ($descargaOk) {
      Log "Instalando R en modo silencioso..."
      try {
        Start-Process -FilePath $rExe -ArgumentList "/VERYSILENT","/SUPPRESSMSGBOXES","/NORESTART","/SP-" -Wait -ErrorAction Stop
        $instalado = $true
      } catch {
        Log "$FAIL La instalación silenciosa de R falló: $($_.Exception.Message)"
      }
    } else {
      Log "$FAIL No se pudo descargar un instalador válido de R tras 3 intentos (revise su conexión a cran.r-project.org)."
    }
    Remove-Item $rExe -ErrorAction SilentlyContinue
  }

  $rscriptPath = Buscar-Rscript
  if ($rscriptPath) {
    Log "$OK R instalado correctamente: $rscriptPath"
    Registrar "R" "OK"
  } else {
    Log "$FAIL No se pudo confirmar la instalación de R. El resto del script no podrá continuar de forma útil."
    Registrar "R" "FALLO"
    $HuboFalloCritico = $true
  }
}

# R no siempre queda en el PATH del sistema tras una instalación silenciosa;
# se agrega el directorio de Rscript.exe al PATH de ESTA sesión para que el
# resto del script (y el usuario, en esta misma ventana) pueda invocar
# "Rscript" directamente sin ruta completa.
if ($rscriptPath) {
  $rBinDir = Split-Path $rscriptPath -Parent
  if ($env:Path -notlike "*$rBinDir*") {
    $env:Path = "$env:Path;$rBinDir"
    Log "Se agregó '$rBinDir' al PATH de esta sesión de PowerShell (no es permanente; para hacerlo permanente use Configuración > Variables de entorno, o vea la sección D de datos_09.instrucciones-entorno-windows-linux.md)."
  }
}

# ------------------------------------------------------------------------------
# 3. Paquetes de R (Windows ya trae binarios precompilados en CRAN; no hace
#    falta compilar como en Linux, por eso no hay paso de "dependencias de
#    compilación" aquí).
# ------------------------------------------------------------------------------
Paso "3. Instalando paquetes de R (readxl, stringr, dplyr, writexl, openxlsx, stringi)"

if ($rscriptPath) {
  $scriptVerificacion = @'
paquetes <- c("readxl", "stringr", "dplyr", "writexl", "openxlsx", "stringi")
resultado <- data.frame(paquete = paquetes, estado = NA_character_)
for (i in seq_along(paquetes)) {
  p <- paquetes[i]
  ok <- requireNamespace(p, quietly = TRUE)
  if (!ok) {
    message("Instalando '", p, "' desde CRAN...")
    intento <- tryCatch({
      install.packages(p, repos = "https://cran.r-project.org")
      requireNamespace(p, quietly = TRUE)
    }, error = function(e) FALSE, warning = function(w) FALSE)
    ok <- isTRUE(intento)
  }
  resultado$estado[i] <- if (ok) "OK" else "FALLO"
}
cat("\n--- Verificacion de paquetes de R ---\n")
for (i in seq_len(nrow(resultado))) cat(sprintf("[%s] %s\n", resultado$estado[i], resultado$paquete[i]))
if (any(resultado$estado == "FALLO")) quit(status = 1, save = "no") else quit(status = 0, save = "no")
'@
  $tmpR = Join-Path $TempDir "datos09_verificar_paquetes.R"
  Set-Content -Path $tmpR -Value $scriptVerificacion -Encoding UTF8

  & $rscriptPath --vanilla $tmpR
  $estadoPaquetes = $LASTEXITCODE
  Remove-Item $tmpR -ErrorAction SilentlyContinue

  if ($estadoPaquetes -eq 0) {
    Registrar "Paquetes de R (readxl, stringr, dplyr, writexl, openxlsx, stringi)" "OK"
  } else {
    Log "$FAIL Uno o más paquetes no se pudieron instalar. Revise su conexión a internet o instálelos manualmente con install.packages()."
    Registrar "Paquetes de R (readxl, stringr, dplyr, writexl, openxlsx, stringi)" "FALLO"
    $HuboFalloCritico = $true
  }
} else {
  Log "$FAIL R no está disponible; no se pueden instalar ni verificar los paquetes."
  Registrar "Paquetes de R" "FALLO"
  $HuboFalloCritico = $true
}

# ------------------------------------------------------------------------------
# 4. (Opcional) RStudio Desktop
# ------------------------------------------------------------------------------
Paso "4. (Opcional) Instalando RStudio Desktop"

function Buscar-RStudio {
  $candidatos = @()
  $candidatos += Get-ChildItem "$env:ProgramFiles\RStudio\rstudio.exe" -ErrorAction SilentlyContinue
  $candidatos += Get-ChildItem "$env:LOCALAPPDATA\Programs\RStudio\rstudio.exe" -ErrorAction SilentlyContinue
  $candidatos = $candidatos | Where-Object { $_ }
  if ($candidatos.Count -gt 0) { return $candidatos[0].FullName }
  return $null
}

$rstudioPath = Buscar-RStudio
if ($rstudioPath) {
  Log "$OK RStudio ya está instalado: $rstudioPath"
  Registrar "RStudio Desktop (opcional)" "OK"
} else {
  $instaladoRS = $false

  if ($tieneWinget) {
    Log "Instalando RStudio vía winget (Posit.RStudio)..."
    try {
      winget install --id Posit.RStudio -e --silent --accept-package-agreements --accept-source-agreements | Out-Null
      $instaladoRS = ($null -ne (Buscar-RStudio))
    } catch {
      Log "$WARN winget install Posit.RStudio falló: $($_.Exception.Message). Se reintentará por descarga directa."
    }
  }

  if (-not $instaladoRS) {
    Log "Descargando RStudio Desktop desde el enlace estable de Posit..."
    $rsExe = Join-Path $TempDir "RStudio-instalador.exe"
    $descargaOk = $false
    for ($i = 1; $i -le 3; $i++) {
      Log "Intento $i de 3..."
      try {
        Invoke-WebRequest -Uri "https://rstudio.org/download/latest/stable/desktop/windows/RStudio-latest.exe" -OutFile $rsExe -TimeoutSec 180 -UseBasicParsing -ErrorAction Stop
        if ((Test-Path $rsExe) -and (Get-Item $rsExe).Length -gt 1MB) { $descargaOk = $true; break }
      } catch {
        Log "$WARN Intento $i fallido: $($_.Exception.Message)"
      }
      Start-Sleep -Seconds 3
    }

    if ($descargaOk) {
      Log "Instalando RStudio en modo silencioso..."
      try {
        Start-Process -FilePath $rsExe -ArgumentList "/S" -Wait -ErrorAction Stop
      } catch {
        Log "$WARN La instalación silenciosa de RStudio falló: $($_.Exception.Message)"
      }
    } else {
      Log "$WARN No se pudo descargar un instalador válido de RStudio tras 3 intentos."
    }
    Remove-Item $rsExe -ErrorAction SilentlyContinue
  }

  $rstudioPath = Buscar-RStudio
  if ($rstudioPath) {
    Log "$OK RStudio instalado correctamente: $rstudioPath"
    Registrar "RStudio Desktop (opcional)" "OK"
  } else {
    Log "$WARN No se pudo confirmar la instalación de RStudio. Esto NO afecta la limpieza de datos, que solo requiere Rscript; puede instalarlo manualmente después (ver datos_09.instrucciones-entorno-windows-linux.md, sección D)."
    Registrar "RStudio Desktop (opcional)" "AVISO"
  }
}

# ------------------------------------------------------------------------------
# RESUMEN FINAL
# ------------------------------------------------------------------------------
Paso "RESUMEN"
foreach ($linea in $Resumen) { Log $linea }

Write-Host ""
if (-not $HuboFalloCritico) {
  Write-Host "Entorno listo. Para correr la limpieza de datos, desde esta misma ventana de PowerShell:"
  Write-Host "  cd ruta\a\este\repositorio"
  Write-Host "  Rscript datos_03.limpieza-datos.R"
  if ($rstudioPath) { Write-Host "Para abrir RStudio (si se instaló): & '$rstudioPath'" }
  exit 0
} else {
  Write-Host "Hubo al menos un fallo crítico (ver arriba). Revise los mensajes [FALLO] antes de ejecutar datos_03.limpieza-datos.R."
  exit 1
}
