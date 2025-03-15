INCLUDE "include/hardware.inc"

SECTION "VBlankVariables", WRAM0

wVBlankCount:: db

SECTION "VBlankFunctions", ROM0

WaitForOneVBlank::

    ; Wait a small amount of time
    ; Save our count in this variable
    ld a, 1
    ld [wVBlankCount], a

; WaitForVBlankFunction::
; WaitForVBlankFunction_Loop::

;     ld a, [rLY] ; Copy the vertical line to a
;     cp 144 ; Check if the vertical line (in a) is 0
;     jp c, WaitForVBlankFunction_Loop ; A conditional jump. The condition is that 'c' is set, the last operation overflowed

;     ld a, [wVBlankCount]
;     sub 1
;     ld [wVBlankCount], a

;     call hUGE_dosound

;     ret z

; WaitForVBlankFunction_Loop2::

;     ld a, [rLY] ; Copy the vertical line to a
;     cp 144 ; Check if the vertical line (in a) is 0
;     jp nc, WaitForVBlankFunction_Loop2 ; A conditional jump. The condition is that 'c' is set, the last operation overflowed

;     jp WaitForVBlankFunction_Loop


; WaitForVBlankFunction::
;     ; Wait for LY >= 144
; .waitTop:
;     ld a, [rLY]
;     cp 144
;     jr c, .waitTop  ; loop until we hit line 144 (start of VBlank)

;     ld a, [wVBlankCount]
;     sub 1
;     ld [wVBlankCount], a

;     ; Now we are at VBlank, call sound once
;     call hUGE_dosound

;     ; If you need to wait for LY < 144 (to mark end of VBlank),
;     ; do it *once*, not in a multi-call loop.
; .waitBottom:
;     ld a, [rLY]
;     cp 144
;     jr nc, .waitBottom

;     ret