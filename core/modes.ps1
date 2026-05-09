function Get-ModeSelection {

    Write-Host ""
    Write-Host "Select Output Type:"
    Write-Host ""
    Write-Host "1. 9:16 Center Crop"
    Write-Host "2. 9:16 Blur Background"
    Write-Host "3. 1:1 Center Crop"
    Write-Host "4. 4:3 Center Crop"
    Write-Host "5. 1:1 In 9:16 Blur"
    Write-Host "6. 4:3 In 9:16 Blur"
    Write-Host "7. Top Crop + Bottom Full Video"
    Write-Host ""

    $mode = Read-Host "Enter mode number"

    switch ($mode) {

        "1" {

            return @{

                Ratio = "9x16_Crop"

                Filter = 'scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920[outv]'
            }
        }

        "2" {

            return @{

                Ratio = "9x16_Blur"

                Filter = '[0:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,boxblur=20:10[bg];[0:v]scale=1080:-1:force_original_aspect_ratio=decrease[fg];[bg][fg]overlay=(W-w)/2:(H-h)/2[outv]'
            }
        }

        "3" {

            return @{

                Ratio = "1x1"

                Filter = 'scale=1080:1080:force_original_aspect_ratio=increase,crop=1080:1080[outv]'
            }
        }

        "4" {

            return @{

                Ratio = "4x3"

                Filter = 'scale=1440:1080:force_original_aspect_ratio=increase,crop=1440:1080[outv]'
            }
        }

        "5" {

            return @{

                Ratio = "1x1_Blur_9x16"

                Filter = '[0:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,boxblur=25:10[bg];[0:v]scale=1080:1080:force_original_aspect_ratio=increase,crop=1080:1080[fg];[bg][fg]overlay=(W-w)/2:(H-h)/2[outv]'
            }
        }

        "6" {

            return @{

                Ratio = "4x3_Blur_9x16"

                Filter = '[0:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,boxblur=25:10[bg];[0:v]scale=1080:810:force_original_aspect_ratio=increase,crop=1080:810[fg];[bg][fg]overlay=(W-w)/2:(H-h)/2[outv]'
            }
        }

        "7" {

            return @{

                Ratio = "TopCrop_BottomFull"

                Filter = '[0:v]split=2[top][bottom];[top]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,scale=1080:1500[topv];[bottom]scale=1080:-1:force_original_aspect_ratio=decrease,crop=1080:420[bottomv];[topv][bottomv]vstack=inputs=2[outv]'
            }
        }

        default {

            return $null
        }
    }
}
