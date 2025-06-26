INCLUDE "hardware.inc"
INCLUDE "charmap.inc"

SECTION "Entry Point", ROM0

EntryPoint::
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

    ld a, BANK(SFX)
    ld [sMOL_Bank], a
    ld hl, SFX
    call sMOL_init

    ld a, BANK(MitA)
    ld [hUGE_Bank], a
    ld hl, MitA
    call hUGE_init

    call App_SetUpOAMDMA

    call App_Reset
    call UI_Load
    call Int_InitInterrupts

    ld a, "T"
    ld [CurrentState], a
    jp ChangeState