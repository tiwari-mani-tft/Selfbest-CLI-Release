$arch = (Get-CimInstance Win32_Processor).Architecture
switch ($arch) {
  9 { $ARCH="amd64" }  # x64
  12 { $ARCH="arm64" } # ARM64
  default { Write-Error "Unsupported architecture"; exit 1 }
}

$BIN = "selfbest-windows-$ARCH.exe"
$URL = "https://github.com/tiwari-mani-tft/Selfbest-CLI-Release/releases/latest/download/$BIN"

Invoke-WebRequest $URL -OutFile selfbest.exe
New-Item -ItemType Directory -Force -Path C:\selfbest | Out-Null
Move-Item selfbest.exe C:\selfbest\selfbest.exe
setx PATH "$env:PATH;C:\selfbest"

selfbest version
