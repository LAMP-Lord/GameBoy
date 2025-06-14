INCLUDE "include/hardware.inc"

SECTION "Input      - Input Variables", HRAM

; Standard Keys
sNewKeys:: db
sCurKeys:: db
sOldKeys:: db
sDrpKeys:: db

; Extra Keys
eNewKeys:: db
eCurKeys:: db
eOldKeys:: db
eDrpKeys:: db

; Function Variable
WaitKeys:: db

SECTION "Input       - Action Table", WRAM0

ActionTable::
Action_A:: ds 2
Action_B:: ds 2
Action_Select:: ds 2
Action_Start:: ds 2
Action_Right:: ds 2
Action_Left:: ds 2
Action_Up:: ds 2
Action_Down:: ds 2
Action_X:: ds 2
Action_Y:: ds 2
Action_L1:: ds 2
Action_R1:: ds 2
Action_L2:: ds 2
Action_R2:: ds 2
; Extra Action Slots Here
ActionTableEnd:

SECTION "Input       - Utils", ROM0

Input_ProcessActions::
    ld   hl, ActionTable
    ld   b, (ActionTableEnd - ActionTable) / 2

.loop
    ld   e, [hl]
    inc hl
    ld   d, [hl]
    inc hl

    push bc
    push hl
    ld   h, d
    ld   l, e
    call CallHL
    pop  hl
    pop  bc

    dec  b
    jr   nz, .loop

    ret

CallHL:
    jp   hl


Input_ResetActionTable::
    ld hl, ActionTable
    ld c, ActionTableEnd - ActionTable
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

; Input_WaitForKeyPress::
;     push bc

; .loop
;     ld a, [WaitKeys]
;     ld b, a

;     ld a, [sNewKeys]
;     and b
;     jr nz, .pressed

;     call Int_WaitForVBlank
;     jr .loop

; .pressed
;     pop bc
;     ret