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

        "1" { $baseY = 120 }
        "2" { $baseY = 700 }
        "3" { $baseY = 1200 }

        default { $baseY = 1200 }
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
    # SAFE INTEGER POSITIONS
    # =====================================================

    $y1 = [int]$baseY
    $y2 = [int]($baseY + 110)
    $y3 = [int]($baseY + 220)
    $y4 = [int]($baseY + 330)

    # =====================================================
    # CENTER X POSITION
    # =====================================================

    $xPos = "(W-w)/2"

    # =====================================================
    # FILTER
    # =====================================================

    $filter = "
movie=assets/like.png,scale=650:-1[like];
movie=assets/comment.png,scale=650:-1[comment];
movie=assets/share.png,scale=650:-1[share];
movie=assets/subscribe.png,scale=650:-1[sub];

[base][like]overlay=${xPos}:$($y1):enable='between(t,0,2)'[v1];
[v1][comment]overlay=${xPos}:$($y2):enable='between(t,2,4)'[v2];
[v2][share]overlay=${xPos}:$($y3):enable='between(t,4,6)'[v3];
[v3][sub]overlay=${xPos}:$($y4):enable='between(t,6,8)'[outv]
"

    return $filter
}
