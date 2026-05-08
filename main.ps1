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
# LOAD SCRIPT FUNCTION
# =========================================================

function Load-Script {

    param (

        [string]$LocalPath,
        [string]$RemotePath
    )

    # =====================================================
    # LOAD LOCAL FILE
    # =====================================================

    if (
        $PSScriptRoot -and
        (Test-Path $LocalPath)
    ) {

        . $LocalPath

        Write-Host ""
        Write-Host "[LOCAL] Loaded:"
        Write-Host $LocalPath
        Write-Host ""
    }

    # =====================================================
    # LOAD FROM GITHUB
    # =====================================================

    else {

        Write-Host ""
        Write-Host "[GITHUB] Loading:"
        Write-Host $RemotePath
        Write-Host ""

        iex (
            iwr "$repo/$RemotePath" `
            -UseBasicParsing
        ).Content
    }
}

# =========================================================
# LOAD CORE FILES
# =========================================================

Load-Script `
"$PSScriptRoot\core\ui.ps1" `
"core/ui.ps1"

Load-Script `
"$PSScriptRoot\core\output.ps1" `
"core/output.ps1"

Load-Script `
"$PSScriptRoot\core\ffmpeg.ps1" `
"core/ffmpeg.ps1"

Load-Script `
"$PSScriptRoot\core\videos.ps1" `
"core/videos.ps1"

Load-Script `
"$PSScriptRoot\core\modes.ps1" `
"core/modes.ps1"

Load-Script `
"$PSScriptRoot\core\converter.ps1" `
"core/converter.ps1"

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

    Start-Conversion `
        -Video $video `
        -RatioName $modeData.Ratio `
        -Filter $modeData.Filter

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
