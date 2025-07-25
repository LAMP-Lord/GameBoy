;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; It's straight from: https://gbdev.io/gb-asm-tutorial/part2/input.html
; In their words (paraphrased): reading player input for gameboy is NOT a trivial task
; So it's best to use some tested code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

include "hardware.inc"

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
  ldh a, [sCurKeys]
  ldh [sOldKeys], a
  ldh a, [eCurKeys]
  ldh [eOldKeys], a

  ; Poll standard inputs (A, B, Select, Start, D-pad)
  ld a, P1F_GET_BTN
  call .onenibble
  ld b, a

  ld a, P1F_GET_DPAD
  call .onenibble
  swap a
  xor a, b
  ldh [sCurKeys], a

  ld a, P1F_GET_NONE
  ldh [rP1], a

  ; Get Pressed and Dropped Keys
  ldh a, [sCurKeys]
  ld b, a
  ldh a, [sOldKeys]
  cpl
  and b
  ldh [sNewKeys], a

  ldh a, [sOldKeys]
  ld b, a
  ldh a, [sCurKeys]
  cpl 
  and b
  ldh [sDrpKeys], a

  ; Poll extra inputs (X, Y, Triggers)
  ld a, P1F_GET_BTN
  call .onenibble_extra
  ld b, a

  ld a, P1F_GET_DPAD
  call .onenibble_extra
  swap a
  xor a, b
  ldh [eCurKeys], a

  ld a, P1F_GET_NONE
  ldh [rPE], a

  ; Get Pressed and Dropped Keys
  ldh a, [eCurKeys]
  ld b, a
  ldh a, [eOldKeys]
  cpl
  and b
  ldh [eNewKeys], a

  ldh a, [eOldKeys]
  ld b, a
  ldh a, [eCurKeys]
  cpl 
  and b
  ldh [eDrpKeys], a

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