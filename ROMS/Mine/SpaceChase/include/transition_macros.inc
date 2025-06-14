MACRO FADE_OUT
    call App_EndOfFrame
    call App_EndOfFrame
    call App_EndOfFrame
    call App_EndOfFrame
    call App_EndOfFrame
    ld a, %10_01_00_00
    ld [rBGP], a
    ld a, %10_01_00_00
    ld [rOBP0], a
    ld a, %10_01_00_00
    ld [rOBP1], a
    call App_EndOfFrame
    call App_EndOfFrame
    call App_EndOfFrame
    call App_EndOfFrame
    call App_EndOfFrame
    ld a, %01_00_00_00
    ld [rBGP], a
    ld a, %01_00_00_00
    ld [rOBP0], a
    ld a, %01_00_00_00
    ld [rOBP1], a
    call App_EndOfFrame
    call App_EndOfFrame
    call App_EndOfFrame
    call App_EndOfFrame
    call App_EndOfFrame
    ld a, %00_00_00_00
    ld [rBGP], a
    ld a, %00_00_00_00
    ld [rOBP0], a
    ld a, %00_00_00_00
    ld [rOBP1], a

    ld a, LCDCF_OFF
    ld [rLCDC], a
ENDM

MACRO FADE_IN
    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_BG8800 | LCDCF_BG9800 | LCDCF_OBJON
    ld [rLCDC], a

    call App_EndOfFrame
    call App_EndOfFrame
    call App_EndOfFrame
    call App_EndOfFrame
    call App_EndOfFrame
    ld a, %01_00_00_00
    ld [rBGP], a
    ld a, %01_00_00_00
    ld [rOBP0], a
    ld a, %01_00_00_00
    ld [rOBP1], a
    call App_EndOfFrame
    call App_EndOfFrame
    call App_EndOfFrame
    call App_EndOfFrame
    call App_EndOfFrame
    ld a, %10_01_00_00
    ld [rBGP], a
    ld a, %10_01_00_00
    ld [rOBP0], a
    ld a, %10_01_00_00
    ld [rOBP1], a
    call App_EndOfFrame
    call App_EndOfFrame
    call App_EndOfFrame
    call App_EndOfFrame
    call App_EndOfFrame
    ld a, %11_10_01_00
    ld [rBGP], a
    ld a, %11_10_01_00
    ld [rOBP0], a
    ld a, %11_10_01_00
    ld [rOBP1], a
ENDM