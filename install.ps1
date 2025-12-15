$ErrorActionPreference = "Stop"

# Detect architecture
$arch = (Get-CimInstance Win32_Processor).Architecture
switch ($arch) {
  9 { $ARCH = "amd64" }   # x64
  12 { $ARCH = "arm64" }  # ARM64
  default { Write-Error "Unsupported architecture"; exit 1 }
}

$BIN = "selfbest-windows-$ARCH.exe"
$URL = "https://github.com/tiwari-mani-tft/Selfbest-CLI-Release/releases/latest/download/$BIN"

Write-Host "Downloading $BIN..."

Invoke-WebRequest $URL -OutFile selfbest.exe

$InstallDir = "$env:USERPROFILE\selfbest"
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
Move-Item selfbest.exe "$InstallDir\selfbest.exe" -Force

# Add to PATH
$UserPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($UserPath -notlike "*$InstallDir*") {
  [Environment]::SetEnvironmentVariable(
    "PATH",
    "$UserPath;$InstallDir",
    "User"
  )
}

Write-Host "`nSelfbest installed successfully!"
Write-Host "Restart PowerShell and run: selfbest version"
