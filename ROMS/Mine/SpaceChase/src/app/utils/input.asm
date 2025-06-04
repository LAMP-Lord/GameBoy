INCLUDE "include/hardware.inc"

SECTION "Input      - Input Variables", HRAM

; Standard Keys
sNewKeys:: db
sCurKeys:: db

; Extra Keys
eNewKeys:: db
eCurKeys:: db

; Function Variable
WaitKeys:: db

; Used to determine if the device will use the extra inputs or not
OnCart:: db

SECTION "Input - Action Table", WRAM0

ActionTable::

ActionA:: ds 2
ActionB:: ds 2
ActionSelect:: ds 2
ActionStart:: ds 2

ActionRight:: ds 2
ActionLeft:: ds 2
ActionUp:: ds 2
ActionDown:: ds 2

ActionX:: ds 2
ActionY:: ds 2

ActionL1:: ds 2
ActionR1:: ds 2
ActionL2:: ds 2
ActionR2:: ds 2

ActionTableEnd:

SECTION "Input - Utils", ROM0

Input_ProcessActions::
    ld   hl, ActionTable
    ld   a, [eCurKeys]     ; high byte
    ld   b, a
    ld   a, [sCurKeys]     ; low  byte
    ld   c, a
    ld   d, 14             ; number of 2‑byte entries

.loop
    ;------ grab the next bit (bit‑0 of C) ------
    ld   a, c
    rra                    ; carry = that bit, C  >>= 1
    ld   c, a

    ;------ fetch the table pointer (always 2 bytes) ------
    ld   e, [hl]
    inc hl
    ld   d, [hl]          ; HL now points to next entry
    inc hl

    jr   nc, .noCall       ; if carry=0 → button is up, skip

    ;------ carry was 1 → call the routine ------
    push bc
    push hl
    ld   h, d
    ld   l, e
    call CallHL            ; indirect call (see stub below)
    pop  hl
    pop  bc

.noCall
    ;------ finish the 16‑bit shift (rotate B) ------
    ld   a, b
    rra                    ; pulls previous carry into bit‑7
    ld   b, a

    ;------ loop control ------
    dec  d
    jr   nz, .loop
    ret

;------------------------------------------------------
; Tiny helper that lets us "CALL (HL)"
;------------------------------------------------------
CallHL::
    jp   hl

Input_ResetActionTable::
    ld hl, ActionTable
    ld c, ActionTableEnd - ActionTable
.loop
    ld a, LOW(Input_NopFunction)
    ld [hl+], a
    dec c
    ld a, HIGH(Input_NopFunction)
    ld [hl+], a
    dec c

    jr nz, .loop
    ret

Input_NopFunction::
    ret

Input_WaitForKeyPress::
    push bc

.loop
    ld a, [WaitKeys]
    ld b, a

    ld a, [sNewKeys]
    and b
    jr nz, .pressed

    call Int_WaitForVBlank
    jr .loop

.pressed
    pop bc
    ret