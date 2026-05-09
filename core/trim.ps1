
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
    Write-Host "Example:"
    Write-Host "Start = 00:01:20"
    Write-Host "End   = 00:02:20"
    Write-Host ""
    Write-Host "Maximum Allowed = 60 Seconds"
    Write-Host ""

    # =====================================================
    # ASK USER
    # =====================================================

    $startTime = Read-Host "Enter Start Time (HH:MM:SS)"

    $endTime = Read-Host "Enter End Time (HH:MM:SS)"

    # =====================================================
    # VALIDATE FORMAT
    # =====================================================

    try {

        $start = [TimeSpan]::Parse($startTime)

        $end = [TimeSpan]::Parse($endTime)
    }
    catch {

        Write-Host ""
        Write-Host "================================================="
        Write-Host "INVALID TIME FORMAT!"
        Write-Host "Use HH:MM:SS"
        Write-Host "================================================="
        Write-Host ""

        return $null
    }

    # =====================================================
    # CALCULATE DURATION
    # =====================================================

    $duration = $end - $start

    # =====================================================
    # INVALID DURATION
    # =====================================================

    if ($duration.TotalSeconds -le 0) {

        Write-Host ""
        Write-Host "================================================="
        Write-Host "END TIME MUST BE GREATER!"
        Write-Host "================================================="
        Write-Host ""

        return $null
    }

    # =====================================================
    # LIMIT TO 60 SECONDS
    # =====================================================

    if ($duration.TotalSeconds -gt 60) {

        Write-Host ""
        Write-Host "================================================="
        Write-Host "VIDEO TOO LONG!"
        Write-Host "Maximum allowed = 60 seconds"
        Write-Host "================================================="
        Write-Host ""

        return $null
    }

    # =====================================================
    # SHOW INFO
    # =====================================================

    Write-Host ""
    Write-Host "================================================="
    Write-Host "TRIM SETTINGS"
    Write-Host "================================================="
    Write-Host "Start Time : $startTime"
    Write-Host "End Time   : $endTime"
    Write-Host "Duration   : $($duration.TotalSeconds) Seconds"
    Write-Host "================================================="
    Write-Host ""

    # =====================================================
    # RETURN DATA
    # =====================================================

    return @{
        Start = $startTime
        End = $endTime
    }
}
