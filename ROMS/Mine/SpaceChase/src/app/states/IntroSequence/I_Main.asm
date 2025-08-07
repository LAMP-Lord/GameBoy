INCLUDE "hardware.inc"
INCLUDE "charmap.inc"
INCLUDE "macros/input_macros.inc"
INCLUDE "macros/sprite_macros.inc"
INCLUDE "macros/extra_macros.inc"

SECTION "Intro - Main", ROMX, BANK[$2]

Intro_EntryPoint::
    ; Move down because i am a dumbass :p
    ld a, $8
    ldh [rSCY], a

    ; Music
    call Music_TEST

    ; GB / GBC
    ldh a, [ConsoleFlag]
    cp BOOTUP_A_CGB
    jr nz, .dmg

    ld de, UI_GBC.Font
    ld hl, $9000
    ld bc, UI_GBC.FontEnd - UI_GBC.Font 
    call Memory_Copy

    ; Off Screen Data
    ld a, BANK(I_Graphics_GBC_Off)
    ld [BankNumber], a

    PUT_ADDRESS Memory_Copy, FunctionPointer
    ld de, I_Graphics_GBC_Off.StaticData
    ld hl, $8000
    ld bc, I_Graphics_GBC_Off.StaticDataEnd - I_Graphics_GBC_Off.StaticData
    call App_CallFromBank

    ld de, I_Graphics_GBC_Off.TransData
    ld hl, $8400
    ld bc, I_Graphics_GBC_Off.TransDataEnd - I_Graphics_GBC_Off.TransData
    call App_CallFromBank

    ; Check Save Flag
    ld a, [ValidSave]
    cp 0
    jp z, I_GBC_NewGame
    jp I_GBC_Continue

.dmg
    ld de, UI_DMG.Font
    ld hl, $9000
    ld bc, UI_DMG.FontEnd - UI_DMG.Font 
    call Memory_Copy

    ; Off Screen Data
    ld a, BANK(I_Graphics_DMG_Off)
    ld [BankNumber], a

    PUT_ADDRESS Memory_Copy, FunctionPointer
    ld de, I_Graphics_DMG_Off.StaticData
    ld hl, $8000
    ld bc, I_Graphics_DMG_Off.StaticDataEnd - I_Graphics_DMG_Off.StaticData
    call App_CallFromBank

    ld de, I_Graphics_DMG_Off.TransData
    ld hl, $8400
    ld bc, I_Graphics_DMG_Off.TransDataEnd - I_Graphics_DMG_Off.TransData
    call App_CallFromBank

    ; Check Save Flag
    ld a, [ValidSave]
    cp 0
    jp z, I_DMG_NewGame
    jp I_DMG_Continue

; Main Functions

; Loops between the two frames of animation
ON_9800::
    SET_ACTION Actions.Up, ON_9C00
    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_BLK21 | LCDCF_BG9800 | LCDCF_OBJON
    ldh [rLCDC], a
    ret

ON_9C00::
    SET_ACTION Actions.Up, ON_9800
    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_BLK21 | LCDCF_BG9C00 | LCDCF_OBJON
    ldh [rLCDC], a
    ret

; Turns the CRT effect off
I_DMG_OFF::
    SET_ACTION Actions.Up, NopFunction
    
    ld a, LCDCF_OFF
    ldh [rLCDC], a

    ld a, BANK(I_Graphics_DMG_Off)
    ld [BankNumber], a

    PUT_ADDRESS Memory_CopyWithOffset, FunctionPointer
    ld a, -$40
    ld [MemOffset], a
    ld de, I_Graphics_DMG_Off.TransTile
    ld hl, _SCRN1
    ld bc, I_Graphics_DMG_Off.TransTileEnd - I_Graphics_DMG_Off.TransTile
    call App_CallFromBank

    ld a, -$80
    ld [MemOffset], a
    ld de, I_Graphics_DMG_Off.StaticTile
    ld hl, _SCRN0
    ld bc, I_Graphics_DMG_Off.StaticTileEnd - I_Graphics_DMG_Off.StaticTile
    call App_CallFromBank

    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_BLK01 | LCDCF_BG9C00 | LCDCF_OBJON
    ldh [rLCDC], a
    
    call App_EndOfFrame
    call App_EndOfFrame

    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_BLK01 | LCDCF_BG9800 | LCDCF_OBJON
    ldh [rLCDC], a

    ret

I_GBC_OFF::
    SET_ACTION Actions.Up, NopFunction
    
    ld a, LCDCF_OFF
    ldh [rLCDC], a

    ld a, BANK(I_Graphics_GBC_Off)
    ld [BankNumber], a

    PUT_ADDRESS Memory_Copy, FunctionPointer
    ld a, 1
    ldh [rVBK], a
    ld de, I_Graphics_GBC_Off.TransAttr
    ld hl, _SCRN1
    ld bc, I_Graphics_GBC_Off.TransAttrEnd - I_Graphics_GBC_Off.TransAttr
    call App_CallFromBank

    ld de, I_Graphics_GBC_Off.StaticAttr
    ld hl, _SCRN0
    ld bc, I_Graphics_GBC_Off.StaticAttrEnd - I_Graphics_GBC_Off.StaticAttr
    call App_CallFromBank
    ld a, 0
    ldh [rVBK], a

    PUT_ADDRESS Memory_CopyWithOffset, FunctionPointer
    ld a, -$40
    ld [MemOffset], a
    ld de, I_Graphics_GBC_Off.TransTile
    ld hl, _SCRN1
    ld bc, I_Graphics_GBC_Off.TransTileEnd - I_Graphics_GBC_Off.TransTile
    call App_CallFromBank

    ld a, -$80
    ld [MemOffset], a
    ld de, I_Graphics_GBC_Off.StaticTile
    ld hl, _SCRN0
    ld bc, I_Graphics_GBC_Off.StaticTileEnd - I_Graphics_GBC_Off.StaticTile
    call App_CallFromBank

    PUT_ADDRESS UI_GBC_BGP, FunctionPointer
    ld hl, I_Graphics_GBC_Off.TransPal
    ld bc, I_Graphics_GBC_Off.TransPalEnd - I_Graphics_GBC_Off.TransPal
    call App_CallFromBank

    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_BLK01 | LCDCF_BG9C00 | LCDCF_OBJON
    ldh [rLCDC], a
    
    call App_EndOfFrame
    call App_EndOfFrame

    ld a, LCDCF_OFF
    ldh [rLCDC], a

    PUT_ADDRESS UI_GBC_BGP, FunctionPointer
    ld hl, I_Graphics_GBC_Off.StaticPal
    ld bc, I_Graphics_GBC_Off.StaticPalEnd - I_Graphics_GBC_Off.StaticPal
    call App_CallFromBank

    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_BLK01 | LCDCF_BG9800 | LCDCF_OBJON
    ldh [rLCDC], a

    ret
