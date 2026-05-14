function Get-EffectsFilter {

    Write-Host ""
    Write-Host "================================================="
    Write-Host "VIDEO EFFECTS"
    Write-Host "================================================="
    Write-Host ""
    Write-Host "1. Normal"
    Write-Host "2. Optical Flow Smooth"
    Write-Host "3. Saturation Boost"
    Write-Host "4. Optical Flow + Saturation"
    Write-Host ""

    $effectChoice = Read-Host "Enter choice"

    switch ($effectChoice) {

        # =================================================
        # NORMAL
        # =================================================

        "1" {

            return ""
        }

        # =================================================
        # OPTICAL FLOW
        # =================================================

        "2" {

            return ",minterpolate=fps=120:mi_mode=mci:mc_mode=aobmc:me_mode=bidir:vsbmc=1"
        }

        # =================================================
        # SATURATION
        # =================================================

        "3" {

            Write-Host ""
            Write-Host "Example:"
            Write-Host "1.0 = Normal"
            Write-Host "1.3 = Vibrant"
            Write-Host "1.5 = Strong"
            Write-Host "2.0 = Extreme"
            Write-Host ""

            $satValue = Read-Host "Enter saturation value"

            return ",eq=saturation=$satValue"
        }

        # =================================================
        # BOTH
        # =================================================

        "4" {

            Write-Host ""
            Write-Host "Example:"
            Write-Host "1.0 = Normal"
            Write-Host "1.3 = Vibrant"
            Write-Host "1.5 = Strong"
            Write-Host "2.0 = Extreme"
            Write-Host ""

            $satValue = Read-Host "Enter saturation value"

            return ",minterpolate=fps=120:mi_mode=mci:mc_mode=aobmc:me_mode=bidir:vsbmc=1,eq=saturation=$satValue"
        }

        default {

            return ""
        }
    }
}
