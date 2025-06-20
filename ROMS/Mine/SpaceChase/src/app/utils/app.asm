INCLUDE "include/hardware.inc"

SECTION "App         - HRAM Variables", HRAM

ActiveBank:: ds 1
FrameCounter:: ds 1

SECTION "App         - WRAM Variables", WRAM0

RandomByte: ds 1

SECTION "App         - Functions", ROM0

; "Random" 8-Bit number
; Or as close as i can get
App_GenerateSeed::
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
    ld [Save.Seed + 1], a

    ld a, [rLY]
    ld c, a

    ld a, [rDIV]
    xor c
    add l
    xor $5E
    rrca
    ld h, a
    ld [Save.Seed], a

    ret

App_EndOfFrame::
    call sMOL_dosound
    call hUGE_dosound
    
    ld a, [ActiveBank]
    ld [$2000], a

    call Input_Query
    call Actions_ProcessActions

    halt

    ret

App_WaitFrames::
    call App_EndOfFrame
    ld a, [FrameCounter]
    dec a
    ld [FrameCounter], a
    jr nz, App_WaitFrames
    ret

NopFunction::
    ret