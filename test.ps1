# =========================================================
# MAIN FILE
# =========================================================

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# =========================================================
# LOAD CORE FILES FROM GITHUB
# =========================================================

$repo = "https://raw.githubusercontent.com/Reggarfgod/YT-Shorts-Converter/main"

iex (iwr "$repo/core/ui.ps1" -UseBasicParsing).Content
iex (iwr "$repo/core/output.ps1" -UseBasicParsing).Content
iex (iwr "$repo/core/ffmpeg.ps1" -UseBasicParsing).Content
iex (iwr "$repo/core/videos.ps1" -UseBasicParsing).Content
iex (iwr "$repo/core/modes.ps1" -UseBasicParsing).Content
iex (iwr "$repo/core/converter.ps1" -UseBasicParsing).Content
iex (iwr "$repo/core/upload.ps1" -UseBasicParsing).Content

# =========================================================
# MAIN LOOP
# =========================================================

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

    $outputVideo = Start-Conversion `
        -Video $video `
        -RatioName $modeData.Ratio `
        -Filter $modeData.Filter

    if ($outputVideo) {

        Upload-YouTubeShort `
            -VideoPath $outputVideo
    }

    Write-Host ""
    Write-Host "================================================="
    Write-Host "1. Convert Another Video"
    Write-Host "2. Exit"
    Write-Host "================================================="
    Write-Host ""

    $next = Read-Host "Enter choice"

} while ($next -ne "2")
