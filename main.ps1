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
# LOAD GITHUB SCRIPT FUNCTION
# =========================================================

function Load-GitHubScript {

    param (

        [string]$Path
    )

    $url = "$repo/$Path"

    Write-Host ""
    Write-Host "================================================="
    Write-Host "Loading Script:"
    Write-Host $url
    Write-Host "================================================="
    Write-Host ""

    try {

        # =============================================
        # DOWNLOAD FILE
        # =============================================

        $scriptContent = (
            iwr $url `
            -UseBasicParsing
        ).Content

        # =============================================
        # CHECK EMPTY FILE
        # =============================================

        if ([string]::IsNullOrWhiteSpace($scriptContent)) {

            Write-Host ""
            Write-Host "ERROR: EMPTY FILE!"
            Write-Host $url
            Write-Host ""

            return
        }

        # =============================================
        # EXECUTE SCRIPT
        # =============================================

        iex $scriptContent

        Write-Host ""
        Write-Host "SUCCESSFULLY LOADED!"
        Write-Host ""

    }
    catch {

        Write-Host ""
        Write-Host "================================================="
        Write-Host "FAILED TO LOAD SCRIPT!"
        Write-Host "================================================="
        Write-Host ""

        Write-Host "URL:"
        Write-Host $url
        Write-Host ""

        Write-Host "ERROR:"
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

# =========================================================
# CHECK FUNCTIONS LOADED
# =========================================================

if (-not (Get-Command Show-Banner -ErrorAction SilentlyContinue)) {

    Write-Host ""
    Write-Host "ERROR: Show-Banner function not loaded!"
    Write-Host ""

    Pause
    exit
}

if (-not (Get-Command Get-VideoSelection -ErrorAction SilentlyContinue)) {

    Write-Host ""
    Write-Host "ERROR: Get-VideoSelection function not loaded!"
    Write-Host ""

    Pause
    exit
}

if (-not (Get-Command Get-ModeSelection -ErrorAction SilentlyContinue)) {

    Write-Host ""
    Write-Host "ERROR: Get-ModeSelection function not loaded!"
    Write-Host ""

    Pause
    exit
}

if (-not (Get-Command Start-Conversion -ErrorAction SilentlyContinue)) {

    Write-Host ""
    Write-Host "ERROR: Start-Conversion function not loaded!"
    Write-Host ""

    Pause
    exit
}

# =========================================================
# MAIN LOOP
# =========================================================

do {

    # =============================================
    # SHOW UI
    # =============================================

    Show-Banner

    # =============================================
    # SELECT VIDEO
    # =============================================

    $video = Get-VideoSelection

    if ($null -eq $video) {

        break
    }

    # =============================================
    # SELECT MODE
    # =============================================

    $modeData = Get-ModeSelection

    if ($null -eq $modeData) {

        break
    }

    # =============================================
    # START CONVERSION
    # =============================================

    Start-Conversion `
        -Video $video `
        -RatioName $modeData.Ratio `
        -Filter $modeData.Filter

    # =============================================
    # NEXT ACTION
    # =============================================

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
