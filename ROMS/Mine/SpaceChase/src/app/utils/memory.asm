INCLUDE "include/hardware.inc"

SECTION "Memory     - Memory Functions", ROM0

Memory_Copy::
    ld a, [de]
    ld [hli], a

    inc de
    dec bc

    ld a, b
    or c
    jr nz, Memory_Copy
    ret

Memory_Fill::
    ld a, d
    ld [hli], a
    dec bc
    ld a, b
    or c
    jr nz, Memory_Fill
    ret