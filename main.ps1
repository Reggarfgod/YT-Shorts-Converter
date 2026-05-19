# =========================================================
# MAIN FILE
# FULL RGB COLOR VERSION
# =========================================================

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# =========================================================
# FULL COLOR UI SYSTEM
# =========================================================

$Host.UI.RawUI.WindowTitle = "YT SHORTS CONVERTER PRO"

function Write-Title($text) {

    Write-Host ""
    Write-Host "=================================================" -ForegroundColor DarkCyan
    Write-Host " $text" -ForegroundColor Cyan
    Write-Host "=================================================" -ForegroundColor DarkCyan
    Write-Host ""
}

function Write-Success($text) {

    Write-Host "[SUCCESS] $text" -ForegroundColor Green
}

function Write-ErrorMsg($text) {

    Write-Host "[ERROR] $text" -ForegroundColor Red
}

function Write-Warn($text) {

    Write-Host "[WARNING] $text" -ForegroundColor Yellow
}

function Write-Info($text) {

    Write-Host "[INFO] $text" -ForegroundColor Magenta
}

function Show-Loading($text) {

    Write-Host ""
    Write-Host "$text" -ForegroundColor Yellow

    for ($i = 0; $i -lt 5; $i++) {

        Write-Host "■" -NoNewline -ForegroundColor Cyan
        Start-Sleep -Milliseconds 200
    }

    Write-Host ""
    Write-Host ""
}

function Show-Banner {

    Clear-Host

    Write-Host ""
    Write-Host "██╗   ██╗████████╗    ███████╗██╗  ██╗ ██████╗ ██████╗ ████████╗███████╗" -ForegroundColor Cyan
    Write-Host "╚██╗ ██╔╝╚══██╔══╝    ██╔════╝██║  ██║██╔═══██╗██╔══██╗╚══██╔══╝██╔════╝" -ForegroundColor Blue
    Write-Host " ╚████╔╝    ██║       ███████╗███████║██║   ██║██████╔╝   ██║   ███████╗" -ForegroundColor Magenta
    Write-Host "  ╚██╔╝     ██║       ╚════██║██╔══██║██║   ██║██╔══██╗   ██║   ╚════██║" -ForegroundColor Red
    Write-Host "   ██║      ██║       ███████║██║  ██║╚██████╔╝██║  ██║   ██║   ███████║" -ForegroundColor Yellow
    Write-Host "   ╚═╝      ╚═╝       ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝" -ForegroundColor Green

    Write-Host ""
    Write-Host "============================================================" -ForegroundColor DarkGray
    Write-Host "               YT SHORTS CONVERTER PRO" -ForegroundColor White
    Write-Host "============================================================" -ForegroundColor DarkGray
    Write-Host ""
}

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
iex (iwr "$repo/core/effects.ps1" -UseBasicParsing).Content
iex (iwr "$repo/core/textoverlay.ps1" -UseBasicParsing).Content
iex (iwr "$repo/core/socialoverlay.ps1" -UseBasicParsing).Content
iex (iwr "$repo/core/keyauth.ps1" -UseBasicParsing).Content

# =========================================================
# LICENSE AUTH
# =========================================================

Confirm-License

# =========================================================
# MAIN LOOP
# =========================================================

do {

    Show-Banner

    # =====================================================
    # ASK MONTAGE
    # =====================================================

    Write-Host ""
    Write-Host "=================================================" -ForegroundColor DarkCyan
    Write-Host "CREATE MONTAGE SHORT?" -ForegroundColor Cyan
    Write-Host "=================================================" -ForegroundColor DarkCyan
    Write-Host "1. Yes" -ForegroundColor Green
    Write-Host "2. No" -ForegroundColor Red
    Write-Host ""

    $montageChoice = Read-Host "Enter choice"

    # =====================================================
    # MONTAGE MODE
    # =====================================================

    if ($montageChoice -eq "1") {

        Write-Host ""
        Write-Host "=================================================" -ForegroundColor DarkMagenta
        Write-Host "VIDEOS IN CURRENT FOLDER" -ForegroundColor Magenta
        Write-Host "=================================================" -ForegroundColor DarkMagenta
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
            Write-Host "NO VIDEOS FOUND!" -ForegroundColor Red
            Write-Host ""

            pause
            continue
        }

        # =================================================
        # SHOW VIDEOS
        # =================================================

        for ($i = 0; $i -lt $allVideos.Count; $i++) {

            Write-Host "$($i + 1). $($allVideos[$i].Name)" -ForegroundColor White
        }

        Write-Host ""
        Write-Host "Example: 1,2,3" -ForegroundColor Yellow
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
        # TEMP FOLDER
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
            Write-Host "=================================================" -ForegroundColor DarkYellow
            Write-Host "TRIM SETTINGS FOR:" -ForegroundColor Yellow
            Write-Host $clip.Name -ForegroundColor White
            Write-Host "=================================================" -ForegroundColor DarkYellow
            Write-Host ""

            $trimData = Get-TrimSettings

            if ($null -eq $trimData) {

                break
            }

            $tempClip = `
            "$tempFolder\clip_$i.mp4"

            Write-Host ""
            Write-Host "CREATING CLIP..." -ForegroundColor Cyan
            Write-Host ""

            Show-Loading "Processing Clip"

            ffmpeg -y `
            -ss $trimData.Start `
            -to $trimData.End `
            -i "$($clip.FullName)" `
            -c:v h264_nvenc `
            -preset p5 `
            -cq 20 `
            -b:v 0 `
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
        # CREATE FINAL MONTAGE
        # =================================================

        $montageOutput = `
        "Converted_Output\Montage_Final.mp4"

        Write-Host ""
        Write-Host "=================================================" -ForegroundColor DarkGreen
        Write-Host "CREATING FINAL MONTAGE..." -ForegroundColor Green
        Write-Host "=================================================" -ForegroundColor DarkGreen
        Write-Host ""

        Show-Loading "Rendering Montage"

        ffmpeg -y `
        -f concat `
        -safe 0 `
        -i "$concatList" `
        -c:v h264_nvenc `
        -preset p5 `
        -cq 20 `
        -b:v 0 `
        -pix_fmt yuv420p `
        -c:a aac `
        -b:a 192k `
        "$montageOutput"

        Write-Success "Montage Created Successfully!"

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
    # EFFECTS
    # =====================================================

    Write-Info "Loading Effects..."

    $effectsFilter = Get-EffectsFilter

    # =====================================================
    # TEXT OVERLAY
    # =====================================================

    Write-Info "Loading Text Overlay..."

    $textFilter = Get-TextOverlayFilter

    # =====================================================
    # SOCIAL OVERLAY
    # =====================================================

    Write-Info "Loading Social Overlay..."

    $socialFilter = Get-SocialOverlayFilter

    # =====================================================
    # SELECT MODE
    # =====================================================

    Write-Info "Selecting Output Mode..."

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
    # APPLY FILTERS
    # =====================================================

    $combinedEffects = @()

    if ($effectsFilter -ne "") {

        $combinedEffects += $effectsFilter
    }

    if ($textFilter -ne "") {

        $combinedEffects += $textFilter
    }

    $normalEffects = `
    ($combinedEffects -join ",")

    if ($normalEffects -ne "") {

        $finalFilter = `
        $modeData.Filter.Replace(
            "[outv]",
            "," + $normalEffects + "[outv]"
        )
    }
    else {

        $finalFilter = `
        $modeData.Filter
    }

    # =====================================================
    # SOCIAL PNG OVERLAY
    # =====================================================

    if ($socialFilter -ne "") {

        $finalFilter = `
        $finalFilter.Replace(
            "[outv]",
            "[base]"
        )

        $finalFilter += `
        ";" + $socialFilter
    }

    # =====================================================
    # START CONVERSION
    # =====================================================

    Write-Host ""
    Write-Host "=================================================" -ForegroundColor DarkCyan
    Write-Host "STARTING CONVERSION..." -ForegroundColor Cyan
    Write-Host "=================================================" -ForegroundColor DarkCyan
    Write-Host ""

    Show-Loading "Converting Video"

    Start-Conversion `
        -Video $video `
        -RatioName $modeData.Ratio `
        -Filter $finalFilter `
        -StartTime $trimData.Start `
        -EndTime $trimData.End

    Write-Success "Conversion Completed!"

    # =====================================================
    # FINISHED
    # =====================================================

    Write-Host ""
    Write-Host "=================================================" -ForegroundColor DarkGray
    Write-Host "1. Convert Another Video" -ForegroundColor Green
    Write-Host "2. Exit" -ForegroundColor Red
    Write-Host "=================================================" -ForegroundColor DarkGray
    Write-Host ""

    $next = Read-Host "Enter choice"

} while ($next -ne "2")

Write-Host ""
Write-Host "THANKS FOR USING YT SHORTS CONVERTER PRO!" -ForegroundColor Cyan
Write-Host ""
