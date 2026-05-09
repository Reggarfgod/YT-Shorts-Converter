function Start-Conversion {

    param (

        $Video,
        $RatioName,
        $Filter,
        $StartTime,
        $EndTime
    )

    $outputFolder = "Converted_Output"

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

ffmpeg -y `
-ss $StartTime `
-to $EndTime `
-i "$inputFile" `
-filter_complex $Filter `
-map "[outv]" `
-r 60 `
-s 1080x1920 `
-c:v libx264 `
-preset medium `
-crf 20 `
-pix_fmt yuv420p `
-c:a aac `
-b:a 192k `
"$outputFile"

        Write-Host ""
        Write-Host "================================================="
        Write-Host " CONVERSION COMPLETE!"
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
