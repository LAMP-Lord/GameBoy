INCLUDE "hardware.inc"
INCLUDE "charmap.inc"
INCLUDE "macros/extra_macros.inc"

SECTION "App - Logos", ROM0

Logo:
    ; ARCOM
    .Pub INCBIN "generated/1bpp/publisher.1bpp"
    .PubEnd

    .PubPalette
    dw $0000, $0000, $0000, $0000 ; None/BG
    dw $085F, $0000, $0000, $0000 ; ARCOM Main
    dw $18C5, $0000, $0000, $0000 ; ARCOM TM
    .PubPaletteEnd

    ; KiwiDev
    .Dev INCBIN "generated/1bpp/developer.1bpp"
    .DevEnd

    .DevAttr
    db 10, 0
    db 7,  1

    .DevPalette
    dw $0000, $0000, $0000, $0000 ; None/BG
    dw $0FA4, $0000, $0000, $0000 ; KiwiDev Kiwi
    dw $3660, $0000, $0000, $0000 ; KiwiDev Text
    .DevPaletteEnd
    


SECTION "App - Entry Point", ROM0

EntryPoint::
    ; Console type
    ldh [ConsoleFlag], a

    ; Clear Screen
    ld a, %00_00_00_00
    ld [rBGP], a
    ld a, %00_00_00_00
    ld [rOBP0], a
    ld a, %00_00_00_00
    ld [rOBP1], a
    ld a, LCDCF_OFF
    ldh [rLCDC], a

    ld sp, $FFFE

	call Music_ARCOM
    call Audio_TurnOffAll

    ld a, $C3
    ld [CallFunction], a

    call App_SetUpOAMDMA

    call App_Reset
    call Int_InitInterrupts
    
    ; Run Logo Sequence
    ; call Logos

    ld a, "M"
    ld [CurrentState], a
    jp ChangeState
    
Logos:
    call LoadARCOM

    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_BLK21
    ldh [rLCDC], a

    call Music_ARCOM
    call UI_FadeIn

    WAIT_FRAMES 100

    ld d, $FF
    ld hl, FadeIn_Target
    ld bc, FadeIn_TargetEnd - FadeIn_Target
    call Memory_Fill
    call UI_FadeOut

    ld a, LCDCF_OFF
    ldh [rLCDC], a

    call LoadKiwiDev
    call Audio_TurnOffAll

    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_BLK21
    ldh [rLCDC], a

    WAIT_FRAMES 10

    call Music_KiwiDev
    call UI_FadeIn

    WAIT_FRAMES 100

    ld d, $FF
    ld hl, FadeIn_Target
    ld bc, FadeIn_TargetEnd - FadeIn_Target
    call Memory_Fill
    call UI_FadeOut



LoadARCOM:
    ld de, Logo.Pub
    ld hl, $9000
    ld bc, Logo.PubEnd - Logo.Pub
    call UI_DecompressCopy

    ld b, 15
    ld c, $0
    ld hl, _SCRN0 + $30 * 4 + 3
    ld de, (Logo.PubEnd - Logo.Pub) / 2
    call UI_BasicTilemap

    ld de, Logo.PubPalette
    ld hl, FadeIn_Target
    ld bc, Logo.PubPaletteEnd - Logo.PubPalette
    call Memory_Copy

    ldh a, [ConsoleFlag]
    cp BOOTUP_A_CGB
    jr nz, .dmg
    call .ON
.dmg
    ret

.ON
    ld a, 1
    ldh [rVBK], a
    ld hl, _SCRN0 + $30 * 4 + 3
    ld b, 15
    ld a, 2
    call .loop
    ld c, 4
    ld hl, _SCRN0 + $30 * 4 + 3 + $20
.onloop
    ld b, 15
    ld a, 1
    call .loop

    ld de, 32 - 15
    add hl, de

    dec c
    jr nz, .onloop
    ld a, 0
    ldh [rVBK], a
    ret

.loop
    ld [hl+], a
    dec b
    ret z
    jr .loop

LoadKiwiDev:
    ld de, Logo.Dev
    ld hl, $9000
    ld bc, Logo.DevEnd - Logo.Dev
    call UI_DecompressCopy

    ld b, 17
    ld c, $0
    ld hl, _SCRN0 + $20 * 4 + 1
    ld de, (Logo.DevEnd - Logo.Dev) / 2
    call UI_BasicTilemap

    ld de, Logo.DevPalette
    ld hl, FadeIn_Target
    ld bc, Logo.DevPaletteEnd - Logo.DevPalette
    call Memory_Copy

    ldh a, [ConsoleFlag]
    cp BOOTUP_A_CGB
    jr nz, .dmg
    call .ON
.dmg
    ret

.ON
    ld a, 1
    ldh [rVBK], a
    ld c, 9
    ld hl, _SCRN0 + $20 * 4 + 1
.onloop
    ld b, 10
    ld a, 1
    call .loop

    ld b, 7
    ld a, 2
    call .loop

    ld de, 32 - 17
    add hl, de

    dec c
    jr nz, .onloop
    ld a, 0
    ldh [rVBK], a
    ret

.loop
    ld [hl+], a
    dec b
    ret z
    jr .loop