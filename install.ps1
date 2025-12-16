# Stop execution on any error
$ErrorActionPreference = "Stop"

# Install paths
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

# Download URL
$url = "https://github.com/tiwari-mani-tft/Selfbest-CLI-Release/releases/latest/download/selfbest-windows-$arch.zip"

Write-Host "Downloading Selfbest CLI ($arch)..."

# Create install directory
New-Item -ItemType Directory -Force -Path $installDir | Out-Null

# Download zip
Invoke-WebRequest -Uri $url -OutFile $tempZip

Write-Host "Extracting..."
Expand-Archive -Force $tempZip $installDir
Remove-Item $tempZip

# Find extracted exe
$extractedExe = Get-ChildItem $installDir -Filter "selfbest-windows-*.exe" | Select-Object -First 1

if (-not $extractedExe) {
    Write-Error "Selfbest binary not found after extraction"
    exit 1
}

# Rename to selfbest.exe
$finalExe = Join-Path $installDir "selfbest.exe"
Move-Item -Force $extractedExe.FullName $finalExe

Write-Host "Installed selfbest"

# Add to PATH if missing
$path = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($path -notlike "*$installDir*") {
    [Environment]::SetEnvironmentVariable(
        "PATH",
        "$path;$installDir",
        "User"
    )
    Write-Host "Added to PATH"
}

Write-Host ""
Write-Host "Installation complete"
Write-Host "Restart PowerShell, then run:"
selfbest version
