function Start-Conversion {

    param (

        $Video,
        $RatioName,
        $Filter,
        $StartTime,
        $EndTime
    )

    $outputFolder = "Converted_Output"

    # =====================================================
    # CREATE OUTPUT FOLDER
    # =====================================================

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

        Write-Host "================================================="
        Write-Host "GPU RENDERING ENABLED (NVENC)"
        Write-Host "================================================="
        Write-Host ""

        ffmpeg -y `
        -hwaccel cuda `
        -ss $StartTime `
        -to $EndTime `
        -i "$inputFile" `
        -filter_complex $Filter `
        -map "[outv]" `
        -map 0:a? `
        -r 60 `
        -s 1080x1920 `
        -c:v h264_nvenc `
        -preset p5 `
        -cq 20 `
        -b:v 0 `
        -pix_fmt yuv420p `
        -c:a aac `
        -b:a 192k `
        -movflags +faststart `
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
