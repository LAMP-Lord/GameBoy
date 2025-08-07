INCLUDE "hardware.inc"
INCLUDE "charmap.inc"

SECTION "Starmap - Helper Functions", ROMX, BANK[$3]

SM_AdvanceSystem::
    ; Reset ship position
    xor a
    ld [Save.Location], a

    ; Go to new system
    ld a, [Save.System]
    inc a
    ld [Save.System], a

    ; Slightly increase difficulty
    ld a, [Save.Difficulty]
    ld b, a
    ld a, [Save.Difficulty + 1]
    ld c, a
    inc bc
    ld a, b
    ld [Save.Difficulty], a
    ld a, c
    ld [Save.Difficulty + 1], a
    ret

SM_AdvanceSector::
    ; Deliver Cargo
    ; Get New Cargo

    ; Reset ship position
    xor a
    ld [Save.Location], a

    ; Reset system counter
    ld a, 1
    ld [Save.System], a

    ; Go to new sector
    ld a, [Save.Sector]
    ld b, a
    ld a, [Save.Sector + 1]
    ld c, a
    inc bc
    ld a, b
    ld [Save.Sector], a
    ld a, c
    ld [Save.Sector + 1], a

    ; Slightly increase difficulty
    ld a, [Save.Difficulty]
    ld b, a
    ld a, [Save.Difficulty + 1]
    ld c, a
    inc bc
    ld a, b
    ld [Save.Difficulty], a
    ld a, c
    ld [Save.Difficulty + 1], a
    ret