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

        # =================================================
        # TOP
        # =================================================

        "1" {

            $yPos = 120
        }

        # =================================================
        # CENTER
        # =================================================

        "2" {

            $yPos = 810
        }

        # =================================================
        # BOTTOM
        # =================================================

        "3" {

            $yPos = 1500
        }

        default {

            $yPos = 810
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
    # CENTER HORIZONTAL
    # =====================================================

    $xPos = "(W-w)/2"

    # =====================================================
    # FILTER
    # =====================================================

    $filter = "
movie=assets/like.png,scale=650:-1,format=rgba,fade=t=in:st=0:d=0.35:alpha=1,fade=t=out:st=2.65:d=0.35:alpha=1[like];
movie=assets/comment.png,scale=650:-1,format=rgba,fade=t=in:st=3:d=0.35:alpha=1,fade=t=out:st=5.65:d=0.35:alpha=1[comment];
movie=assets/share.png,scale=650:-1,format=rgba,fade=t=in:st=6:d=0.35:alpha=1,fade=t=out:st=8.65:d=0.35:alpha=1[share];
movie=assets/subscribe.png,scale=650:-1,format=rgba,fade=t=in:st=9:d=0.35:alpha=1,fade=t=out:st=11.65:d=0.35:alpha=1[sub];

[base][like]overlay=${xPos}:${yPos}:enable='between(t,0,3)'[v1];
[v1][comment]overlay=${xPos}:${yPos}:enable='between(t,3,6)'[v2];
[v2][share]overlay=${xPos}:${yPos}:enable='between(t,6,9)'[v3];
[v3][sub]overlay=${xPos}:${yPos}:enable='between(t,9,12)'[outv]
"

    return $filter
}
