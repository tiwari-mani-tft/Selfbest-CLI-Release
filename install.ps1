# Stop execution on any error
$ErrorActionPreference = "Stop"

# Install paths
$installDir = "$env:LOCALAPPDATA\Programs\Selfbest"
$exePath = "$installDir\selfbest.exe"
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

# Download URL (ZIP)
$url = "https://github.com/tiwari-mani-tft/Selfbest-CLI-Release/releases/latest/download/selfbest-windows-$arch.zip"

Write-Host "Downloading Selfbest CLI ($arch)..."

# Create install directory
New-Item -ItemType Directory -Force -Path $installDir | Out-Null

# Download zip
Invoke-WebRequest -Uri $url -OutFile $tempZip

Write-Host "Extracting..."

# Extract binary
Expand-Archive -Force $tempZip $installDir

# Cleanup
Remove-Item $tempZip

Write-Host "Installing..."

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

Write-Host "Installation complete"
Write-Host "Restart PowerShell, then run: selfbest version"
