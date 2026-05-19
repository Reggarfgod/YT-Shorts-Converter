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
    # VERIFY URL
    # =====================================================

    $verifyUrl = `
    "https://raw.githubusercontent.com/Reggarfgod/YT-Shorts-Converter/main/keys.json"

    try {

        # =================================================
        # DOWNLOAD KEYS
        # =================================================

        $json = `
        Invoke-RestMethod `
        -Uri $verifyUrl `
        -Method Get

        # =================================================
        # INVALID KEY
        # =================================================

        if (
            !$json.keys.$userKey
        ) {

            Write-Host ""
            Write-Host "================================================="
            Write-Host "INVALID KEY!"
            Write-Host "================================================="
            Write-Host ""

            pause
            exit
        }

        # =================================================
        # MASTER KEY
        # =================================================

        if (
            $json.keys.$userKey.master -eq $true
        ) {

            Write-Host ""
            Write-Host "================================================="
            Write-Host "MASTER KEY VERIFIED!"
            Write-Host "================================================="
            Write-Host ""

            return
        }

        # =================================================
        # USED KEY
        # =================================================

        if (
            $json.keys.$userKey.used -eq $true
        ) {

            Write-Host ""
            Write-Host "================================================="
            Write-Host "KEY ALREADY USED!"
            Write-Host "================================================="
            Write-Host ""

            pause
            exit
        }

        # =================================================
        # VALID
        # =================================================

        Write-Host ""
        Write-Host "================================================="
        Write-Host "KEY VERIFIED!"
        Write-Host "================================================="
        Write-Host ""

    }
    catch {

        Write-Host ""
        Write-Host "================================================="
        Write-Host "AUTH SERVER ERROR!"
        Write-Host "================================================="
        Write-Host ""

        pause
        exit
    }
}
