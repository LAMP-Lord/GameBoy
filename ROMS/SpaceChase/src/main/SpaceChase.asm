INCLUDE "include/hardware.inc"

SECTION "GameVariables", WRAM0

wLastKeys:: db
wCurKeys:: db
wNewKeys:: db

SECTION "Header", ROM0[$100]

    jp EntryPoint

    ds $150 - @, 0 ; Make room for the header

EntryPoint:
    ld hl, song
    call hUGE_init

Loop:
    call doSound
    jp Loop


doSound:
    call WaitForOneVBlank
    call hUGE_dosound
    ret


    
SECTION "VBlankVariables", WRAM0

wVBlankCount:: db

SECTION "VBlankFunctions", ROM0

WaitForOneVBlank::

    ; Wait a small amount of time
    ; Save our count in this variable
    ld a, 1
    ld [wVBlankCount], a

WaitForVBlankFunction::

WaitForVBlankFunction_Loop::

    ld a, [rIF]  ; Load interrupt flags
    and 1        ; Check if VBlank interrupt is set
    jp c, WaitForVBlankFunction_Loop ; A conditional jump. The condition is that 'c' is set, the last operation overflowed

    xor a
    ld [rIF], a

    ld a, [wVBlankCount]
    sub 1
    ld [wVBlankCount], a
    ret z

WaitForVBlankFunction_Loop2::

    ld a, [rIF]  ; Load interrupt flags
    and 1        ; Check if VBlank interrupt is set
    jp nc, WaitForVBlankFunction_Loop2 ; A conditional jump. The condition is that 'c' is set, the last operation overflowed

    xor a
    ld [rIF], a

    jp WaitForVBlankFunction_Loop