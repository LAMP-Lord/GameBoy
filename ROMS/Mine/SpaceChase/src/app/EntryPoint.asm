INCLUDE "hardware.inc"
INCLUDE "charmap.inc"

SECTION "Entry Point", ROM0

EntryPoint::
    ; Check console type
    cp BOOTUP_A_CGB
    jr nz, .dmg

    ld a, 1
    ldh [CGBFlag], a
    jr .endcheck

.dmg
    ld a, 0
    ldh [CGBFlag], a

.endcheck
    ; Clear Screen
    ld a, %00_00_00_00
    ld [rBGP], a
    ld a, %00_00_00_00
    ld [rOBP0], a
    ld a, %00_00_00_00
    ld [rOBP1], a
    ld a, LCDCF_OFF
    ldh [rLCDC], a

    ld sp, $FFFE

    ld a, BANK(SFX_MenuMove)
    ld [sMOL_Bank], a
    ld hl, SFX_MenuMove
    call sMOL_init

    ld a, BANK(Music_TitleScreen)
    ld [hUGE_Bank], a
    ld hl, Music_TitleScreen
    call hUGE_init

    ld a, $C3
    ld [CallFunction], a

    call App_SetUpOAMDMA

    call App_Reset
    call Int_InitInterrupts

    ld a, "T"
    ld [CurrentState], a
    jp ChangeState