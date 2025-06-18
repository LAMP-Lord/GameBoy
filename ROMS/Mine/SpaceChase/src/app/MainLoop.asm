INCLUDE "include/hardware.inc"

SECTION "Main Loop     - Variables", WRAM0

CurrentState:: ds 1
RandomByte: ds 1

SECTION "Main Loop     - Main", ROM0

; "Random" 8-Bit number
; Or as close as i can get
GenerateSeed::
    ld a, [rDIV]
    ld c, a

    ld a, [RandomByte]
    xor c
    ld c, a

    ld a, [rTIMA]
    xor c
    ld c, a

    add $1B
    rlca
    xor $C3
    swap a
    ld l, a

    ld a, [rLY]
    ld c, a

    ld a, [rDIV]
    xor c
    add l
    xor $5E
    rrca
    ld h, a

    ld [$9800], a
    ld a, l
    ld [$9801], a
    ret

StateHandler::
    jp StateHandler