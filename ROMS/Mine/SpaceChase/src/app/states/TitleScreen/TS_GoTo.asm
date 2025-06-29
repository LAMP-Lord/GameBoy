INCLUDE "hardware.inc"
INCLUDE "charmap.inc"
INCLUDE "macros/input_macros.inc"
INCLUDE "macros/sprite_macros.inc"
INCLUDE "macros/extra_macros.inc"
INCLUDE "macros/menu_macros.inc"

EXPORT SetupMenu.Up
EXPORT SetupMenu.Down
EXPORT SetupMenu.Draw
EXPORT SetupMenu.Exit

SECTION "TitleScreen - Keyboard Variables", WRAM0

TS_Index:: ds 1

TS_PrintLocation:: ds 2
TS_MaxCharacters:: ds 1
TS_CurCharacters:: ds 1

TS_PrintLocationTable:: ds 8
TS_PrintLocationTableEnd::
TS_CurCharactersTable:: ds 4
TS_CurCharactersTableEnd::

SECTION "TitleScreen - Go To Functions", ROMX, BANK[$1]

SeedLabel: db "Seed", 255
RandLabel: db "Random", 255
NameLabel: db "Player Name", 255
DiffLabel: db "Hazard", 255

KeysRow1: db "ABCDEFGHIJKLM", 255
KeysRow2: db "NOPQRSTUVWXYZ", 255
KeysRow3: db "0123456789 ^", $58, 255

TitleScreen_GoTo_NewGame::
    ld a, %11_10_11_11
    ld [rBGP], a
    ld [rOBP0], a
    ld [rOBP1], a

    call App_EndOfFrame
    call App_ResetOAM
    call App_EndOfFrame

    ld a, [$9F93]
    cp $1C
    jr z, .skipResets
    call TitleScreen_DrawPopup

    call App_GenerateSeed
    PRINT_HEX [Save.Seed], $9EB6
    PRINT_HEX [Save.Seed+1], $9EB8

    ; Clear tables
    ld d, 0
    ld hl, TS_PrintLocationTable
    ld bc, TS_PrintLocationTableEnd - TS_PrintLocationTable
    call Memory_Fill

    ld d, 0
    ld hl, TS_CurCharactersTable
    ld bc, TS_CurCharactersTableEnd - TS_CurCharactersTable
    call Memory_Fill

    ld a, 4
    ld [TS_CurCharactersTable], a
    ld a, $9E
    ld [TS_PrintLocationTable], a
    ld a, $B9
    ld [TS_PrintLocationTable+1], a
.skipResets

    ; Cursor Init
    ld hl, OAM_DMA
    CREATE_OBJECT $2C, 36, 108, 0

    ; Print Keyboard
    ld hl, KeysRow1
    ld de, $9F93
    call Text_SafePrintText

    ld hl, KeysRow2
    ld de, $9FB3
    call Text_SafePrintText
    
    ld hl, KeysRow3
    ld de, $9FD3
    call Text_SafePrintText

    ; Print Labels
    ld bc, SeedLabel
    ld hl, OAM_DMA + $28
    ld d, 28
    ld e, 44
    call Text_PrintTextAsObj

    ld bc, RandLabel
    ld hl, OAM_DMA + $38
    ld d, 84
    ld e, 44
    call Text_PrintTextAsObj

    ld bc, NameLabel
    ld hl, OAM_DMA + $50
    ld d, 28
    ld e, 68
    call Text_PrintTextAsObj

    ld bc, DiffLabel
    ld hl, OAM_DMA + $88
    ld d, 28
    ld e, 92
    call Text_PrintTextAsObj

    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_BG8800 | LCDCF_BG9C00 | LCDCF_OBJON
    ldh [rLCDC], a

    ; Set up menu
    xor a
    ld [Menu.Selector], a
    ld a, 4
    ld [Menu.Items], a

    SET_ACTION Actions.DrawAddress, SetupMenu.Draw

    call UI_FadeInStarsX

    ld a, %11_01_00_00
    ld [rOBP0], a
    ld [rOBP1], a

    SET_ACTION Actions.Up, SetupMenu.Up
    SET_ACTION Actions.Down, SetupMenu.Down
    SET_ACTION Actions.Left, NopFunction
    SET_ACTION Actions.Right, NopFunction

    SET_ACTION Actions.A, NopFunction
    SET_ACTION Actions.B, SetupMenu.Exit
    SET_ACTION Actions.Start, Confirm

.busyloop
    call App_EndOfFrame
    jr .busyloop



SetupMenu::
.Up
    CHECK_BUTTON sNewKeys, PADF_UP
    call Menu.Up_Action
    call Menu.Up_Action
    ret
    FALSE
    END_CHECK
    CHECK_BUTTON sNewKeys, PADF_LEFT
    call Menu.Up_Action
    ret
    FALSE
    END_CHECK
    ret

.Down
    CHECK_BUTTON sNewKeys, PADF_DOWN
    call Menu.Down_Action
    call Menu.Down_Action
    ret
    FALSE
    END_CHECK
    CHECK_BUTTON sNewKeys, PADF_RIGHT
    call Menu.Down_Action
    ret
    FALSE
    END_CHECK
    ret

.Exit
    CHECK_BUTTON sDrpKeys, PADF_B

    call Keyboard.SaveState

    ld sp, $FFFE
    call Actions_ResetActions
    call UI_FadeOutStarsX

    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_BG8800 | LCDCF_BG9800 | LCDCF_OBJON
    ldh [rLCDC], a

    call App_ResetOAM
    call TitleScreen_ScrollingAnimation.resetship
    call App_EndOfFrame

    ld a, %11_10_01_00
    ld [rBGP], a
    ld [rOBP0], a
    ld [rOBP1], a

    xor a
    ld [$99B1], a
    ld [$99B2], a
    xor a
    ld [Menu.Selector], a
    ld b, 132
    call TitleScreen_ScrollingAnimation
    jp TitleScreen_EntryPoint.start
    FALSE
    END_CHECK
    ret

.Draw    
    IS_MENU_INDEX 0
    SET_ACTION Actions.A, SeedButton.Select
    INACTIVE_BUTTON $9F13
    INACTIVE_BUTTON $9EBA
    INACTIVE_BUTTON $9F5A
    CHECK_BUTTON sCurKeys, PADF_A
    PRESSED_BUTTON $9EB3
    FALSE
    ACTIVE_BUTTON $9EB3
    END_CHECK
    NOT_MENU_INDEX 0
    IS_MENU_INDEX 1
    SET_ACTION Actions.A, RandomizeSeed
    INACTIVE_BUTTON $9EB3
    INACTIVE_BUTTON $9F13
    INACTIVE_BUTTON $9F5A
    CHECK_BUTTON sCurKeys, PADF_A
    PRESSED_BUTTON $9EBA
    FALSE
    ACTIVE_BUTTON $9EBA
    END_CHECK
    NOT_MENU_INDEX 1
    IS_MENU_INDEX 2
    SET_ACTION Actions.A, NameButton.Select
    INACTIVE_BUTTON $9EB3
    INACTIVE_BUTTON $9EBA
    INACTIVE_BUTTON $9F5A
    CHECK_BUTTON sCurKeys, PADF_A
    PRESSED_BUTTON $9F13
    FALSE
    ACTIVE_BUTTON $9F13
    END_CHECK
    NOT_MENU_INDEX 2
    IS_MENU_INDEX 3
    SET_ACTION Actions.A, DifficultyButton.Select
    INACTIVE_BUTTON $9EB3
    INACTIVE_BUTTON $9F13
    INACTIVE_BUTTON $9EBA
    CHECK_BUTTON sCurKeys, PADF_A
    PRESSED_BUTTON $9F5A
    FALSE
    ACTIVE_BUTTON $9F5A
    END_CHECK
    NOT_MENU_INDEX 3

    xor a
    ld [OAM_DMA], a
    ld [OAM_DMA+1], a

    ret



RandomizeSeed:
    CHECK_BUTTON sDrpKeys, PADF_A
    ld a, 4
    ld [TS_CurCharactersTable], a
    PUT_16_BITS $9E, $B9, TS_PrintLocationTable
    call App_GenerateSeed
    PRINT_HEX [Save.Seed], $9EB6
    PRINT_HEX [Save.Seed+1], $9EB8
    FALSE
    END_CHECK
    ret



SeedButton:
SeedButton.Select
    CHECK_BUTTON sDrpKeys, PADF_A
    ld a, 4
    ld [TS_MaxCharacters], a
    ld a, 0
    ld de, $9EB5
    call Keyboard.LoadState
    SET_ACTION Actions.DrawAddress, NopFunction

    SET_ACTION Actions.Up, Keyboard.Up
    SET_ACTION Actions.Down, Keyboard.Down
    SET_ACTION Actions.Right, Keyboard.Right
    SET_ACTION Actions.Left, Keyboard.Left

    SET_ACTION Actions.A, Keyboard.SelectKey
    SET_ACTION Actions.B, Keyboard.ExitCheck
    FALSE
    END_CHECK
    ret

NameButton:
NameButton.Select
    CHECK_BUTTON sDrpKeys, PADF_A
    ld a, 10
    ld [TS_MaxCharacters], a
    ld a, 2
    ld de, $9F15
    call Keyboard.LoadState
    SET_ACTION Actions.DrawAddress, NopFunction

    SET_ACTION Actions.Up, Keyboard.Up
    SET_ACTION Actions.Down, Keyboard.Down
    SET_ACTION Actions.Right, Keyboard.Right
    SET_ACTION Actions.Left, Keyboard.Left

    SET_ACTION Actions.A, Keyboard.SelectKey
    SET_ACTION Actions.B, Keyboard.ExitCheck
    FALSE
    END_CHECK
    ret

DifficultyButton:
DifficultyButton.Select
    CHECK_BUTTON sDrpKeys, PADF_A
    ld a, 2
    ld [TS_MaxCharacters], a
    ld a, 3
    ld de, $9F5C
    call Keyboard.LoadState
    SET_ACTION Actions.DrawAddress, NopFunction

    SET_ACTION Actions.Up, Keyboard.Up
    SET_ACTION Actions.Down, Keyboard.Down
    SET_ACTION Actions.Right, Keyboard.Right
    SET_ACTION Actions.Left, Keyboard.Left

    SET_ACTION Actions.A, Keyboard.SelectKey
    SET_ACTION Actions.B, Keyboard.ExitCheck
    FALSE
    END_CHECK
    ret



LoadNewGameData:
    ld d, 0
    ld hl, Save
    ld bc, SaveEnd - Save
    call Memory_Fill

    GET_HEX $9EB5
    ld [Save.Seed], a
    GET_HEX $9EB7
    ld [Save.Seed+1], a

    ld de, $9F15
    ld hl, Save.PlayerName
    ld bc, 11
    call Memory_SafeCopy

    GET_HEX $9F5C
    ld [Save.Difficulty], a

    ld a, 99
    ld [Save.CurrentFuel], a
    ld [Save.HullHealth], a

    call Memory_SaveGame

    xor a
    ld [ValidSave], a

    ret

Confirm:
    CHECK_BUTTON sDrpKeys, PADF_START
    call .Setup
    FALSE
    END_CHECK
    ret

.Setup
    call Actions_ResetActions
    call App_ResetOAM

    call UI_FadeOutStarsX

    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_BG8800 | LCDCF_BG9800 | LCDCF_OBJON
    ldh [rLCDC], a

    ld a, %11_10_01_00
    ld [rBGP], a
    ld [rOBP0], a
    ld [rOBP1], a

    ld bc, 0
    ld hl, TS_Text.nConfirm1
    ld de, $9AD4
    call Text_AniPrintText

    ld bc, 0
    ld hl, TS_Text.nConfirm2
    ld de, $9AF4
    call Text_AniPrintText

    ld bc, 0
    ld hl, $9F15
    ld de, $9B14
    call Text_AniPrintName
    ld hl, TS_Text.nConfirm3
    call Text_AniPrintText

    ld a, 1
    ld [Menu.Selector], a
    ld a, 2
    ld [Menu.Items], a
    SET_ACTION Actions.DrawAddress, TitleScreen_DrawYesNo

    ld de, $9B79
    ld hl, TS_Text.Yes
    call Text_SafePrintText
    ld de, $9BB9
    ld hl, TS_Text.No
    call Text_SafePrintText

    SET_ACTION Actions.Up, Menu.Up
    SET_ACTION Actions.Down, Menu.Down
    SET_ACTION Actions.A, Confirm.Action
    SET_ACTION Actions.B, NopFunction

    ret

.Action
    CHECK_BUTTON sDrpKeys, PADF_B
    jr .exit
    FALSE
    END_CHECK

    CHECK_BUTTON sDrpKeys, PADF_A
    IS_MENU_INDEX 0

    ; GO TO NEW GAME
    call LoadNewGameData
    call UI_FadeOut

    ld a, "I"
    ld [CurrentState], a
    jp ChangeState

    NOT_MENU_INDEX 0
    IS_MENU_INDEX 1

.exit
    ld sp, $FFFE
    call Actions_ResetActions
    call UI_FadeOutStarsX
    call TS_Unloadmenu
    jp TitleScreen_GoTo_NewGame

    NOT_MENU_INDEX 1
    FALSE
    END_CHECK
    ret



TitleScreen_GoTo_Continue::
    ld a, %11_10_11_11
    ld [rBGP], a
    ld [rOBP0], a
    ld [rOBP1], a

    call TitleScreen_DrawPopup
    call App_ResetOAM

    ; Bold Text
    ld bc, Save.PlayerName
    ld hl, OAM_DMA
    ld d, 28
    ld e, 44
    call Text_PrintNameAsObj

    ld bc, TS_Text.cTotalMoney
    ld hl, OAM_DMA + $28
    ld d, 28
    ld e, 68
    call Text_PrintTextAsObj

    ld bc, TS_Text.cTotalKills
    ld hl, OAM_DMA + $50
    ld d, 28
    ld e, 92
    call Text_PrintTextAsObj

    ld bc, TS_Text.ContinueQ
    ld hl, OAM_DMA + $78
    ld d, 28
    ld e, 116
    call Text_PrintTextAsObj

    ; Hardcoded Text
    ld hl, TS_Text.Yes
    ld de, $9FD5
    call Text_SafePrintText

    ld hl, TS_Text.No
    ld de, $9FDC
    call Text_SafePrintText

    ; Data
    ld hl, Save.HullHealth
    ld b, 0
    ld c, [hl]
    ld de, $9EBA
    call Text_PrintNumbers

    ld hl, Save.CurrentFuel
    ld b, 0
    ld c, [hl]
    ld de, $9EB6
    call Text_PrintNumbers

    ld hl, Save.Money
    ld b, [hl]
    inc hl
    ld c, [hl]
    ld de, $9EB2
    call Text_PrintNumbers

    ; Bottom Rows
    ld hl, Save.TotalMoney
    ld b, [hl]
    inc hl
    ld c, [hl]
    ld de, $9F13
    call Text_PrintNumbers

    ld hl, Save.TotalKills
    ld b, [hl]
    inc hl
    ld c, [hl]
    ld de, $9F73
    call Text_PrintNumbers

    ; Symbols & Spacers
    ld a, " "
    ld [$9EB2], a
    ld a, " "
    ld [$9EB8], a
    ld a, " "
    ld [$9EBC], a

    ld a, "$"
    ld [$9EB7], a

    ld a, "`"
    ld [$9EBB], a

    ld a, "%"
    ld [$9EBF], a

    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_BG8800 | LCDCF_BG9C00 | LCDCF_OBJON
    ldh [rLCDC], a

    ; Set up menu
    ld a, 1
    ld [Menu.Selector], a
    ld a, 2
    ld [Menu.Items], a

    SET_ACTION Actions.DrawAddress, StatMenu.Draw

    call UI_FadeInStarsX

    ld a, %11_01_00_00
    ld [rOBP0], a
    ld [rOBP1], a

    SET_ACTION Actions.Right, StatMenu.Right
    SET_ACTION Actions.Left, StatMenu.Left
    SET_ACTION Actions.A, .Action

.busyloop
    call App_EndOfFrame
    jr .busyloop

.Action
    CHECK_BUTTON sDrpKeys, PADF_B
    jr .exit
    FALSE
    END_CHECK

    CHECK_BUTTON sDrpKeys, PADF_A
    IS_MENU_INDEX 0
.exit
    ld sp, $FFFE
    call Actions_ResetActions
    call UI_FadeOutStarsX

    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_BG8800 | LCDCF_BG9800 | LCDCF_OBJON
    ldh [rLCDC], a

    call App_ResetOAM
    call TitleScreen_ScrollingAnimation.resetship
    call App_EndOfFrame

    ld a, %11_10_01_00
    ld [rBGP], a
    ld [rOBP0], a
    ld [rOBP1], a

    xor a
    ld [$99B1], a
    ld [$99B2], a
    xor a
    ld [Menu.Selector], a
    ld b, 132
    call TitleScreen_ScrollingAnimation
    jp TitleScreen_EntryPoint.start
    NOT_MENU_INDEX 0
    IS_MENU_INDEX 1
    
    call UI_FadeOut

    ld a, "I"
    ld [CurrentState], a
    jp ChangeState

    NOT_MENU_INDEX 1
    FALSE
    END_CHECK
    ret

StatMenu:
.Draw
    IS_MENU_INDEX 0
    INACTIVE_BUTTON $9FD3

    CHECK_BUTTON sCurKeys, PADF_A
    PRESSED_BUTTON $9FDA
    FALSE
    ACTIVE_BUTTON $9FDA
    END_CHECK
    NOT_MENU_INDEX 0
    IS_MENU_INDEX 1
    INACTIVE_BUTTON $9FDA
    
    CHECK_BUTTON sCurKeys, PADF_A
    PRESSED_BUTTON $9FD3
    FALSE
    ACTIVE_BUTTON $9FD3
    END_CHECK
    NOT_MENU_INDEX 1
    ret

.Right
    CHECK_BUTTON sNewKeys, PADF_RIGHT
    jp Menu.Up_Action
    FALSE
    END_CHECK
    ret

.Left
    CHECK_BUTTON sNewKeys, PADF_LEFT
    jp Menu.Down_Action
    FALSE
    END_CHECK
    ret