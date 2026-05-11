function Add-LikeSubscribeOverlay {

    param (

        [string]$InputVideo,
        [string]$OutputVideo
    )

    Write-Host ""
    Write-Host "================================================="
    Write-Host "ADDING LIKE / SUBSCRIBE OVERLAY"
    Write-Host "================================================="
    Write-Host ""


    $filter = @"
drawbox=x=20:y=1650:w=1040:h=180:color=black@0.45:t=fill,
drawtext=fontfile=C\:/Windows/Fonts/arialbd.ttf:text='👍 LIKE':fontcolor=white:fontsize=55:x=80:y=1700,
drawtext=fontfile=C\:/Windows/Fonts/arialbd.ttf:text='💬 COMMENT':fontcolor=white:fontsize=55:x=330:y=1700,
drawtext=fontfile=C\:/Windows/Fonts/arialbd.ttf:text='🔔 SUBSCRIBE':fontcolor=red:fontsize=60:x=620:y=1695
"@


    ffmpeg -y `
    -i "$InputVideo" `
    -vf $filter `
    -c:v libx264 `
    -preset medium `
    -crf 20 `
    -c:a copy `
    "$OutputVideo"

    Write-Host ""
    Write-Host "================================================="
    Write-Host "OVERLAY COMPLETE!"
    Write-Host "================================================="
    Write-Host ""

    Write-Host "Saved To:"
    Write-Host $OutputVideo
    Write-Host ""
}
