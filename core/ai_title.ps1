# =========================================================
# AI TITLE GENERATOR
# HINDI + ENGLISH + HINGLISH SUPPORT
# =========================================================

function Get-AutoTitle {

    param (

        [string]$VideoFile
    )

    Write-Host ""
    Write-Host "================================================="
    Write-Host "GENERATING AI TITLE"
    Write-Host "================================================="
    Write-Host ""

    # =====================================================
    # TEMP AUDIO FILE
    # =====================================================

    $audioFile = "$env:TEMP\short_audio.wav"

    # =====================================================
    # EXTRACT AUDIO
    # =====================================================

    ffmpeg -y `
    -i "$VideoFile" `
    -ar 16000 `
    -ac 1 `
    "$audioFile" | Out-Null

    # =====================================================
    # WHISPER EXE
    # =====================================================

    $whisperExe = ".\whisper.exe"

    # =====================================================
    # MULTILINGUAL WHISPER MODEL
    # =====================================================

    $model = ".\models\ggml-base.bin"

    # =====================================================
    # CHECK WHISPER EXE
    # =====================================================

    if (!(Test-Path $whisperExe)) {

        Write-Host ""
        Write-Host "whisper.exe NOT FOUND!"
        Write-Host ""

        return "WHAT JUST HAPPENED?!"
    }

    # =====================================================
    # CHECK MODEL
    # =====================================================

    if (!(Test-Path $model)) {

        Write-Host ""
        Write-Host "Whisper Model NOT FOUND!"
        Write-Host ""
        Write-Host "Download:"
        Write-Host "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.bin"
        Write-Host ""

        return "INSANE VALORANT MOMENT!"
    }

    # =====================================================
    # RUN WHISPER
    # =====================================================

    Write-Host ""
    Write-Host "Analyzing Audio..."
    Write-Host ""

    $result = & $whisperExe `
        -m $model `
        -l auto `
        -f "$audioFile"

    # =====================================================
    # JOIN TEXT
    # =====================================================

    $text = $result -join " "

    # =====================================================
    # REMOVE TIMESTAMPS
    # =====================================================

    $text = $text `
        -replace '\[.*?\]', '' `
        -replace '\(.*?\)', ''

    # =====================================================
    # CLEAN TEXT
    # =====================================================

    $text = $text `
        -replace '[^a-zA-Z0-9ऀ-ॿ ]', ''

    $text = $text.Trim()

    # =====================================================
    # LIMIT LENGTH
    # =====================================================

    if ($text.Length -gt 60) {

        $text = $text.Substring(0,60)
    }

    # =====================================================
    # EMPTY TITLE
    # =====================================================

    if ([string]::IsNullOrWhiteSpace($text)) {

        $text = "INSANE VALORANT MOMENT!"
    }

    # =====================================================
    # HYPE WORDS
    # =====================================================

    if ($text.Length -lt 10) {

        $text = "$text WTF!"
    }

    # =====================================================
    # RETURN TITLE
    # =====================================================

    return $text.ToUpper()
}
