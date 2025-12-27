param (
    [string]$Version = ""
)

$ErrorActionPreference = "Stop"
$installDir = "$env:LOCALAPPDATA\Programs\Selfbest"
$tempZip = "$env:TEMP\selfbest.zip"

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

# Decide download URL
if ($Version -eq "") {
    Write-Host "Installing latest PRODUCTION release..."
    $url = "https://github.com/kha-javed-tft/Selfbest_user_cli/releases/latest/download/selfbest-windows-$arch.zip"
    $exeName = "selfbest.exe"
} else {
    Write-Host "Installing version $Version ..."
    $url = "https://github.com/kha-javed-tft/Selfbest_user_cli/releases/download/$Version/selfbest-windows-$arch.zip"

    if ($Version -like "staging-*") {
        $installDir = "$env:LOCALAPPDATA\Programs\Selfbest-Staging"
        $exeName = "selfbest-staging.exe"
    } else {
        $exeName = "selfbest.exe"
    }
}

Write-Host "Downloading from:"
Write-Host $url

New-Item -ItemType Directory -Force -Path $installDir | Out-Null
Invoke-WebRequest -Uri $url -OutFile $tempZip

Expand-Archive -Force $tempZip $installDir
Remove-Item $tempZip

$exe = Get-ChildItem $installDir -Filter "selfbest-windows-*.exe" | Select-Object -First 1
if (-not $exe) {
    Write-Error "Binary not found"
    exit 1
}

Move-Item -Force $exe.FullName (Join-Path $installDir $exeName)

# Add to PATH
$path = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($path -notlike "*$installDir*") {
    [Environment]::SetEnvironmentVariable("PATH", "$path;$installDir", "User")
}

Write-Host ""
Write-Host "✅ Installation complete"
Write-Host "Restart PowerShell"
