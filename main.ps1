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
    # ASK MONTAGE
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
        Write-Host "VIDEOS IN CURRENT FOLDER"
        Write-Host "================================================="
        Write-Host ""

        $currentFolder = Get-Location

        $allVideos = Get-ChildItem `
        -Path $currentFolder `
        -File | Where-Object {

            $_.Extension -match `
            '\.mp4|\.mov|\.mkv|\.avi'
        }

        if ($allVideos.Count -eq 0) {

            Write-Host ""
            Write-Host "NO VIDEOS FOUND!"
            Write-Host ""

            pause
            continue
        }

        # =================================================
        # SHOW VIDEOS
        # =================================================

        for ($i = 0; $i -lt $allVideos.Count; $i++) {

            Write-Host "$($i + 1). $($allVideos[$i].Name)"
        }

        Write-Host ""
        Write-Host "Example: 1,2,3"
        Write-Host ""

        $selection = `
        Read-Host "Select videos for montage"

        $indexes = `
        $selection.Split(",")

        $selectedVideos = @()

        foreach ($index in $indexes) {

            $selectedVideos += `
            $allVideos[[int]$index.Trim() - 1]
        }

        # =================================================
        # TEMP FOLDERS
        # =================================================

        $tempFolder = `
        "Converted_Output\MontageTemp"

        if (!(Test-Path $tempFolder)) {

            New-Item `
            -ItemType Directory `
            -Path $tempFolder | Out-Null
        }

        $concatList = `
        "Converted_Output\montage_list.txt"

        "" | Set-Content $concatList

        # =================================================
        # TRIM EACH VIDEO
        # =================================================

        for ($i = 0; $i -lt $selectedVideos.Count; $i++) {

            $clip = $selectedVideos[$i]

            Write-Host ""
            Write-Host "================================================="
            Write-Host "TRIM SETTINGS FOR:"
            Write-Host $clip.Name
            Write-Host "================================================="
            Write-Host ""

            $trimData = Get-TrimSettings

            if ($null -eq $trimData) {

                break
            }

            $tempClip = `
            "$tempFolder\clip_$i.mp4"

            Write-Host ""
            Write-Host "CREATING CLIP..."
            Write-Host ""

            ffmpeg -y `
            -ss $trimData.Start `
            -to $trimData.End `
            -i "$($clip.FullName)" `
            -c:v libx264 `
            -preset fast `
            -crf 20 `
            -pix_fmt yuv420p `
            -c:a aac `
            -b:a 192k `
            "$tempClip"

            $absolutePath = `
(Resolve-Path $tempClip).Path

$fixedPath = `
$absolutePath.Replace("\", "/")

Add-Content `
$concatList `
"file '$fixedPath'"
        }

        # =================================================
        # CREATE MONTAGE
        # =================================================

        $montageOutput = `
        "Converted_Output\Montage_Final.mp4"

        Write-Host ""
        Write-Host "================================================="
        Write-Host "CREATING FINAL MONTAGE..."
        Write-Host "================================================="
        Write-Host ""

        ffmpeg -y `
        -f concat `
        -safe 0 `
        -i "$concatList" `
        -c copy `
        "$montageOutput"

        $video = Get-Item $montageOutput
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
    # NORMAL TRIM ONLY
    # =====================================================

    if ($montageChoice -ne "1") {

        $trimData = Get-TrimSettings

        if ($null -eq $trimData) {
            break
        }
    }
    else {

        $trimData = @{

            Start = "00:00:00"
            End   = "99:59:59"
        }
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
