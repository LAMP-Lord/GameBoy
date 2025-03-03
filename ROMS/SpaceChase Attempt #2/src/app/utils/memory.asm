INCLUDE "include/hardware.inc"

SECTION "Util - Memory Functions", ROM0

Memory_Copy::
    ld a, [de]
    ld [hli], a

    inc de
    dec bc

    ld a, b
    or c
    jp nz, Memory_Copy
    ret