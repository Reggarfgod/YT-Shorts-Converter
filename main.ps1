# =========================================================
# MAIN FILE
# =========================================================

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# =========================================================
# REPO URL
# =========================================================

$repo = "https://raw.githubusercontent.com/Reggarfgod/YT-Shorts-Converter/main"

# =========================================================
# LOAD FUNCTION
# =========================================================

function Load-Script {

    param (

        [string]$LocalPath,
        [string]$RemotePath
    )

    # =============================================
    # LOAD LOCAL FILE IF EXISTS
    # =============================================

    if (Test-Path $LocalPath) {

        . $LocalPath

        Write-Host "[LOCAL] Loaded $LocalPath"
    }

    # =============================================
    # OTHERWISE LOAD FROM GITHUB
    # =============================================

    else {

        Write-Host "[GITHUB] Loading $RemotePath"

        iex (iwr "$repo/$RemotePath" -UseBasicParsing).Content
    }
}

# =========================================================
# LOAD CORE FILES
# =========================================================

Load-Script "$PSScriptRoot\core\ui.ps1" "core/ui.ps1"

Load-Script "$PSScriptRoot\core\output.ps1" "core/output.ps1"

Load-Script "$PSScriptRoot\core\ffmpeg.ps1" "core/ffmpeg.ps1"

Load-Script "$PSScriptRoot\core\videos.ps1" "core/videos.ps1"

Load-Script "$PSScriptRoot\core\modes.ps1" "core/modes.ps1"

Load-Script "$PSScriptRoot\core\converter.ps1" "core/converter.ps1"

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
