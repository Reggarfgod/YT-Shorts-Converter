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
iex (iwr "$repo/core/montage.ps1" -UseBasicParsing).Content

# =========================================================
# MAIN LOOP
# =========================================================

do {

    Show-Banner

    # =====================================================
    # MONTAGE OPTION
    # =====================================================

    Write-Host ""
    Write-Host "================================================="
    Write-Host "CREATE MONTAGE SHORT?"
    Write-Host "================================================="
    Write-Host "1. Yes"
    Write-Host "2. No"
    Write-Host ""

    $montageChoice = Read-Host "Enter choice"

    # =====================================================
    # MONTAGE MODE
    # =====================================================

    if ($montageChoice -eq "1") {

        Write-Host ""
        Write-Host "================================================="
        Write-Host "SELECT VIDEOS FOR MONTAGE"
        Write-Host "================================================="
        Write-Host ""

        $videos = Get-ChildItem `
        -Path "." `
        -Include *.mp4,*.mov,*.mkv `
        -File

        for ($i = 0; $i -lt $videos.Count; $i++) {

            Write-Host "$($i + 1). $($videos[$i].Name)"
        }

        Write-Host ""
        Write-Host "Example: 1,2,3"
        Write-Host ""

        $selection = Read-Host "Enter video numbers"

        $indexes = $selection.Split(",")

        $selectedVideos = @()

        foreach ($index in $indexes) {

            $selectedVideos += `
            $videos[[int]$index - 1]
        }

        $video = Create-MontageVideo `
        -Videos $selectedVideos
    }
    else {

        # =================================================
        # NORMAL VIDEO SELECT
        # =================================================

        $video = Get-VideoSelection
    }

    # =====================================================
    # INVALID VIDEO
    # =====================================================

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

    Start-Conversion `
        -Video $video `
        -RatioName $modeData.Ratio `
        -Filter $modeData.Filter `
        -StartTime $trimData.Start `
        -EndTime $trimData.End

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
