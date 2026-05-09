# =========================================================
# VIDEO TRIM FUNCTION
# core/trim.ps1
# =========================================================

function Get-TrimSettings {

    Write-Host ""
    Write-Host "================================================="
    Write-Host "VIDEO TRIM"
    Write-Host "================================================="
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "30"
    Write-Host "1:20"
    Write-Host "00:01:20"
    Write-Host ""
    Write-Host "Leave END TIME empty for automatic 60 seconds"
    Write-Host ""

    # =====================================================
    # TIME FORMAT CONVERTER
    # =====================================================

    function Convert-ToTimeFormat {

        param($time)

        if ([string]::IsNullOrWhiteSpace($time)) {

            return $null
        }

        if ($time -match '^\d+$') {

            return "00:00:$($time.PadLeft(2,'0'))"
        }

        elseif ($time -match '^\d+:\d+$') {

            return "00:$time"
        }

        return $time
    }

    # =====================================================
    # ASK USER
    # =====================================================

    $startTime = Read-Host "Enter Start Time"

    $endTime = Read-Host "Enter End Time (Optional)"

    # =====================================================
    # FORMAT TIME
    # =====================================================

    $startTime = Convert-ToTimeFormat $startTime

    $endTime = Convert-ToTimeFormat $endTime

    # =====================================================
    # VALIDATE START
    # =====================================================

    try {

        $start = [TimeSpan]::Parse($startTime)
    }
    catch {

        Write-Host ""
        Write-Host "INVALID START TIME!"
        Write-Host ""

        return $null
    }

    # =====================================================
    # AUTO 60 SEC
    # =====================================================

    if ([string]::IsNullOrWhiteSpace($endTime)) {

        $end = $start.Add(
            [TimeSpan]::FromSeconds(60)
        )

        $endTime = $end.ToString("hh\:mm\:ss")

        Write-Host ""
        Write-Host "AUTO END TIME:"
        Write-Host $endTime
        Write-Host ""
    }

    # =====================================================
    # VALIDATE END
    # =====================================================

    try {

        $end = [TimeSpan]::Parse($endTime)
    }
    catch {

        Write-Host ""
        Write-Host "INVALID END TIME!"
        Write-Host ""

        return $null
    }

    # =====================================================
    # CHECK DURATION
    # =====================================================

    $duration = $end - $start

    if ($duration.TotalSeconds -le 0) {

        Write-Host ""
        Write-Host "END TIME MUST BE GREATER!"
        Write-Host ""

        return $null
    }

    if ($duration.TotalSeconds -gt 60) {

        Write-Host ""
        Write-Host "MAXIMUM 60 SECONDS ALLOWED!"
        Write-Host ""

        return $null
    }

    # =====================================================
    # RETURN DATA
    # =====================================================

    return @{
        Start = $startTime
        End = $endTime
    }
}
