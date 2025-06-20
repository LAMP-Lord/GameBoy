INCLUDE "include/hardware.inc"
INCLUDE "include/charmap.inc"
INCLUDE "include/input_macros.inc"
INCLUDE "include/sprite_macros.inc"

SECTION "Starmap     - Graphics", ROMX, BANK[$2]



SECTION "Starmap     - Functions", ROMX, BANK[$2]

Starmap_EntryPoint::
    ld a, "T"
    ld [CurrentState], a
    jp ChangeState