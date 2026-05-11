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
iex (iwr "$repo/core/overlay.ps1" -UseBasicParsing).Content

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
    # START CONVERSION
    # =====================================================

    $convertedFile = Start-Conversion `
        -Video $video `
        -RatioName $modeData.Ratio `
        -Filter $modeData.Filter `
        -StartTime $trimData.Start `
        -EndTime $trimData.End

    # =====================================================
    # ADD OVERLAY
    # =====================================================

    Write-Host ""
    Write-Host "================================================="
    Write-Host "ADD LIKE / SUBSCRIBE OVERLAY?"
    Write-Host "================================================="
    Write-Host "1. Yes"
    Write-Host "2. No"
    Write-Host ""

    $overlayChoice = Read-Host "Enter choice"

    if ($overlayChoice -eq "1") {

        $finalOutput = $convertedFile.Replace(
            ".mp4",
            "_Overlay.mp4"
        )

        Add-LikeSubscribeOverlay `
        -InputVideo $convertedFile `
        -OutputVideo $finalOutput

        Write-Host ""
        Write-Host "FINAL VIDEO:"
        Write-Host $finalOutput
        Write-Host ""
    }

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
