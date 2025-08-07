INCLUDE "hardware.inc"
INCLUDE "charmap.inc"
INCLUDE "macros/input_macros.inc"
INCLUDE "macros/extra_macros.inc"

SECTION "Intro - Continue", ROMX, BANK[$2]

I_DMG_Continue::
    ld a, BANK(I_Graphics_DMG_Off)
    ld [BankNumber], a

    PUT_ADDRESS Memory_Copy, FunctionPointer
    ld de, I_Graphics_DMG_Stage2.Scan1Data
    ld hl, $8800
    ld bc, I_Graphics_DMG_Stage2.Scan1DataEnd - I_Graphics_DMG_Stage2.Scan1Data
    call App_CallFromBank

    ld de, I_Graphics_DMG_Stage2.Scan2Data
    ld hl, $8C00
    ld bc, I_Graphics_DMG_Stage2.Scan2DataEnd - I_Graphics_DMG_Stage2.Scan2Data
    call App_CallFromBank

    call I_Load_DMG_Stage1

    ; Done Loading / Fade In
    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_BLK01 | LCDCF_BG9800 | LCDCF_OBJON
    ldh [rLCDC], a
    call UI_FadeIn

    ; Start Sequence
    call I_Load_DMG_Stage2

    call App_WaitForA

    call Memory_LoadSave

    call I_Load_DMG_Continue
    PUT_ADDRESS Save.PlayerName, DynamicLabel
    PRINT_MULTILINE I_Graphics_DMG_Console.Text, $9881, $C4

    PUT_ADDRESS I_Graphics_DMG_Console.Widgets, DynamicLabel
    PRINT_MULTILINE I_Graphics_DMG_Console.PrintWidget, $98E1, $C4
    ld hl, I_Graphics_DMG_Console.Widgets
    ld b, 20
    call GenWidget
    PRINT_MULTILINE I_Graphics_DMG_Console.PrintWidget, $9901, $C4
    PUT_ADDRESS I_Graphics_DMG_Console.Widgets, DynamicLabel
    PRINT_MULTILINE I_Graphics_DMG_Console.PrintWidget, $9921, $C4

    call App_WaitForA
    call I_DMG_ClearScreen

    ld hl, I_Graphics_DMG_Console.Quotes
    ld b, 51
    call GenWidget
    PRINT_MULTILINE I_Graphics_DMG_Console.QotD, $9881, $C4

    call App_WaitForA

    ; Turn Off and Leave
    call I_DMG_OFF
    WAIT_FRAMES 40
    call UI_FadeOut

    ld a, "M"
    ld [CurrentState], a
    jp ChangeState

I_GBC_Continue::
    ld a, BANK(I_Graphics_GBC_Off)
    ld [BankNumber], a

    PUT_ADDRESS Memory_Copy, FunctionPointer
    ld de, I_Graphics_GBC_Stage2.Scan1Data
    ld hl, $8800
    ld bc, I_Graphics_GBC_Stage2.Scan1DataEnd - I_Graphics_GBC_Stage2.Scan1Data
    call App_CallFromBank

    ld de, I_Graphics_GBC_Stage2.Scan2Data
    ld hl, $8C00
    ld bc, I_Graphics_GBC_Stage2.Scan2DataEnd - I_Graphics_GBC_Stage2.Scan2Data
    call App_CallFromBank

    ld de, I_Graphics_GBC_Stage1.Scan1Pal
    ld hl, FadeIn_Target
    ld bc, I_Graphics_GBC_Stage1.Scan1PalEnd - I_Graphics_GBC_Stage1.Scan1Pal
    call App_CallFromBank

    ld de, I_Graphics_GBC_Stage2.Scan1Tile
    ld hl, _SCRN0
    ld bc, I_Graphics_GBC_Stage2.Scan1TileEnd - I_Graphics_GBC_Stage2.Scan1Tile
    call App_CallFromBank

    ld a, 1
    ldh [rVBK], a
    ld de, I_Graphics_GBC_Stage1.Scan1Attr
    ld hl, _SCRN0
    ld bc, I_Graphics_GBC_Stage1.Scan1AttrEnd - I_Graphics_GBC_Stage1.Scan1Attr
    call App_CallFromBank

    ld de, I_Graphics_GBC_Stage1.Scan2Attr
    ld hl, _SCRN1
    ld bc, I_Graphics_GBC_Stage1.Scan2AttrEnd - I_Graphics_GBC_Stage1.Scan2Attr
    call App_CallFromBank
    ld a, 0
    ldh [rVBK], a

    PUT_ADDRESS Memory_CopyWithOffset, FunctionPointer
    ld a, $40
    ld [MemOffset], a
    ld de, I_Graphics_GBC_Stage2.Scan2Tile
    ld hl, _SCRN1
    ld bc, I_Graphics_GBC_Stage2.Scan2TileEnd - I_Graphics_GBC_Stage2.Scan2Tile
    call App_CallFromBank

    ; Done Loading / Fade In
    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_BLK01 | LCDCF_BG9800 | LCDCF_OBJON
    ldh [rLCDC], a
    SET_ACTION Actions.Up, ON_9800
    call UI_FadeIn

    PUT_ADDRESS Memory_SafeCopyVBK, FunctionPointer
    

    ; Start Sequence
    call App_WaitForA

    call Memory_LoadSave

    call I_Load_GBC_Continue
    PUT_ADDRESS Save.PlayerName, DynamicLabel
    PRINT_MULTILINE I_Graphics_GBC_Console.Text, $9881, $C3

    PUT_ADDRESS I_Graphics_GBC_Console.Widgets, DynamicLabel
    PRINT_MULTILINE I_Graphics_GBC_Console.PrintWidget, $98E1, $C3
    ld hl, I_Graphics_GBC_Console.Widgets
    ld b, 20
    call GenWidget
    PRINT_MULTILINE I_Graphics_GBC_Console.PrintWidget, $9901, $C3
    PUT_ADDRESS I_Graphics_GBC_Console.Widgets, DynamicLabel
    PRINT_MULTILINE I_Graphics_GBC_Console.PrintWidget, $9921, $C3

    call App_WaitForA
    call I_GBC_ClearScreen

    ld hl, I_Graphics_GBC_Console.Quotes
    ld b, 51
    call GenWidget
    PRINT_MULTILINE I_Graphics_GBC_Console.QotD, $9881, $C3

    call App_WaitForA

    ; Turn Off and Leave
    call I_GBC_OFF
    WAIT_FRAMES 40
    call UI_FadeOut

    ld a, "M"
    ld [CurrentState], a
    jp ChangeState

GenWidget:
    push bc
    push hl
    call App_GenerateRandom
    pop hl
    pop bc
    ld a, [RandomNumber]
    and $0F
    ld e, a
    ld d, 0
.notdone
    add hl, de
    dec b
    jr nz, .notdone
    PUT_16_BITS l, h, DynamicLabel
    ret