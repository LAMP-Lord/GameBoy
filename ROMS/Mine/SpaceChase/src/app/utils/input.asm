INCLUDE "include/hardware.inc"

SECTION "Input      - Input Variables", HRAM

wLastKeys:: db
wCurKeys:: db
wNewKeys:: db

nLastKeys:: db
nCurKeys:: db
nNewKeys:: db

mWaitKey:: db

OnCart:: db

SECTION "InputUtils", ROM0

WaitForKeyFunction::

    ; Save our original value
    push bc

    
WaitForKeyFunction_Loop:

    ; save the keys last frame
    ld a, [wCurKeys]
    ld [wLastKeys], a
    
    ; This is in input.asm
    ; It's straight from: https://gbdev.io/gb-asm-tutorial/part2/input.html
    ; In their words (paraphrased): reading player input for gameboy is NOT a trivial task
    ; So it's best to use some tested code
    call Input
    
    ld a, [mWaitKey]
    ld b, a
    ld a, [wCurKeys]
    and b
    jp z, WaitForKeyFunction_NotPressed
    
    ld a, [wLastKeys]
    and b
    jp nz, WaitForKeyFunction_NotPressed

    ; restore our original value
    pop bc

    call SFX_Lazer

    ret


WaitForKeyFunction_NotPressed:

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Wait a small amount of time
    ; Save our count in this variable

    ; Call our function that performs the code
    call Int_WaitForVBlank
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    jp WaitForKeyFunction_Loop