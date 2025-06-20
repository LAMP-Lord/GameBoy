INCLUDE "include/hardware.inc"
INCLUDE "include/charmap.inc"
INCLUDE "include/input_macros.inc"
INCLUDE "include/sprite_macros.inc"

SECTION "Intro       - Graphics", ROMX, BANK[$1]



SECTION "Intro       - Functions", ROMX, BANK[$1]

Intro_EntryPoint::
    ld a, "T"
    ld [CurrentState], a
    jp ChangeState