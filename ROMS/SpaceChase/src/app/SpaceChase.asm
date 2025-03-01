INCLUDE "include/hardware.inc"

SECTION "GameVariables", WRAM0

wGameState:: db
wLastKeys:: db
wCurKeys:: db
wNewKeys:: db

SECTION "Header", ROM0[$100]

    jp EntryPoint

    ds $150 - @, 0 ; Make room for the header

EntryPoint:
    ld hl, song
    call hUGE_init

    ; Turn the LCD off
    xor a
    ld [rLCDC], a

    ; Load our common text font into VRAM
    call LoadTextFontIntoVRAM

    ; Turn the LCD on
    ld a, LCDCF_ON  | LCDCF_BGON|LCDCF_OBJON | LCDCF_OBJ16 | LCDCF_WINON | LCDCF_WIN9C00
    ld [rLCDC], a

Loop:
    jp NextGameState
    jp Loop