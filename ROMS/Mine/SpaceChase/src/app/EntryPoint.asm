INCLUDE "include/hardware.inc"
INCLUDE "include/charmap.inc"

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
    ld [rLCDC], a

    ; Reset variables
    xor a
    ld [ActiveBank], a

    ld [Menu.Selector], a
    ld [Menu.Items], a

    ld [sCurKeys], a
    ld [sNewKeys], a
    ld [eCurKeys], a
    ld [eNewKeys], a

    ld a, %00000101
    ld [rTAC], a

    call Actions_ResetActions

    ; Clear the OAM
    ld d, 0
    ld hl, _OAMRAM
    ld bc, 160
    call Memory_Fill

    ld a, BANK(SFX)
    ld [sMOL_Bank], a
    ld hl, SFX
    call sMOL_init

    ld a, BANK(MitA)
    ld [hUGE_Bank], a
    ld hl, MitA
    call hUGE_init

    call Audio_TurnOffAll

    ; Load basic stuff into memory
    call UI_Load

    call Int_InitInterrupts

    ld a, "T"
    ld [CurrentState], a
    jp ChangeState