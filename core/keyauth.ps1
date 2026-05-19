function Confirm-License {

    # =====================================================
    # DISCORD INVITE
    # =====================================================

    $discordInvite = `
    "https://discord.gg/CN962KMpJk"

    Write-Host ""
    Write-Host "================================================="
    Write-Host "YT SHORTS CONVERTER AUTH"
    Write-Host "================================================="
    Write-Host ""
    Write-Host "JOIN DISCORD SERVER"
    Write-Host ""
    Write-Host $discordInvite
    Write-Host ""

    # =====================================================
    # AUTO OPEN DISCORD
    # =====================================================

    Start-Process $discordInvite

    Write-Host "AFTER JOINING:"
    Write-Host ""
    Write-Host "1. Go to key channel"
    Write-Host "2. Type !key"
    Write-Host "3. Copy your ONE TIME KEY"
    Write-Host "4. Paste it below"
    Write-Host ""

    # =====================================================
    # ASK KEY
    # =====================================================

    $userKey = `
    Read-Host "Enter Access Key"

    if ([string]::IsNullOrWhiteSpace($userKey)) {

        Write-Host ""
        Write-Host "================================================="
        Write-Host "INVALID KEY!"
        Write-Host "================================================="
        Write-Host ""

        pause
        exit
    }

    # =====================================================
    # VERIFY API URL
    # =====================================================

    $verifyUrl = `
    "http://45.141.36.74:2006/verify?key=$userKey"

    try {

        # =================================================
        # VERIFY KEY
        # =================================================

        $response = `
        Invoke-WebRequest `
        -Uri $verifyUrl `
        -UseBasicParsing

        $result = `
        $response.Content.Trim()

        # =================================================
        # VALID KEY
        # =================================================

        if (
            $result -eq "VALID_KEY"
        ) {

            Write-Host ""
            Write-Host "================================================="
            Write-Host "KEY VERIFIED!"
            Write-Host "================================================="
            Write-Host ""

            return
        }

        # =================================================
        # INVALID KEY
        # =================================================

        Write-Host ""
        Write-Host "================================================="
        Write-Host "INVALID OR USED KEY!"
        Write-Host "================================================="
        Write-Host ""

        pause
        exit
    }
    catch {

        Write-Host ""
        Write-Host "================================================="
        Write-Host "AUTH SERVER ERROR!"
        Write-Host "================================================="
        Write-Host ""

        Write-Host "CHECK:"
        Write-Host ""
        Write-Host "1. Bot is running"
        Write-Host "2. Express API added"
        Write-Host "3. Port 2006 open"
        Write-Host "4. Correct server IP"
        Write-Host ""

        pause
        exit
    }
}
