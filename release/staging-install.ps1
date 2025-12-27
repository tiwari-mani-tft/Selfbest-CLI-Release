# Stop execution on any error
$ErrorActionPreference = "Stop"

$installDir = "$env:LOCALAPPDATA\Programs\Selfbest-Staging"
$tempZip = "$env:TEMP\selfbest-staging.zip"

# Detect architecture
if ([Environment]::Is64BitOperatingSystem) {
    if ($env:PROCESSOR_ARCHITECTURE -like "*ARM*") {
        $arch = "arm64"
    } else {
        $arch = "amd64"
    }
} else {
    Write-Error "Unsupported architecture"
    exit 1
}

# 👇 staging-latest tag
$url = "https://github.com/kha-javed-tft/Selfbest_user_cli/releases/download/staging-latest/selfbest-windows-$arch.zip"

Write-Host "Downloading Selfbest CLI STAGING ($arch)..."

New-Item -ItemType Directory -Force -Path $installDir | Out-Null
Invoke-WebRequest -Uri $url -OutFile $tempZip

Write-Host "Extracting..."
Expand-Archive -Force $tempZip $installDir
Remove-Item $tempZip

$exe = Get-ChildItem $installDir -Filter "selfbest-windows-*.exe" | Select-Object -First 1
if (-not $exe) {
    Write-Error "Selfbest staging binary not found"
    exit 1
}

$finalExe = Join-Path $installDir "selfbest-staging.exe"
Move-Item -Force $exe.FullName $finalExe

# Add to PATH
$path = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($path -notlike "*$installDir*") {
    [Environment]::SetEnvironmentVariable("PATH", "$path;$installDir", "User")
}

Write-Host ""
Write-Host "✅ STAGING Installation complete"
Write-Host "Run: selfbest-staging version"
