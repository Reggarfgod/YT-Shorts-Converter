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
iex (iwr "$repo/core/ai_title.ps1" -UseBasicParsing).Content

# =========================================================
# MAIN LOOP
# =========================================================

do {

    Show-Banner

    # =====================================================
    # SELECT VIDEO
    # =====================================================

    $video = Get-VideoSelection

    if ($null -eq $video) {
        break
    }

    # =====================================================
    # GENERATE AI TITLE
    # =====================================================

    $titleText = Get-AutoTitle `
        -VideoFile $video.FullName

    Write-Host ""
    Write-Host "================================================="
    Write-Host "AI TITLE:"
    Write-Host $titleText
    Write-Host "================================================="
    Write-Host ""

    # =====================================================
    # SELECT MODE
    # =====================================================

    $modeData = Get-ModeSelection

    if ($null -eq $modeData) {
        break
    }

    # =====================================================
    # ADD TITLE TO VIDEO
    # =====================================================

    $modeData.Filter += ",drawtext=text='$titleText':fontcolor=white:fontsize=60:borderw=4:bordercolor=black:x=(w-text_w)/2:y=780"

    # =====================================================
    # START CONVERSION
    # =====================================================

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
