INCLUDE "include/hardware.inc"

SECTION "Scream Lib - Variables", WRAM0



SECTION "Scream Lib - Driver", ROM0

SL_PlaySFX::
    ld a, $1
    ld [$2000], a

    ld a, [SSFX_Lazer]
    halt
    jp SL_PlaySFX

SECTION "Scream Lib - SFX Data", ROMX, BANK[$1]
SSFX_Lazer:
db $40