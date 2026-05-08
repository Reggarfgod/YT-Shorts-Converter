# =========================================================
# YOUTUBE SHORTS UPLOAD
# POWERHELL ONLY
# =========================================================

function Upload-YouTubeShort {

    param (

        [string]$VideoPath
    )

    Write-Host ""
    Write-Host "================================================="
    Write-Host "YOUTUBE SHORTS UPLOAD"
    Write-Host "================================================="
    Write-Host ""

    # =====================================================
    # ASK USER
    # =====================================================

    $uploadChoice = Read-Host "Upload To YouTube Shorts? (Y/N)"

    if (
        $uploadChoice -ne "Y" -and
        $uploadChoice -ne "y"
    ) {

        return
    }

    # =====================================================
    # VIDEO TITLE
    # =====================================================

    $title = Read-Host "Enter Video Title"

    if ([string]::IsNullOrWhiteSpace($title)) {

        $title = "YouTube Short"
    }

    # =====================================================
    # DESCRIPTION
    # =====================================================

    $description = Read-Host "Enter Description"

    # =====================================================
    # TEMP HTML FILE
    # =====================================================

    $htmlFile = Join-Path `
    $env:TEMP `
    "youtube_upload.html"

    # =====================================================
    # CREATE HTML
    # =====================================================

    @"
<!DOCTYPE html>
<html>

<head>

<title>YouTube Upload</title>

<style>

body {

    background: #0f0f0f;
    color: white;
    font-family: Arial;
    text-align: center;
    padding-top: 100px;
}

button {

    padding: 20px;
    font-size: 20px;
    cursor: pointer;
}

</style>

</head>

<body>

<h1>YouTube Shorts Upload</h1>

<p>Drag your video into the upload page.</p>

<button onclick="window.open('https://www.youtube.com/upload','_blank')">

Open YouTube Upload

</button>

<script>

window.onload = () => {

    window.open('https://www.youtube.com/upload','_blank');
}

</script>

</body>

</html>
"@ | Set-Content `
$htmlFile `
-Encoding UTF8

    # =====================================================
    # OPEN YOUTUBE
    # =====================================================

    Start-Process $htmlFile

    # =====================================================
    # OPEN VIDEO FOLDER
    # =====================================================

    Start-Sleep 2

    $folder = Split-Path $VideoPath

    Start-Process explorer.exe $folder

    # =====================================================
    # SELECT VIDEO
    # =====================================================

    Start-Sleep 1

    Write-Host ""
    Write-Host "================================================="
    Write-Host "YOUTUBE OPENED!"
    Write-Host "Drag Video Into Browser"
    Write-Host "================================================="
    Write-Host ""

}