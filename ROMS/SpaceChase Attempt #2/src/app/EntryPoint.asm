INCLUDE "include/hardware.inc"

SECTION "Header", ROM0[$100]

    jp EntryPoint

    ds $150 - @, 0

SECTION "Entry Point", ROM0

EntryPoint:
    ld a, LCDCF_OFF
    ld [rLCDC], a

    ld hl, song
    call hUGE_init

    ld a, %00_01_10_11
    ld [rBGP], a

    call Text_LoadFont

    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON | LCDCF_OBJ8 | LCDCF_WINON | LCDCF_WIN9C00
    ld [rLCDC], a