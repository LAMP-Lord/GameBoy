INCLUDE "hardware.inc"

EXPORT Actions.DrawAddress
EXPORT Actions.A
EXPORT Actions.B
EXPORT Actions.Select
EXPORT Actions.Start
EXPORT Actions.Right
EXPORT Actions.Left
EXPORT Actions.Up
EXPORT Actions.Down
EXPORT Actions.X
EXPORT Actions.Y
EXPORT Actions.L1
EXPORT Actions.R1
EXPORT Actions.L2
EXPORT Actions.R2

SECTION "Utilities - Actions - WRAM (Action Table)", WRAM0

; This cool utility stores 2 byte addresses per input.
; The function "ProcessActions" will call all addresses
; every frame with no exceptions. It's pretty nifty.
Actions::
    .DrawAddress ds 2
    .A ds 2
    .B ds 2
    .Select ds 2
    .Start ds 2
    .Right ds 2
    .Left ds 2
    .Up ds 2
    .Down ds 2
    .X ds 2
    .Y ds 2
    .L1 ds 2
    .R1 ds 2
    .L2 ds 2
    .R2 ds 2
ActionsEnd::

SECTION "Utilities - Actions - Main", ROM0

Actions_ProcessActions::
    ld   hl, Actions
    ld   b, (ActionsEnd - Actions) / 2

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


Actions_ResetActions::
    ld hl, Actions
    ld c, ActionsEnd - Actions
    ld d, LOW(NopFunction)
    ld e, HIGH(NopFunction)
.loop
    ld a, d
    ld [hl+], a
    dec c
    ld a, e
    ld [hl+], a
    dec c

    jr nz, .loop
    ret