function Start-Conversion {

    param (

        $Video,
        $RatioName,
        $Filter,
        $StartTime,
        $EndTime,
        $AddOverlay
    )

    $outputFolder = "Converted_Output"

    if (!(Test-Path $outputFolder)) {

        New-Item `
        -ItemType Directory `
        -Path $outputFolder | Out-Null
    }

    $inputFile = $Video.FullName

    $outputFile = Join-Path `
    $outputFolder `
    ($Video.BaseName + "_$RatioName.mp4")

    try {

        Write-Host ""
        Write-Host "================================================="
        Write-Host "CONVERTING VIDEO..."
        Write-Host "================================================="
        Write-Host ""

        Write-Host "Start Time : $StartTime"
        Write-Host "End Time   : $EndTime"
        Write-Host ""

        # =================================================
        # FILTER FIX
        # =================================================

        if ($AddOverlay -eq "1") {

            $finalFilter = @"
$Filter,
drawbox=x=20:y=1650:w=1040:h=180:color=black@0.45:t=fill,
drawtext=fontfile='C\:/Windows/Fonts/arialbd.ttf':text='LIKE':fontcolor=white:fontsize=55:x=80:y=1700,
drawtext=fontfile='C\:/Windows/Fonts/arialbd.ttf':text='COMMENT':fontcolor=white:fontsize=55:x=330:y=1700,
drawtext=fontfile='C\:/Windows/Fonts/arialbd.ttf':text='SUBSCRIBE':fontcolor=red:fontsize=60:x=620:y=1695
"@
        }
        else {

            $finalFilter = $Filter
        }

        # =================================================
        # FFMPEG
        # =================================================

        ffmpeg -y `
        -ss $StartTime `
        -to $EndTime `
        -i "$inputFile" `
        -vf $finalFilter `
        -r 60 `
        -s 1080x1920 `
        -c:v libx264 `
        -preset medium `
        -crf 20 `
        -pix_fmt yuv420p `
        -map 0:a? `
        -c:a aac `
        -b:a 192k `
        -shortest `
        "$outputFile"

        Write-Host ""
        Write-Host "================================================="
        Write-Host "CONVERSION COMPLETE!"
        Write-Host "================================================="
        Write-Host ""

        Write-Host "Saved To:"
        Write-Host "$outputFile"
        Write-Host ""

        return $outputFile
    }
    catch {

        Write-Host ""
        Write-Host "SCRIPT ERROR!"
        Write-Host $_
    }
}
