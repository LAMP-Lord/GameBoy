INCLUDE "hardware.inc"

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
    call Input_Query
    call Actions_ProcessActions

    call sMOL_dosound
    call hUGE_dosound
    
    ldh a, [ActiveBank]
    ld [$2000], a

    halt

    ret

App_WaitFrames::
    call App_EndOfFrame
    ldh a, [FrameCounter]
    dec a
    ldh [FrameCounter], a
    jr nz, App_WaitFrames
    ret

NopFunction::
    ret

CallHL::
    jp hl

App_Reset::
    ; Reset variables
    xor a
    ld [rTAC], a

    ldh [ActiveBank], a
    ldh [FrameCounter], a

    ldh [rSCX], a
    ldh [rSCY], a

    ld [Menu.Selector], a
    ld [Menu.Items], a

    ldh [sCurKeys], a
    ldh [sNewKeys], a
    ldh [sOldKeys], a
    ldh [eCurKeys], a
    ldh [eNewKeys], a
    ldh [eOldKeys], a

    call Actions_ResetActions

    ; Clear the OAM
    ld d, 0
    ld hl, _OAMRAM
    ld bc, 160
    call Memory_Fill

    call Audio_TurnOffAll