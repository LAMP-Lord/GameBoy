INCLUDE "hardware.inc"

SECTION "Audio       - Variables", WRAM0

hUGE_Bank:: db
sMOL_Bank:: db

SECTION "Audio       - Music Functions", ROM0

Music_Play_TitleScreen::
    call Audio_hUGEDriverCh2
    call Audio_hUGEDriverCh3
    call Audio_hUGEDriverCh4

    ld a, BANK(Music_TitleScreen)
    ld [hUGE_Bank], a
    ld hl, Music_TitleScreen
    call hUGE_init

    ldh a, [ActiveBank]
    ld [$2000], a

    ret

SECTION "Audio       - SFX Functions", ROM0

SFX_Play_MenuMove::
    ld a, BANK(SFX_MenuMove)
    ld [sMOL_Bank], a
    ld hl, SFX_MenuMove
    call sMOL_init

    call Audio_sMOLDriverCh1

    ldh a, [ActiveBank]
    ld [$2000], a

    ret

SFX_Play_MenuSelect::
    ld a, BANK(SFX_MenuSelect)
    ld [sMOL_Bank], a
    ld hl, SFX_MenuSelect
    call sMOL_init

    call Audio_sMOLDriverCh1

    ldh a, [ActiveBank]
    ld [$2000], a

    ret

SFX_Play_MenuBack::
    ld a, BANK(SFX_MenuBack)
    ld [sMOL_Bank], a
    ld hl, SFX_MenuBack
    call sMOL_init

    call Audio_sMOLDriverCh1

    ldh a, [ActiveBank]
    ld [$2000], a

    ret



SECTION "Audio       - Channel Overrides", ROM0

; Global
Audio_ResetChannels::
    call Audio_hUGEDriverCh1
    call Audio_hUGEDriverCh2
    call Audio_hUGEDriverCh3
    call Audio_hUGEDriverCh4
    ret

Audio_TurnOffAll::
    ld b, $0
    ld c, $1
    call hUGE_mute_channel
    ld c, $1
    call sMOL_mute_channel

    ld b, $1
    ld c, $1
    call hUGE_mute_channel
    ld c, $1
    call sMOL_mute_channel

    ld b, $2
    ld c, $1
    call hUGE_mute_channel
    ld c, $1
    call sMOL_mute_channel

    ld b, $3
    ld c, $1
    call hUGE_mute_channel
    ld c, $1
    call sMOL_mute_channel

    ret

; Channel Switches
Audio_sMOLDriverCh1::
    ld b, $0
    ld c, $1
    call hUGE_mute_channel

    ld c, $0
    call sMOL_mute_channel

    ret

Audio_sMOLDriverCh2::
    ld b, $1
    ld c, $1
    call hUGE_mute_channel

    ld c, $0
    call sMOL_mute_channel

    ret

Audio_sMOLDriverCh3::
    ld a, sMOL_NO_WAVE
    ld [sMOL_current_wave], a

    ld b, $2
    ld c, $1
    call hUGE_mute_channel

    ld c, $0
    call sMOL_mute_channel

    ret

Audio_sMOLDriverCh4::
    ld b, $3
    ld c, $1
    call hUGE_mute_channel

    ld c, $0
    call sMOL_mute_channel

    ret

Audio_hUGEDriverCh1::
    ld b, $0
    ld c, $0
    call hUGE_mute_channel

    ld c, $1
    call sMOL_mute_channel

    ret

Audio_hUGEDriverCh2::
    ld b, $1
    ld c, $0
    call hUGE_mute_channel

    ld c, $1
    call sMOL_mute_channel

    ret

Audio_hUGEDriverCh3::
    ld a, hUGE_NO_WAVE
    ld [hUGE_current_wave], a

    ld b, $2
    ld c, $0
    call hUGE_mute_channel

    ld c, $1
    call sMOL_mute_channel

    ret

Audio_hUGEDriverCh4::
    ld b, $3
    ld c, $0
    call hUGE_mute_channel

    ld c, $1
    call sMOL_mute_channel

    ret