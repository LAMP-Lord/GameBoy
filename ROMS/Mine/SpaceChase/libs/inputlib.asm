;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; It's straight from: https://gbdev.io/gb-asm-tutorial/part2/input.html
; In their words (paraphrased): reading player input for gameboy is NOT a trivial task
; So it's best to use some tested code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

include "include/hardware.inc"

SECTION "Input       - Input Variables", HRAM

sNewKeys:: db ; (Standard) Pressed this frame
sCurKeys:: db ; (Standard) Held this frame
sOldKeys:: db ; (Standard) Held last frame
sDrpKeys:: db ; (Standard) Dropped this frame

eNewKeys:: db ; (Extra) Pressed this frame
eCurKeys:: db ; (Extra) Held this frame
eOldKeys:: db ; (Extra) Held last frame
eDrpKeys:: db ; (Extra) Dropped this frame

SECTION "Input       - Main", ROM0

Input_Query::
  ; Update old values
  ld a, [sCurKeys]
  ld [sOldKeys], a
  ld a, [eCurKeys]
  ld [eOldKeys], a

  ; Poll standard inputs (A, B, Select, Start, D-pad)
  ld a, P1F_GET_BTN
  call .onenibble
  ld b, a

  ld a, P1F_GET_DPAD
  call .onenibble
  swap a
  xor a, b
  ld [sCurKeys], a

  ld a, P1F_GET_NONE
  ldh [rP1], a

  ; Get Pressed and Dropped Keys
  ld a, [sCurKeys]
  ld b, a
  ld a, [sOldKeys]
  cpl
  and b
  ld [sNewKeys], a

  ld a, [sOldKeys]
  ld b, a
  ld a, [sCurKeys]
  cpl 
  and b
  ld [sDrpKeys], a

  ; Poll extra inputs (X, Y, Triggers)
  ld a, P1F_GET_BTN
  call .onenibble_extra
  ld b, a

  ld a, P1F_GET_DPAD
  call .onenibble_extra
  swap a
  xor a, b
  ld [eCurKeys], a

  ld a, P1F_GET_NONE
  ldh [rPE], a

  ; Get Pressed and Dropped Keys
  ld a, [eCurKeys]
  ld b, a
  ld a, [eOldKeys]
  cpl
  and b
  ld [eNewKeys], a

  ld a, [eOldKeys]
  ld b, a
  ld a, [eCurKeys]
  cpl 
  and b
  ld [eDrpKeys], a

  ret

.onenibble
  ldh [rP1], a ; switch the key matrix
  call .knownret ; burn 10 cycles calling a known ret
  ldh a, [rP1] ; ignore value while waiting for the key matrix to settle
  ldh a, [rP1]
  ldh a, [rP1] ; this read counts
  or a, $F0 ; A7-4 = 1; A3-0 = unpressed keys
  ret
.onenibble_extra
  ldh [rPE], a ; switch the key matrix
  call .knownret ; burn 10 cycles calling a known ret
  ldh a, [rPE] ; ignore value while waiting for the key matrix to settle
  ldh a, [rPE]
  ldh a, [rPE] ; this read counts
  or a, $F0 ; A7-4 = 1; A3-0 = unpressed keys
  ret
.knownret
  ret