INCLUDE "hardware.inc"

SECTION "App         - HRAM Variables", HRAM

CGBFlag:: ds 1

; Dont even ask
BankCache:: ds 1
ActiveBank:: ds 1

FrameCounter:: ds 1
OAM_DMA_Code:: ds 10

SECTION "App         - WRAM Variables", WRAM0

RandomByte: ds 1
RandomSeeded:: ds 2
RandomNumber:: ds 1

BankNumber:: ds 1
FunctionPointer:: ds 2

CallFunction:: ds 3

SECTION "App         - OAM_DMA DMA Source", WRAM0[$C200]

OAM_DMA:: ds $9F

SECTION "App         - Functions", ROM0

App_CallFromBank::
    ld a, [BankNumber]
    ld [$2000], a
    ldh [ActiveBank], a

    ld a, [FunctionPointer]
    ld [CallFunction+1], a
    ld a, [FunctionPointer+1]
    ld [CallFunction+2], a
    
    call CallFunction

.return
    ldh a, [BankCache]
    ld [$2000], a
    ldh [ActiveBank], a
    ret

; "Random" 16-Bit number
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

; "Random" 8-Bit number
; Uses a LCG algorithm to modify the seed continuously
App_GenerateRandomSeeded::
    ld a, [RandomSeeded]
    add $1B
    rlca
    xor $C3
    swap a
    ld b, a
    add a
    add b
    inc a
    ld [RandomSeeded], a

    ld a, [RandomSeeded + 1]
    ld b, a
    add a
    add $B2
    add b
    inc a
    ld [RandomSeeded + 1], a
    ret

; "Random" 8-Bit number
; Or as close as i can get
App_GenerateRandom::
    ld a, [rDIV]
    ld c, a

    ld a, [RandomByte]
    xor c
    ld c, a

    ld a, [rTIMA]
    xor c
    ld c, a

    ld a, [rLY]
    xor c

    add $1B
    rlca
    xor $C3
    swap a
    rlca
    ld [RandomNumber], a
    ret

App_EndOfFrame::
    ldh a, [BankCache]
    ld [$2000], a

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

    call App_ResetOAM

    ld d, 0
    ld hl, _SCRN0
    ld bc, _SCRN1 - _SCRN0
    call Memory_Fill

    ld d, 0
    ld hl, _SCRN1
    ld bc, _SCRN1 - _SCRN0
    call Memory_Fill

    ld d, 0
    ld hl, _VRAM8000
    ld bc, _SCRN0 - _VRAM8000
    call Memory_Fill

    call Actions_ResetActions
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