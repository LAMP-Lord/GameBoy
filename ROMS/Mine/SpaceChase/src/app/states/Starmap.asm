INCLUDE "hardware.inc"
INCLUDE "charmap.inc"
INCLUDE "macros/input_macros.inc"
INCLUDE "macros/sprite_macros.inc"

SECTION "Starmap     - Graphics", ROMX, BANK[$2]



SECTION "Starmap     - Functions", ROMX, BANK[$2]

Starmap_EntryPoint::
    ld a, "T"
    ld [CurrentState], a
    jp ChangeState