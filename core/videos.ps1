function Get-VideoSelection {

    $videoFiles = Get-ChildItem -File | Where-Object {

        $_.Extension.ToLower() -in @(
            ".mp4",
            ".mov",
            ".mkv",
            ".avi",
            ".webm"
        )
    }

    if ($videoFiles.Count -eq 0) {

        Write-Host "No video files found!"
        Pause
        return $null
    }

    Write-Host "Videos Found:"
    Write-Host "-------------------------------------------------"

    for ($i = 0; $i -lt $videoFiles.Count; $i++) {

        Write-Host "$($i + 1). $($videoFiles[$i].Name)"
    }

    Write-Host "-------------------------------------------------"

    $choice = Read-Host "Enter video number"

    return $videoFiles[[int]$choice - 1]
}