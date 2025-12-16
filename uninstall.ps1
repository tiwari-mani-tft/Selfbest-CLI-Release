$path = (Get-Command selfbest).Source
if ($path) {
    Remove-Item $path -Force
    Write-Host "Deleted selfbest binary at: $path"
} else {
    Write-Host "selfbest executable not found in PATH."
}
