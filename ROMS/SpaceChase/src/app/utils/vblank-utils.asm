INCLUDE "include/hardware.inc"

SECTION "VBlankVariables", WRAM0

wVBlankCount:: db

SECTION "VBlankFunctions", ROM0

WaitForVBlank::
    call Wait_InVBlankStart

    ld a, [wVBlankCount]
    dec a
    ld [wVBlankCount], a

    jp nz, WaitForVBlank

    ld a, 1
    ld [wVBlankCount], a

    ret

    ; Wait until we’re not in VBlank
Wait_NotInVBlank:
    ld   a, [rLY]      ; load current LY value
    cp   144             ; compare with 144
    jr   c, Wait_InVBlankStart  ; if LY < 144, jump to wait for VBlank start
    jr   Wait_NotInVBlank

Wait_InVBlankStart:
    ; Wait until VBlank starts (LY >= 144)
Wait_VBlank:
    ld   a, [rLY]      ; load current LY value
    cp   144             ; compare with 144
    jr   c, Wait_VBlank   ; if LY < 144, keep waiting
    ret