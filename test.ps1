# =========================================================
# VIDEO RATIO CONVERTER
# MAIN FILE
# Created By Reggarf
# =========================================================

# =========================================================
# BYPASS EXECUTION POLICY
# =========================================================

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# =========================================================
# GITHUB REPO
# =========================================================

$repo = "https://raw.githubusercontent.com/Reggarfgod/YT-Shorts-Converter/main"

# =========================================================
# LOAD GITHUB SCRIPT
# =========================================================

function Load-GitHubScript {

    param (

        [string]$Path
    )

    $url = "$repo/$Path"

    Write-Host ""
    Write-Host "================================================="
    Write-Host "LOADING:"
    Write-Host $url
    Write-Host "================================================="
    Write-Host ""

    try {

        $scriptContent = (
            iwr $url `
            -UseBasicParsing
        ).Content

        if ([string]::IsNullOrWhiteSpace($scriptContent)) {

            Write-Host ""
            Write-Host "ERROR: EMPTY FILE!"
            Write-Host ""

            return
        }

        iex $scriptContent

        Write-Host "SUCCESS!"
        Write-Host ""
    }
    catch {

        Write-Host ""
        Write-Host "FAILED TO LOAD:"
        Write-Host $url
        Write-Host ""
        Write-Host $_
        Write-Host ""

        Pause
        exit
    }
}

# =========================================================
# LOAD CORE FILES
# =========================================================

Load-GitHubScript "core/ui.ps1"

Load-GitHubScript "core/output.ps1"

Load-GitHubScript "core/ffmpeg.ps1"

Load-GitHubScript "core/videos.ps1"

Load-GitHubScript "core/modes.ps1"

Load-GitHubScript "core/converter.ps1"

Load-GitHubScript "core/upload.ps1"

# =========================================================
# CHECK FUNCTIONS
# =========================================================

if (-not (Get-Command Show-Banner -ErrorAction SilentlyContinue)) {

    Write-Host ""
    Write-Host "ERROR: Show-Banner NOT loaded!"
    Write-Host ""

    Pause
    exit
}

if (-not (Get-Command Get-VideoSelection -ErrorAction SilentlyContinue)) {

    Write-Host ""
    Write-Host "ERROR: Get-VideoSelection NOT loaded!"
    Write-Host ""

    Pause
    exit
}

if (-not (Get-Command Get-ModeSelection -ErrorAction SilentlyContinue)) {

    Write-Host ""
    Write-Host "ERROR: Get-ModeSelection NOT loaded!"
    Write-Host ""

    Pause
    exit
}

if (-not (Get-Command Start-Conversion -ErrorAction SilentlyContinue)) {

    Write-Host ""
    Write-Host "ERROR: Start-Conversion NOT loaded!"
    Write-Host ""

    Pause
    exit
}

# =========================================================
# MAIN LOOP
# =========================================================

do {

    # =====================================================
    # SHOW BANNER
    # =====================================================

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
    # START CONVERSION
    # =====================================================

    $outputVideo = Start-Conversion `
        -Video $video `
        -RatioName $modeData.Ratio `
        -Filter $modeData.Filter

    # =====================================================
    # YOUTUBE UPLOAD
    # =====================================================

    if ($outputVideo) {

        Upload-YouTubeShort `
            -VideoPath $outputVideo
    }

    # =====================================================
    # NEXT ACTION
    # =====================================================

    Write-Host ""
    Write-Host "================================================="
    Write-Host "1. Convert Another Video"
    Write-Host "2. Exit"
    Write-Host "================================================="
    Write-Host ""

    $next = Read-Host "Enter choice"

} while ($next -ne "2")

# =========================================================
# EXIT
# =========================================================

Write-Host ""
Write-Host "Goodbye!"
Write-Host ""