INCLUDE "hardware.inc"

SECTION "App         - HRAM Variables", HRAM

ActiveBank:: ds 1
FrameCounter:: ds 1
OAM_DMA_Code:: ds 10

SECTION "App         - WRAM Variables", WRAM0

RandomByte: ds 1

SECTION "App         - OAM_DMA DMA Source", WRAM0[$C200]

OAM_DMA:: ds $9F

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

    call OAM_DMA_Code

    ret

App_WaitFrames::
    call App_EndOfFrame
    ldh a, [FrameCounter]
    dec a
    ldh [FrameCounter], a
    jr nz, App_WaitFrames
    ret

App_ResetOAM::
    ld d, 0
    ld hl, OAM_DMA
    ld bc, 160
    call Memory_Fill
    ret

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
    call App_ResetOAM

    call Audio_TurnOffAll
    ret

; OAM_DMA DMA Transfer
App_SetUpOAMDMA::
    ld de, Run_OAM_DMA
    ld hl, OAM_DMA_Code
    ld bc, Run_OAM_DMA_End - Run_OAM_DMA
    call Memory_Copy
    ret

Run_OAM_DMA:
    ld a, HIGH(OAM_DMA)
    ldh [$FF46], a
    ld a, 40
.wait
    dec a
    jr nz, .wait
    ret
Run_OAM_DMA_End:

; Extras
NopFunction::
    ret
CallHL::
    jp hl