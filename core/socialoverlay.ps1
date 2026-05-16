function Get-SocialOverlayFilter {

    Write-Host ""
    Write-Host "================================================="
    Write-Host "ADD SOCIAL OVERLAY?"
    Write-Host "================================================="
    Write-Host "1. Yes"
    Write-Host "2. No"
    Write-Host ""

    $choice = Read-Host "Enter choice"

    if ($choice -ne "1") {

        return ""
    }

    # =====================================================
    # POSITION
    # =====================================================

    Write-Host ""
    Write-Host "================================================="
    Write-Host "OVERLAY POSITION"
    Write-Host "================================================="
    Write-Host "1. Top"
    Write-Host "2. Center"
    Write-Host "3. Bottom"
    Write-Host ""

    $position = Read-Host "Enter choice"

    switch ($position) {

        "1" {

            $baseY = 120
        }

        "2" {

            $baseY = 700
        }

        "3" {

            $baseY = 1200
        }

        default {

            $baseY = 1200
        }
    }

    # =====================================================
    # DOWNLOAD PNGS
    # =====================================================

    $assetFolder = "assets"

    if (!(Test-Path $assetFolder)) {

        New-Item `
        -ItemType Directory `
        -Path $assetFolder | Out-Null
    }

    $repo = `
    "https://raw.githubusercontent.com/Reggarfgod/YT-Shorts-Converter/main/assets"

    Invoke-WebRequest `
    "$repo/like.png" `
    -OutFile "$assetFolder/like.png"

    Invoke-WebRequest `
    "$repo/comment.png" `
    -OutFile "$assetFolder/comment.png"

    Invoke-WebRequest `
    "$repo/share.png" `
    -OutFile "$assetFolder/share.png"

    Invoke-WebRequest `
    "$repo/subscribe.png" `
    -OutFile "$assetFolder/subscribe.png"

    # =====================================================
    # FILTER
    # =====================================================

$filter = @"

movie=assets/like.png[like];
movie=assets/comment.png[comment];
movie=assets/share.png[share];
movie=assets/subscribe.png[sub];

[base][like]overlay=x=60:y=$baseY:enable='between(t,0,1.5)'[v1];
[v1][comment]overlay=x=60:y=$($baseY+110):enable='between(t,1.2,2.7)'[v2];
[v2][share]overlay=x=60:y=$($baseY+220):enable='between(t,2.4,3.9)'[v3];
[v3][sub]overlay=x=60:y=$($baseY+330):enable='between(t,3.6,6)'[outv]

"@

    $filter = `
    $filter.Replace("`r","")

    $filter = `
    $filter.Replace("`n","")

    return $filter
}
