$ffmpegExists = Get-Command ffmpeg -ErrorAction SilentlyContinue

if (-not $ffmpegExists) {

    Write-Host ""
    Write-Host "FFmpeg is NOT installed!"
    Write-Host ""

    $install = Read-Host "Install FFmpeg automatically? (Y/N)"

    if ($install -eq "Y" -or $install -eq "y") {

        Write-Host "Downloading FFmpeg..."

        $zipFile = "ffmpeg.zip"
        $extractFolder = "ffmpeg_temp"

        Invoke-WebRequest `
        -Uri "https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip" `
        -OutFile $zipFile `
        -UseBasicParsing

        Expand-Archive `
        -Path $zipFile `
        -DestinationPath $extractFolder `
        -Force

        $ffmpegFolder = Get-ChildItem $extractFolder | Select-Object -First 1

        $binPath = Join-Path $ffmpegFolder.FullName "bin"

        $env:PATH += ";$binPath"

        Write-Host "FFmpeg Installed!"
    }
    else {

        exit
    }
}