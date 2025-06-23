INCLUDE "hardware.inc"
INCLUDE "charmap.inc"
INCLUDE "macros/input_macros.inc"
INCLUDE "macros/sprite_macros.inc"

SECTION "Intro       - Graphics", ROMX, BANK[$1]



SECTION "Intro       - Functions", ROMX, BANK[$1]

Intro_EntryPoint::
    ld a, "T"
    ld [CurrentState], a
    jp ChangeState