
# AI TITLE GENERATOR
function Get-AutoTitle {

    param (

        [string]$VideoFile
    )

    Write-Host ""
    Write-Host "================================================="
    Write-Host "GENERATING AI TITLE"
    Write-Host "================================================="
    Write-Host ""

    # TEMP AUDIO FILE

    $audioFile = "$env:TEMP\short_audio.wav"

    # EXTRACT AUDIO
    ffmpeg -y `
    -i "$VideoFile" `
    -ar 16000 `
    -ac 1 `
    "$audioFile" | Out-Null


    # WHISPER EXE


    $whisperExe = ".\whisper.exe"

    # WHISPER MODEL


    $model = ".\models\ggml-base.en.bin"


    # CHECK WHISPER


    if (!(Test-Path $whisperExe)) {

        Write-Host ""
        Write-Host "whisper.exe NOT FOUND!"
        Write-Host ""

        return "WHAT JUST HAPPENED?!"
    }

    if (!(Test-Path $model)) {

        Write-Host ""
        Write-Host "Whisper Model NOT FOUND!"
        Write-Host ""

        return "INSANE VALORANT MOMENT!"
    }


    # RUN WHISPER


    $result = & $whisperExe `
        -m $model `
        -f "$audioFile"


    # JOIN TEXT


    $text = $result -join " "


    # CLEAN TEXT


    $text = $text `
        -replace '\[.*?\]', '' `
        -replace '[^a-zA-Z0-9 ]', ''

    $text = $text.Trim()


    # LIMIT LENGTH


    if ($text.Length -gt 60) {

        $text = $text.Substring(0,60)
    }


    # EMPTY TITLE


    if ([string]::IsNullOrWhiteSpace($text)) {

        $text = "INSANE VALORANT MOMENT!"
    }


    # RETURN TITLE

    return $text.ToUpper()
}
