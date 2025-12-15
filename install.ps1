$ErrorActionPreference = "Stop"

$installDir = "$env:LOCALAPPDATA\Programs\Selfbest"
$exePath = "$installDir\selfbest.exe"

$arch = if ([Environment]::Is64BitOperatingSystem) {
    if ($env:PROCESSOR_ARCHITECTURE -like "*ARM*") { "arm64" } else { "amd64" }
} else {
    Write-Error "Unsupported architecture"
}

$url = "https://github.com/tiwari-mani-tft/Selfbest-CLI-Release/releases/latest/download/selfbest-windows-$arch.exe"

Write-Host "⬇️ Downloading SelfBest CLI ($arch)..."
New-Item -ItemType Directory -Force -Path $installDir | Out-Null
Invoke-WebRequest $url -OutFile $exePath

Write-Host "🛠 Installing..."

# Add to PATH if missing
$path = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($path -notlike "*$installDir*") {
    [Environment]::SetEnvironmentVariable(
        "PATH",
        "$path;$installDir",
        "User"
    )
    Write-Host "✅ Added to PATH"
}

Write-Host "🎉 Installation complete!"
Write-Host "👉 Restart PowerShell, then run: selfbest version"
