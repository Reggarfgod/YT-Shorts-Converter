# =========================================================
# 16:9 to YouTube Shorts Converter (9:16)
# 60 FPS + 1 Minute Shorts
# Created By Reggarf
# =========================================================

Clear-Host

Write-Host ""
Write-Host "================================================="
Write-Host "      YouTube Shorts Converter"
Write-Host "            Created By Reggarf"
Write-Host "================================================="
Write-Host ""

# =========================================================
# BYPASS EXECUTION POLICY
# =========================================================

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# =========================================================
# OUTPUT FOLDER
# =========================================================

$outputFolder = "Shorts_Output"

if (!(Test-Path $outputFolder)) {

    New-Item -ItemType Directory -Path $outputFolder | Out-Null
}

# =========================================================
# CHECK FFMPEG
# =========================================================

$ffmpegExists = Get-Command ffmpeg -ErrorAction SilentlyContinue

if (-not $ffmpegExists) {

    Write-Host ""
    Write-Host "FFmpeg is NOT installed!"
    Write-Host ""

    $install = Read-Host "Do you want to install FFmpeg automatically? (Y/N)"

    if ($install -eq "Y" -or $install -eq "y") {

        Write-Host ""
        Write-Host "Downloading FFmpeg..."
        Write-Host ""

        $zipFile = "ffmpeg.zip"
        $extractFolder = "ffmpeg_temp"

        Invoke-WebRequest `
        -Uri "https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip" `
        -OutFile $zipFile

        Write-Host "Extracting FFmpeg..."
        Write-Host ""

        Expand-Archive `
        -Path $zipFile `
        -DestinationPath $extractFolder `
        -Force

        $ffmpegFolder = Get-ChildItem $extractFolder | Select-Object -First 1

        $binPath = Join-Path $ffmpegFolder.FullName "bin"

        $env:PATH += ";$binPath"

        Write-Host ""
        Write-Host "FFmpeg Installed Successfully!"
        Write-Host ""

    }
    else {

        Write-Host ""
        Write-Host "FFmpeg is required!"
        Write-Host ""
        Pause
        exit
    }
}

# =========================================================
# GET VIDEO FILES
# =========================================================

$videoFiles = Get-ChildItem -File | Where-Object {

    $_.Extension.ToLower() -in @(
        ".mp4",
        ".mov",
        ".mkv",
        ".avi",
        ".webm"
    )
}

if ($videoFiles.Count -eq 0) {

    Write-Host ""
    Write-Host "No video files found in this folder!"
    Write-Host ""
    Pause
    exit
}

# =========================================================
# SHOW VIDEO LIST
# =========================================================

Write-Host "Videos Found:"
Write-Host "-------------------------------------------------"

for ($i = 0; $i -lt $videoFiles.Count; $i++) {

    Write-Host "$($i + 1). $($videoFiles[$i].Name)"
}

Write-Host "-------------------------------------------------"
Write-Host ""

# =========================================================
# ASK USER FOR VIDEO
# =========================================================

$choiceInput = Read-Host "Enter video number to convert"

try {

    $choice = [int]$choiceInput

}
catch {

    Write-Host ""
    Write-Host "ERROR: Please enter numbers only!"
    Write-Host ""
    Pause
    exit
}

if ($choice -lt 1 -or $choice -gt $videoFiles.Count) {

    Write-Host ""
    Write-Host "ERROR: Invalid video number!"
    Write-Host ""
    Pause
    exit
}

# =========================================================
# SELECT VIDEO
# =========================================================

$video = $videoFiles[$choice - 1]

Write-Host ""
Write-Host "Selected Video:"
Write-Host "$($video.Name)"
Write-Host ""

# =========================================================
# OUTPUT FILE
# =========================================================

$inputFile = $video.FullName

$outputFile = Join-Path `
$outputFolder `
($video.BaseName + "_SHORTS.mp4")

# =========================================================
# CONVERT VIDEO
# =========================================================

try {

    Write-Host "Converting Video..."
    Write-Host ""

    ffmpeg -y `
    -i "$inputFile" `
    -t 60 `
    -filter_complex "
    [0:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,boxblur=20:10[bg];
    [0:v]scale=1080:-1:force_original_aspect_ratio=decrease[fg];
    [bg][fg]overlay=(W-w)/2:(H-h)/2
    " `
    -r 60 `
    -c:v libx264 `
    -preset medium `
    -crf 20 `
    -pix_fmt yuv420p `
    -c:a aac `
    -b:a 192k `
    "$outputFile"

    # =====================================================
    # CHECK RESULT
    # =====================================================

    if ($LASTEXITCODE -ne 0) {

        Write-Host ""
        Write-Host "================================================="
        Write-Host " ERROR DURING CONVERSION!"
        Write-Host "================================================="
        Write-Host ""
        Write-Host "FFmpeg Exit Code: $LASTEXITCODE"
        Write-Host ""
    }
    else {

        Write-Host ""
        Write-Host "================================================="
        Write-Host " CONVERSION COMPLETE!"
        Write-Host "================================================="
        Write-Host ""
        Write-Host "Saved To:"
        Write-Host "$outputFile"
        Write-Host ""
    }

}
catch {

    Write-Host ""
    Write-Host "================================================="
    Write-Host " SCRIPT ERROR!"
    Write-Host "================================================="
    Write-Host ""
    Write-Host $_
    Write-Host ""
}

Pause