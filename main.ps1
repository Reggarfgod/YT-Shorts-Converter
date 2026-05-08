# =========================================================
# MAIN FILE
# =========================================================

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# LOAD FILES
. "$PSScriptRoot\core\ui.ps1"
. "$PSScriptRoot\core\output.ps1"
. "$PSScriptRoot\core\ffmpeg.ps1"
. "$PSScriptRoot\core\videos.ps1"
. "$PSScriptRoot\core\modes.ps1"
. "$PSScriptRoot\core\converter.ps1"

do {

    Show-Banner

    $video = Get-VideoSelection

    if ($null -eq $video) {
        break
    }

    $modeData = Get-ModeSelection

    if ($null -eq $modeData) {
        break
    }

    Start-Conversion `
        -Video $video `
        -RatioName $modeData.Ratio `
        -Filter $modeData.Filter

    Write-Host ""
    Write-Host "================================================="
    Write-Host "1. Convert Another Video"
    Write-Host "2. Exit"
    Write-Host "================================================="
    Write-Host ""

    $next = Read-Host "Enter choice"

} while ($next -ne "2")