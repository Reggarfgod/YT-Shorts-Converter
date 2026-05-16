function Get-SocialOverlayFilter {

    Write-Host ""
    Write-Host "================================================="
    Write-Host "ADD SOCIAL OVERLAY?"
    Write-Host "================================================="
    Write-Host "1. Yes"
    Write-Host "2. No"
    Write-Host ""

    $choice = Read-Host "Enter choice"

    if ($choice -ne "1") {

        return ""
    }

    # =====================================================
    # POSITION
    # =====================================================

    Write-Host ""
    Write-Host "================================================="
    Write-Host "OVERLAY POSITION"
    Write-Host "================================================="
    Write-Host "1. Top"
    Write-Host "2. Center"
    Write-Host "3. Bottom"
    Write-Host ""

    $position = Read-Host "Enter choice"

    switch ($position) {

        "1" {

            $baseY = 120
        }

        "2" {

            $baseY = 700
        }

        "3" {

            $baseY = 1200
        }

        default {

            $baseY = 1200
        }
    }

    # =====================================================
    # ANIMATION TIMINGS
    # =====================================================

    $likeTime = 0
    $commentTime = 1.2
    $shareTime = 2.4
    $subscribeTime = 3.6

    # =====================================================
    # FILTER
    # =====================================================

    $filter = @"

drawbox=
x=140:
y=$baseY:
w=550:
h=90:
color=white@0.92:
t=fill:
enable='between(t,$likeTime,$likeTime+1.2)',

drawbox=
x=140:
y=$($baseY+110):
w=550:
h=90:
color=white@0.92:
t=fill:
enable='between(t,$commentTime,$commentTime+1.2)',

drawbox=
x=140:
y=$($baseY+220):
w=550:
h=90:
color=white@0.92:
t=fill:
enable='between(t,$shareTime,$shareTime+1.2)',

drawbox=
x=140:
y=$($baseY+330):
w=620:
h=90:
color=red@0.98:
t=fill:
enable='between(t,$subscribeTime,$subscribeTime+2)',

drawtext=
fontfile='C\:/Windows/Fonts/arialbd.ttf':
text='👍 Like':
fontcolor=black:
fontsize=42:
x=220:
y=$($baseY+22):
enable='between(t,$likeTime,$likeTime+1.2)',

drawtext=
fontfile='C\:/Windows/Fonts/arialbd.ttf':
text='💬 Comment':
fontcolor=black:
fontsize=42:
x=220:
y=$($baseY+132):
enable='between(t,$commentTime,$commentTime+1.2)',

drawtext=
fontfile='C\:/Windows/Fonts/arialbd.ttf':
text='↗ Share':
fontcolor=black:
fontsize=42:
x=220:
y=$($baseY+242):
enable='between(t,$shareTime,$shareTime+1.2)',

drawtext=
fontfile='C\:/Windows/Fonts/arialbd.ttf':
text='🔔 Subscribe':
fontcolor=white:
fontsize=44:
x=220:
y=$($baseY+352):
enable='between(t,$subscribeTime,$subscribeTime+2)'

"@

    $filter = `
    $filter.Replace("`r","")

    $filter = `
    $filter.Replace("`n","")

    return $filter
}
