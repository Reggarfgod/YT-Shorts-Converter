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
iex (iwr "$repo/core/trim.ps1" -UseBasicParsing).Content

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
    # SELECT MODE
    # =====================================================

    $modeData = Get-ModeSelection

    if ($null -eq $modeData) {
        break
    }

    # =====================================================
    # TRIM SETTINGS
    # =====================================================

    $trimData = Get-TrimSettings

    if ($null -eq $trimData) {
        break
    }

    # =====================================================
    # ASK TEXT OVERLAY
    # =====================================================

    Write-Host ""
    Write-Host "================================================="
    Write-Host "ADD LIKE / SHARE / SUBSCRIBE TEXT?"
    Write-Host "================================================="
    Write-Host "1. Yes"
    Write-Host "2. No"
    Write-Host ""

    $textOverlay = Read-Host "Enter choice"

    # =====================================================
    # START CONVERSION
    # =====================================================

    $convertedFile = Start-Conversion `
        -Video $video `
        -RatioName $modeData.Ratio `
        -Filter $modeData.Filter `
        -StartTime $trimData.Start `
        -EndTime $trimData.End `
        -AddOverlay $textOverlay

    # =====================================================
    # FINAL OUTPUT
    # =====================================================

    Write-Host ""
    Write-Host "================================================="
    Write-Host "FINAL OUTPUT"
    Write-Host "================================================="
    Write-Host ""

    Write-Host $convertedFile
    Write-Host ""

    # =====================================================
    # FINISHED
    # =====================================================

    Write-Host ""
    Write-Host "================================================="
    Write-Host "1. Convert Another Video"
    Write-Host "2. Exit"
    Write-Host "================================================="
    Write-Host ""

    $next = Read-Host "Enter choice"

} while ($next -ne "2")
