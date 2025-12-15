$ErrorActionPreference = "Stop"

$installDir = "$env:LOCALAPPDATA\Programs\Selfbest"
$exePath = "$installDir\selfbest.exe"

if (-Not (Test-Path $exePath)) {
    Write-Host "SelfBest CLI not found at $exePath"
    exit 0
}

Write-Host "Removing SelfBest CLI executable..."
Remove-Item -Force $exePath

# Remove install directory if empty
if ((Get-ChildItem -Path $installDir -Recurse | Measure-Object).Count -eq 0) {
    Remove-Item -Force -Recurse $installDir
    Write-Host "🗑️ Removed empty install directory $installDir"
}

# Remove $installDir from user PATH if present
$path = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($path -like "*$installDir*") {
    $newPath = ($path -split ";") | Where-Object { $_ -ne $installDir } -join ";"
    [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
    Write-Host "Removed $installDir from PATH environment variable (User scope)."
} else {
    Write-Host "Installation directory not found in PATH."
}

Write-Host "SelfBest CLI uninstalled successfully!"
Write-Host "Please restart PowerShell or your terminal."
