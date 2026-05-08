# =========================================================
# Video Ratio Converter
# 9:16 / 1:1 / 4:3
# Crop / Blur Modes
# 60 FPS + 1 Minute
# Created By Reggarf
# =========================================================

do {

Clear-Host

Write-Host ""
Write-Host "================================================="
Write-Host "          Video Ratio Converter"
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

$outputFolder = "Converted_Output"

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

        Write-Host ""
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
# SELECT MODE
# =========================================================

Write-Host ""
Write-Host "Select Output Type:"
Write-Host ""
Write-Host "1. 9:16 Center Crop"
Write-Host "2. 9:16 Blur Background"
Write-Host "3. 1:1 Center Crop"
Write-Host "4. 4:3 Center Crop"
Write-Host "5. 1:1 In 9:16 Blur"
Write-Host "6. 4:3 In 9:16 Blur"
Write-Host ""

$mode = Read-Host "Enter mode number"

switch ($mode) {

    # =====================================================
    # 9:16 CENTER CROP
    # =====================================================

    "1" {

        $ratioName = "9x16_Crop"

        $filter = "scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920"

    }

    # =====================================================
    # 9:16 BLUR BACKGROUND
    # =====================================================

    "2" {

        $ratioName = "9x16_Blur"

        $filter = "[0:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,boxblur=20:10[bg];[0:v]scale=1080:-1:force_original_aspect_ratio=decrease[fg];[bg][fg]overlay=(W-w)/2:(H-h)/2"

    }

    # =====================================================
    # 1:1 CENTER CROP
    # =====================================================

    "3" {

        $ratioName = "1x1"

        $filter = "scale=1080:1080:force_original_aspect_ratio=increase,crop=1080:1080"

    }

    # =====================================================
    # 4:3 CENTER CROP
    # =====================================================

    "4" {

        $ratioName = "4x3"

        $filter = "scale=1440:1080:force_original_aspect_ratio=increase,crop=1440:1080"

    }

    # =====================================================
    # 1:1 INSIDE 9:16 WITH BLUR
    # =====================================================

    "5" {

        $ratioName = "1x1_Blur_9x16"

        $filter = "[0:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,boxblur=25:10[bg];[0:v]scale=1080:1080:force_original_aspect_ratio=increase,crop=1080:1080[fg];[bg][fg]overlay=(W-w)/2:(H-h)/2"

    }

    # =====================================================
    # 4:3 INSIDE 9:16 WITH BLUR
    # =====================================================

    "6" {

        $ratioName = "4x3_Blur_9x16"

        $filter = "[0:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,boxblur=25:10[bg];[0:v]scale=1080:810:force_original_aspect_ratio=increase,crop=1080:810[fg];[bg][fg]overlay=(W-w)/2:(H-h)/2"

    }

    default {

        Write-Host ""
        Write-Host "Invalid Mode!"
        Write-Host ""
        Pause
        exit
    }
}

Write-Host ""
Write-Host "Selected Mode: $ratioName"
Write-Host ""

# =========================================================
# OUTPUT FILE
# =========================================================

$inputFile = $video.FullName

$outputFile = Join-Path `
$outputFolder `
($video.BaseName + "_$ratioName.mp4")

# =========================================================
# CONVERT VIDEO
# =========================================================

try {

    Write-Host "Converting Video..."
    Write-Host ""

    ffmpeg -y `
    -i "$inputFile" `
    -t 60 `
    -filter_complex "$filter" `
    -r 60 `
    -c:v libx264 `
    -preset medium `
    -crf 20 `
    -pix_fmt yuv420p `
    -c:a aac `
    -b:a 192k `
    "$outputFile"

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

# =========================================================
# NEXT ACTION
# =========================================================

Write-Host ""
Write-Host "================================================="
Write-Host "1. Convert Another Video"
Write-Host "2. Exit"
Write-Host "================================================="
Write-Host ""

$nextAction = Read-Host "Enter choice"

if ($nextAction -eq "2") {

    break
}

} while ($true)