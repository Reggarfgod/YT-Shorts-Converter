function Get-TextOverlayFilter {

    Write-Host ""
    Write-Host "================================================="
    Write-Host "ADD TEXT OVERLAY?"
    Write-Host "================================================="
    Write-Host "1. Yes"
    Write-Host "2. No"
    Write-Host ""

    $choice = Read-Host "Enter choice"

    if ($choice -ne "1") {

        return ""
    }

    # =====================================================
    # TEXT INPUT
    # =====================================================

    Write-Host ""

    $overlayText = Read-Host "Enter text"

    if ([string]::IsNullOrWhiteSpace($overlayText)) {

        return ""
    }

    # =====================================================
    # POSITION
    # =====================================================

    Write-Host ""
    Write-Host "================================================="
    Write-Host "TEXT POSITION"
    Write-Host "================================================="
    Write-Host "1. Top"
    Write-Host "2. Center"
    Write-Host "3. Bottom"
    Write-Host ""

    $positionChoice = Read-Host "Enter choice"

    switch ($positionChoice) {

        # =================================================
        # TOP
        # =================================================

        "1" {

            $yPos = "150"
        }

        # =================================================
        # CENTER
        # =================================================

        "2" {

            $yPos = "(h-text_h)/2"
        }

        # =================================================
        # BOTTOM
        # =================================================

        "3" {

            $yPos = "h-350"
        }

        default {

            $yPos = "150"
        }
    }

    # =====================================================
    # FONT STYLE
    # =====================================================

    $fontPath = `
    "C\:/Windows/Fonts/arialbd.ttf"

    # =====================================================
    # STYLED TEXT
    # =====================================================

    $textFilter = @"

drawtext=
fontfile='$fontPath':
text='$overlayText':
fontcolor=white:
fontsize=72:
line_spacing=10:
borderw=10:
bordercolor=black:
shadowx=5:
shadowy=5:
shadowcolor=black@0.9:
x=(w-text_w)/2:
y=$yPos

"@

    # REMOVE NEWLINES
    $textFilter = `
    $textFilter.Replace("`r","")

    $textFilter = `
    $textFilter.Replace("`n","")

    return $textFilter
}
