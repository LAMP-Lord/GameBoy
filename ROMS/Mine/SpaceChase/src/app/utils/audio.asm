INCLUDE "hardware.inc"

SECTION "Utilities - Audio - WRAM", WRAM0

hUGE_Bank:: db

SECTION "Utilities - Audio - Music", ROM0

Music_ARCOM::
    call Audio_hUGEDriverCh1
    call Audio_hUGEDriverCh2
    call Audio_hUGEDriverCh3

    ld a, BANK(M_ARCOM)
    ld [hUGE_Bank], a
    ld hl, M_ARCOM
    call hUGE_init

    ldh a, [ActiveBank]
    ld [$2000], a
    ret

Music_KiwiDev::
    call Audio_hUGEDriverCh1
    call Audio_hUGEDriverCh2

    ld a, BANK(M_KiwiDev)
    ld [hUGE_Bank], a
    ld hl, M_KiwiDev
    call hUGE_init

    ldh a, [ActiveBank]
    ld [$2000], a
    ret

Music_TitleScreen::
    call Audio_hUGEDriverCh2
    call Audio_hUGEDriverCh3
    call Audio_hUGEDriverCh4

    ld a, BANK(M_TitleScreen)
    ld [hUGE_Bank], a
    ld hl, M_TitleScreen
    call hUGE_init

    ldh a, [ActiveBank]
    ld [$2000], a
    ret

Music_TEST::
    call Audio_hUGEDriverCh2
    call Audio_hUGEDriverCh3
    call Audio_hUGEDriverCh4

    ld a, BANK(M_TEST)
    ld [hUGE_Bank], a
    ld hl, M_TEST
    call hUGE_init
    
    ldh a, [ActiveBank]
    ld [$2000], a
    ret

SECTION "Utilities - Audio - SFX", ROM0

SFX_Play_MenuMove::
    ld  a, $08
    ldh [rNR10], a
    ld  a, $8b
    ldh [rNR11], a
    ld  a, $b1
    ldh [rNR12], a
    ld  a, $d0
    ldh [rNR13], a
    ld  a, $86
    ldh [rNR14], a
    ret

SFX_Play_MenuSelect::
    ld  a, $25
    ldh [rNR10], a
    ld  a, $B6
    ldh [rNR11], a
    ld  a, $D1
    ldh [rNR12], a
    ld  a, $CF
    ldh [rNR13], a
    ld  a, $86
    ldh [rNR14], a
    ret

SFX_Play_MenuBack::
    ld  a, $1a
    ldh [rNR10], a
    ld  a, $8b
    ldh [rNR11], a
    ld  a, $d1
    ldh [rNR12], a
    ld  a, $CF
    ldh [rNR13], a
    ld  a, $80
    ldh [rNR14], a
    ret



SECTION "Utilities - Audio - Main", ROM0

hUGE_SaveState:
    cp 0
    jr nz, .setorder
    ld a, [hUGE_current_order]
.setorder
    ld e, a
    ld a, [hUGE_current_tick]
    ld b, a
    ld a, [hUGE_current_row]
    ld d, a
    ret

hUGE_LoadState:
    ld c, e
    call hUGE_PositionJump

    ld a, b
    ld [hUGE_current_tick], a
    ld a, d
    ld [hUGE_current_row], a
    ret

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

    ld b, $1
    ld c, $1
    call hUGE_mute_channel

    ld b, $2
    ld c, $1
    call hUGE_mute_channel

    ld b, $3
    ld c, $1
    call hUGE_mute_channel

    ret

; Channel Switches
Audio_teNORDriverCh1::
    ld b, $0
    ld c, $1
    call hUGE_mute_channel

    ret

Audio_teNORDriverCh2::
    ld b, $1
    ld c, $1
    call hUGE_mute_channel

    ret

Audio_teNORDriverCh3::

    ld b, $2
    ld c, $1
    call hUGE_mute_channel

    ret

Audio_teNORDriverCh4::
    ld b, $3
    ld c, $1
    call hUGE_mute_channel

    ret

Audio_hUGEDriverCh1::
    ld b, $0
    ld c, $0
    call hUGE_mute_channel

    ret

Audio_hUGEDriverCh2::
    ld b, $1
    ld c, $0
    call hUGE_mute_channel

    ret

Audio_hUGEDriverCh3::
    ld a, hUGE_NO_WAVE
    ld [hUGE_current_wave], a

    ld b, $2
    ld c, $0
    call hUGE_mute_channel

    ret

Audio_hUGEDriverCh4::
    ld b, $3
    ld c, $0
    call hUGE_mute_channel

    ret