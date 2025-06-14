INCLUDE "include/hardware.inc"

SECTION "Entry Point", ROM0

EntryPoint::
    ld a, %00_00_00_00
    ld [rBGP], a
    ld a, %00_00_00_00
    ld [rOBP0], a
    ld a, %00_00_00_00
    ld [rOBP1], a
    ld a, LCDCF_OFF
    ld [rLCDC], a

    ; Initialize input variables
    xor a
    ld [ActiveBank], a
    ld [sCurKeys], a
    ld [sNewKeys], a
    ld [eCurKeys], a
    ld [eNewKeys], a
    call Input_ResetActions

    ; Clear the OAM
    ld d, 0
    ld hl, _OAMRAM
    ld bc, 160
    call Memory_Fill

    ; Set up audio
    ld a, BANK(SFX)
    ld [sMOL_Bank], a
    ld hl, SFX
    call sMOL_init
    call Audio_ResetChannels

    ; Load basic stuff into memory
    call UI_Load

    ld a, BANK(TitleScreen_Animation)
    ld [$2000], a
    ld [ActiveBank], a
    jp TitleScreen_Animation