INCLUDE "include/hardware.inc"

SECTION "Input      - Input Variables", HRAM

; Standard Keys
sNewKeys:: db
sCurKeys:: db
sOldKeys:: db

; Extra Keys
eNewKeys:: db
eCurKeys:: db
eOldKeys:: db

; Function Variable
WaitKeys:: db

SECTION "Input - Press Action Table", WRAM0

PressActionTable::
PressAction_A:: ds 2
PressAction_B:: ds 2
PressAction_Select:: ds 2
PressAction_Start:: ds 2
PressAction_Right:: ds 2
PressAction_Left:: ds 2
PressAction_Up:: ds 2
PressAction_Down:: ds 2
PressAction_X:: ds 2
PressAction_Y:: ds 2
PressAction_L1:: ds 2
PressAction_R1:: ds 2
PressAction_L2:: ds 2
PressAction_R2:: ds 2
PressActionTableEnd:

SECTION "Input - Release Action Table", WRAM0

ReleaseActionTable::
ReleaseAction_A:: ds 2
ReleaseAction_B:: ds 2
ReleaseAction_Select:: ds 2
ReleaseAction_Start:: ds 2
ReleaseAction_Right:: ds 2
ReleaseAction_Left:: ds 2
ReleaseAction_Up:: ds 2
ReleaseAction_Down:: ds 2
ReleaseAction_X:: ds 2
ReleaseAction_Y:: ds 2
ReleaseAction_L1:: ds 2
ReleaseAction_R1:: ds 2
ReleaseAction_L2:: ds 2
ReleaseAction_R2:: ds 2
ReleaseActionTableEnd:

SECTION "Input - Utils", ROM0

Input_ProcessActions::
    call Input_ProcessPresses
    call Input_ProcessReleases
    ret

Input_ProcessPresses:
    ld   hl, PressActionTable
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
    ld   a, b
    rra
    ld   b, a

    dec  d
    jr   nz, .loop

    ret

Input_ProcessReleases:
    ld   hl, ReleaseActionTable

    ld   a, [sOldKeys]
    ld   b, a
    ld   a, [sCurKeys]
    cpl                 ; invert current
    and b              ; old & ~current = released bits
    ld   c, a

    ld   a, [eOldKeys]
    ld   b, a
    ld   a, [eCurKeys]
    cpl
    and b
    ld   b, a           ; B = released extra keys

    ld   d, 14          ; loop count

.loop
    ; same structure as Input_ProcessActions
    ld   a, c
    rra
    ld   c, a

    ld   e, [hl]
    inc  hl
    ld   d, [hl]
    inc  hl

    jr   nc, .noCall
    push bc
    push hl
    ld   h, d
    ld   l, e
    call CallHL
    pop  hl
    pop  bc

.noCall
    ld   a, b
    rra
    ld   b, a

    dec  d
    jr   nz, .loop

    ret

CallHL:
    jp   hl


Input_ResetActionTable::
    call Input_ResetPressActionTable
    call Input_ResetReleaseActionTable
    ret

Input_ResetPressActionTable::
    ld hl, PressActionTable
    ld c, PressActionTableEnd - PressActionTable
.loop
    ld a, LOW(NopFunction)
    ld [hl+], a
    dec c
    ld a, HIGH(NopFunction)
    ld [hl+], a
    dec c

    jr nz, .loop
    ret

Input_ResetReleaseActionTable::
    ld hl, ReleaseActionTable
    ld c, ReleaseActionTableEnd - ReleaseActionTable
.loop
    ld a, LOW(NopFunction)
    ld [hl+], a
    dec c
    ld a, HIGH(NopFunction)
    ld [hl+], a
    dec c

    jr nz, .loop
    ret

NopFunction::
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