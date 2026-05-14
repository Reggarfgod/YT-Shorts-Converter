function Create-MontageVideo {

    param (

        [array]$Videos,
        [string]$OutputName = "Montage_Short.mp4"
    )

    $outputFolder = "Converted_Output"

    if (!(Test-Path $outputFolder)) {

        New-Item `
        -ItemType Directory `
        -Path $outputFolder | Out-Null
    }

    $tempFolder = Join-Path `
    $outputFolder `
    "temp_montage"

    if (!(Test-Path $tempFolder)) {

        New-Item `
        -ItemType Directory `
        -Path $tempFolder | Out-Null
    }

    $listFile = Join-Path `
    $outputFolder `
    "montage_list.txt"

    "" | Set-Content $listFile

    # =====================================================
    # PROCESS EACH VIDEO
    # =====================================================

    for ($i = 0; $i -lt $Videos.Count; $i++) {

        $video = $Videos[$i]

        Write-Host ""
        Write-Host "================================================="
        Write-Host "TRIM SETTINGS FOR:"
        Write-Host $video.Name
        Write-Host "================================================="
        Write-Host ""

        $trimData = Get-TrimSettings

        $tempClip = Join-Path `
        $tempFolder `
        ("clip_" + $i + ".mp4")

        ffmpeg -y `
        -ss $trimData.Start `
        -to $trimData.End `
        -i "$($video.FullName)" `
        -c:v libx264 `
        -preset fast `
        -crf 20 `
        -pix_fmt yuv420p `
        -c:a aac `
        -b:a 192k `
        "$tempClip"

        $clipPath =
        $tempClip.Replace("\", "/")

        Add-Content `
        $listFile `
        "file '$clipPath'"
    }

    # =====================================================
    # FINAL OUTPUT
    # =====================================================

    $outputFile = Join-Path `
    $outputFolder `
    $OutputName

    Write-Host ""
    Write-Host "================================================="
    Write-Host "CREATING FINAL MONTAGE..."
    Write-Host "================================================="
    Write-Host ""

    ffmpeg -y `
    -f concat `
    -safe 0 `
    -i "$listFile" `
    -c copy `
    "$outputFile"

    Write-Host ""
    Write-Host "================================================="
    Write-Host "MONTAGE COMPLETE!"
    Write-Host "================================================="
    Write-Host ""

    Write-Host "Saved To:"
    Write-Host $outputFile
    Write-Host ""

    return Get-Item $outputFile
}
