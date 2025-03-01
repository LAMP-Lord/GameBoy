INCLUDE "include/hardware.inc"

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
    halt

    ; Decrement VBlank counter
    ld a, [wVBlankCount]
    sub 1
    ld [wVBlankCount], a
    ret z
    jp WaitForVBlankFunction_Loop  ; Loop again if necessary