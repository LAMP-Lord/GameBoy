INCLUDE "hardware.inc"
INCLUDE "charmap.inc"
INCLUDE "macros/extra_macros.inc"

SECTION "Intro - New Game", ROMX, BANK[$2]

I_DMG_NewGame::
    ; New Game Selected
    ld a, BANK(I_Graphics_DMG_Off)
    ld [BankNumber], a
    PUT_ADDRESS Memory_Copy, FunctionPointer
    
    ld de, I_Graphics_DMG_Stage1.Scan1Data
    ld hl, $8800
    ld bc, I_Graphics_DMG_Stage1.Scan1DataEnd - I_Graphics_DMG_Stage1.Scan1Data
    call App_CallFromBank

    ld de, I_Graphics_DMG_Stage1.Scan2Data
    ld hl, $8C00
    ld bc, I_Graphics_DMG_Stage1.Scan2DataEnd - I_Graphics_DMG_Stage1.Scan2Data
    call App_CallFromBank

    ; Done Loading / Fade In
    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_BLK01 | LCDCF_BG9800 | LCDCF_OBJON
    ldh [rLCDC], a
    call UI_FadeIn

    ; Start Sequence
    call I_Load_DMG_Stage1
    PRINT_MULTILINE I_Graphics_DMG_Stage1.Text1, $99A1

    call App_WaitForA

    call I_Load_DMG_Stage2
    PRINT_MULTILINE I_Graphics_DMG_Stage2.Text1, $99A1
    call App_WaitForA
    PRINT_MULTILINE I_Graphics_DMG_Stage2.Text2, $99A1

    call App_WaitForA

    call I_Load_DMG_Stage3_None
    PRINT_MULTILINE I_Graphics_DMG_Stage3_None.Text1, $99A1
    call App_WaitForA
    call I_Load_DMG_Stage3_MAINTAIN
    PRINT_MULTILINE I_Graphics_DMG_Stage3_MAINTAIN.Text1, $99A1
    call App_WaitForA
    call I_Load_DMG_Stage3_DELIVER
    PRINT_MULTILINE I_Graphics_DMG_Stage3_DELIVER.Text1, $99A1
    call App_WaitForA
    call I_Load_DMG_Stage3_UPHOLD
    PRINT_MULTILINE I_Graphics_DMG_Stage3_UPHOLD.Text1, $99A1

    call App_WaitForA

    call I_Load_DMG_Stage4
    PRINT_MULTILINE I_Graphics_DMG_Stage4.Text1, $99A1

    call App_WaitForA

    ; Turn Off and Leave
    call I_DMG_OFF
    WAIT_FRAMES 40
    call UI_FadeOut

    ld a, "M"
    ld [CurrentState], a
    jp ChangeState



I_GBC_NewGame::
    ; New Game Selected
    ld a, BANK(I_Graphics_GBC_Off)
    ld [BankNumber], a

    PUT_ADDRESS Memory_Copy, FunctionPointer
    ld de, I_Graphics_GBC_Stage1.Scan1Pal
    ld hl, FadeIn_Target
    ld bc, I_Graphics_GBC_Stage1.Scan1PalEnd - I_Graphics_GBC_Stage1.Scan1Pal
    call App_CallFromBank
    
    ld de, I_Graphics_GBC_Stage1.Scan1Data
    ld hl, $8800
    ld bc, I_Graphics_GBC_Stage1.Scan1DataEnd - I_Graphics_GBC_Stage1.Scan1Data
    call App_CallFromBank

    ld de, I_Graphics_GBC_Stage1.Scan2Data
    ld hl, $8C00
    ld bc, I_Graphics_GBC_Stage1.Scan2DataEnd - I_Graphics_GBC_Stage1.Scan2Data
    call App_CallFromBank

    call I_Load_GBC_Stage1

    ; Done Loading / Fade In
    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_BLK01 | LCDCF_BG9800 | LCDCF_OBJON
    ldh [rLCDC], a
    call UI_FadeIn

    ; Start Sequence
    PRINT_MULTILINE I_Graphics_GBC_Stage1.Text1, $99A1

    call App_WaitForA

    call I_Load_GBC_Stage2
    PRINT_MULTILINE I_Graphics_GBC_Stage2.Text1, $99A1
    call App_WaitForA
    PRINT_MULTILINE I_Graphics_GBC_Stage2.Text2, $99A1

    call App_WaitForA

    call I_Load_GBC_Stage3_None
    PRINT_MULTILINE I_Graphics_GBC_Stage3_None.Text1, $99A1
    call App_WaitForA
    call I_Load_GBC_Stage3_MAINTAIN
    PRINT_MULTILINE I_Graphics_GBC_Stage3_MAINTAIN.Text1, $99A1
    call App_WaitForA
    call I_Load_GBC_Stage3_DELIVER
    PRINT_MULTILINE I_Graphics_GBC_Stage3_DELIVER.Text1, $99A1
    call App_WaitForA
    call I_Load_GBC_Stage3_UPHOLD
    PRINT_MULTILINE I_Graphics_GBC_Stage3_UPHOLD.Text1, $99A1

    call App_WaitForA

    call I_Load_GBC_Stage4
    PRINT_MULTILINE I_Graphics_GBC_Stage4.Text1, $99A1

    call App_WaitForA

    ; Turn Off and Leave
    call I_GBC_OFF
    WAIT_FRAMES 40
    call UI_FadeOut

    ld a, "M"
    ld [CurrentState], a
    jp ChangeState