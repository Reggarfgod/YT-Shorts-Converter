function Start-Conversion {

    param (

        $Video,
        $RatioName,
        $Filter
    )

    $outputFolder = "Converted_Output"

    $inputFile = $Video.FullName

    $outputFile = Join-Path `
    $outputFolder `
    ($Video.BaseName + "_$RatioName.mp4")

    try {

        Write-Host ""
        Write-Host "Converting Video..."
        Write-Host ""

        ffmpeg -y `
        -i "$inputFile" `
        -t 60 `
        -filter_complex "$Filter" `
        -r 60 `
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
    }
    catch {

        Write-Host ""
        Write-Host "SCRIPT ERROR!"
        Write-Host $_
    }
}