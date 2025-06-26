INCLUDE "hardware.inc"
INCLUDE "charmap.inc"
INCLUDE "macros/input_macros.inc"
INCLUDE "macros/sprite_macros.inc"
INCLUDE "macros/menu_macros.inc"
INCLUDE "macros/extra_macros.inc"

EXPORT TitleScreen_EntryPoint.start
EXPORT TS_Graphics.BoxTileMapLeft
EXPORT TS_Graphics.BoxTileMapRight
EXPORT TS_Text.Yes
EXPORT TS_Text.No
EXPORT TS_Text.ContinueQ
EXPORT TS_Text.BlankLine

EXPORT TS_Text.nConfirm1
EXPORT TS_Text.nConfirm2
EXPORT TS_Text.nConfirm3

EXPORT TS_Text.cTotalMoney
EXPORT TS_Text.cTotalKills

SECTION "TitleScreen - Graphics", ROMX, BANK[$1]

TS_Graphics:
    .Main INCBIN "generated/backgrounds/title-screen.2bpp"
    .MainEnd

    .Map INCBIN "generated/backgrounds/title-screen.tilemap"
    .MapEnd

    .Ship INCBIN "generated/sprites/TitleScreenShip.2bpp"
    .ShipEnd

    .BoxTileMapLeft
        db $51, $52
        db $82, $53
        db $82, $53
        db $82, $53
        db $82, $53
        db $82, $53
        db $82, $53
        db $82, $53
        db $82, $53
        db $82, $53
        db $82, $53
        db $82, $53
        db $82, $53
        db $82, $53, 254
        db $55, $56, 255

    .BoxTileMapRight
        db $50, $51, $51, $51, $51, $51, $51, $51, $51, $51, $51, $51, $51, $51, $51
        db $53, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82
        db $53, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82
        db $53, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82
        db $53, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82
        db $53, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82
        db $53, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82
        db $53, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82
        db $53, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82
        db $53, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82
        db $53, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82
        db $53, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82
        db $53, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82
        db $53, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, 254
        db $54, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, 255

SECTION "TitleScreen - Menu Data", ROMX, BANK[$1]

TS_Text:
    ; Main
    .NewGame db "New Game", 255
    .Continue db "Continue", 255

    ; New Game
    .nAreYouSure1 db "This will eras", 255
    .nAreYouSureE db "e", 255
    .nAreYouSure2 db "your save.", 255

    .nConfirm1 db "Submit your", 255
    .nConfirm2 db "application,", 255
    .nConfirm3 db "?", 255

    ; Continue
    .cTotalMoney db "Total Money", 255
    .cTotalKills db "Total Kills", 255

    ; Both
    .ContinueQ db "Continue?", 255
    .Yes db "Yes", 255
    .No db "No", 255
    .BlankLine db "              ", 255

SECTION "TitleScreen - Main", ROMX, BANK[$1]

TitleScreen_EntryPoint::
    ; Timer (Random Seed Generation)
    ld a, %00000101
    ld [rTAC], a

    ; Graphics Loading
    ld de, Font
    ld hl, _VRAM8000 + 16*16
    ld bc, FontEnd - Font
    call Memory_Copy

    ld de, Buttons
    ld bc, ButtonsEnd - Buttons
    call Memory_CopyForSprite

    ld de, TS_Graphics.Map
    ld hl, _SCRN1
    ld bc, TS_Graphics.MapEnd - TS_Graphics.Map
    call Memory_Copy

    ld de, TS_Graphics.Main
    ld hl, _VRAM8800
    ld bc, TS_Graphics.MainEnd - TS_Graphics.Main
    call Memory_Copy

    ld de, TS_Graphics.Map
    ld hl, _SCRN0
    ld bc, TS_Graphics.MapEnd - TS_Graphics.Map
    call Memory_Copy

    ld de, TS_Graphics.Ship
    ld hl, _VRAM8000
    ld bc, TS_Graphics.ShipEnd - TS_Graphics.Ship
    call Memory_Copy

    ; Print Text
    ld de, $99E7
    ld hl, TS_Text.NewGame
    call UI_PrintText

    ld de, $9A07
    ld hl, TS_Text.Continue
    call UI_PrintText

    ; Create Ship Sprite
    ld hl, OAM_DMA

    CREATE_OBJECT 1, 80, 72, 0
    CREATE_OBJECT 2, 80, 80, 0
    CREATE_OBJECT 3, 80, 88, 0

    CREATE_OBJECT 4, 88, 72, 0
    CREATE_OBJECT 5, 88, 80, 0
    CREATE_OBJECT 6, 88, 88, 0

    CREATE_OBJECT 7, 96, 72, 0
    CREATE_OBJECT 8, 96, 80, 0

    CREATE_OBJECT 9, 104, 64, 0
    CREATE_OBJECT 10, 104, 72, 0
    CREATE_OBJECT 11, 104, 80, 0

    CREATE_OBJECT 12, 112, 64, 0
    CREATE_OBJECT 13, 112, 72, 0
    CREATE_OBJECT 14, 112, 80, 0
    CREATE_OBJECT 15, 120, 72, 0

    SET_ACTION Actions.DrawAddress, TitleScreen_MainMenuDraw

    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_BG8800 | LCDCF_BG9800 | LCDCF_OBJON
    ldh [rLCDC], a

    call UI_FadeIn

    ; Music
    ld a, $1
    ldh [ActiveBank], a
    call Music_MainTheme

.start
    call Memory_LoadSave
    ; Init Menu
    ld a, [ValidSave]
    cp 0
    jr nz, .validsave
    ld a, 1
    ld [Menu.Items], a
    jr .continue
.validsave
    ld a, 2
    ld [Menu.Items], a
.continue

    xor a
    ld [Menu.Selector], a

    SET_ACTION Actions.DrawAddress, TitleScreen_MainMenuDraw
    SET_ACTION Actions.Up, Menu.Up
    SET_ACTION Actions.Down, Menu.Down
    SET_ACTION Actions.A, TitleScreen_MainMenuA

.animation
    WAIT_FRAMES 40

    ld hl, OAM_DMA
    ld b, 15
    call .loop_down

    WAIT_FRAMES 40

    ld hl, OAM_DMA
    ld b, 15
    call .loop_down

    WAIT_FRAMES 40

    ld hl, OAM_DMA
    ld b, 15
    call .loop_up

    WAIT_FRAMES 40

    ld hl, OAM_DMA
    ld b, 15
    call .loop_up

    jr .animation

.loop_down
    ld a, [hl]
    inc a
    ld [hl], a

    inc hl
    inc hl
    inc hl
    inc hl

    dec b
    jr nz, .loop_down
    ret

.loop_up
    ld a, [hl]
    dec a
    ld [hl], a

    inc hl
    inc hl
    inc hl
    inc hl

    dec b
    jr nz, .loop_up
    ret



TitleScreen_WarningSetup::
    ld de, $9AD2
    ld hl, TS_Text.nAreYouSure1
    call UI_AniPrintText
    ld de, $9AC0
    ld hl, TS_Text.nAreYouSureE
    call UI_AniPrintText
    ld de, $9AF2
    ld hl, TS_Text.nAreYouSure2
    call UI_AniPrintText
    ld de, $9B12
    ld hl, TS_Text.ContinueQ
    call UI_AniPrintText

    ld a, 1
    ld [Menu.Selector], a
    SET_ACTION Actions.DrawAddress, TitleScreen_DrawYesNo

    ld de, $9B79
    ld hl, TS_Text.Yes
    call UI_SafePrintText
    ld de, $9BB9
    ld hl, TS_Text.No
    call UI_SafePrintText
    
    SET_ACTION Actions.Up, Menu.Up
    SET_ACTION Actions.Down, Menu.Down
    SET_ACTION Actions.A, TitleScreen_WarningMenuA

.busyloop
    call App_EndOfFrame
    jr .busyloop

TitleScreen_MainMenuDraw::
    IS_MENU_INDEX 0

    ld a, [ValidSave]
    cp 0
    jr nz, .validsave
    PRESSED_BUTTON $9A05
    jr .continue
.validsave
    INACTIVE_BUTTON $9A05
.continue

    CHECK_BUTTON sCurKeys, PADB_A
    PRESSED_BUTTON $99E5
    FALSE
    ACTIVE_BUTTON $99E5
    END_CHECK

    NOT_MENU_INDEX 0
    IS_MENU_INDEX 1

    INACTIVE_BUTTON $99E5

    CHECK_BUTTON sCurKeys, PADB_A
    PRESSED_BUTTON $9A05
    FALSE
    ACTIVE_BUTTON $9A05
    END_CHECK

    NOT_MENU_INDEX 1
    ret



TitleScreen_MainMenuA::
    IS_MENU_INDEX 0

    CHECK_BUTTON sDrpKeys, PADB_A
    call Actions_ResetActions
    ld b, 124
    call TitleScreen_ScrollingAnimation
    ld sp, $FFFE
    ld a, [ValidSave]
    cp 0
    jr z, .skipConfirm
    jp TitleScreen_WarningSetup
.skipConfirm
    jp TitleScreen_GoTo_NewGame
    FALSE
    END_CHECK

    NOT_MENU_INDEX 0
    IS_MENU_INDEX 1

    CHECK_BUTTON sDrpKeys, PADB_A

    call Actions_ResetActions
    ld b, 124
    call TitleScreen_ScrollingAnimation
    ld sp, $FFFE
    jp TitleScreen_GoTo_Continue
    
    FALSE
    END_CHECK

    NOT_MENU_INDEX 1
    ret



TitleScreen_DrawYesNo::
    IS_MENU_INDEX 0

    INACTIVE_BUTTON $9BB7

    CHECK_BUTTON sCurKeys, PADB_A
    PRESSED_BUTTON $9B77
    FALSE
    ACTIVE_BUTTON $9B77
    END_CHECK

    NOT_MENU_INDEX 0
    IS_MENU_INDEX 1

    INACTIVE_BUTTON $9B77

    CHECK_BUTTON sCurKeys, PADB_A
    PRESSED_BUTTON $9BB7
    FALSE
    ACTIVE_BUTTON $9BB7
    END_CHECK

    NOT_MENU_INDEX 1
    ret



TitleScreen_WarningMenuA::
    CHECK_BUTTON sDrpKeys, PADB_A
    IS_MENU_INDEX 0

    ld sp, $FFFE
    call TS_Unloadmenu
    jp TitleScreen_GoTo_NewGame

    NOT_MENU_INDEX 0
    IS_MENU_INDEX 1

    ld sp, $FFFE
    call TS_Unloadmenu
    ; Continue
    call TitleScreen_ScrollingAnimation.resetship
    call App_EndOfFrame
    xor a
    ld [$99B1], a
    ld [$99B2], a
    call Actions_ResetActions
    xor a
    ld [Menu.Selector], a
    ld b, 132
    call TitleScreen_ScrollingAnimation
    jp TitleScreen_EntryPoint.start

    NOT_MENU_INDEX 1
    FALSE
    END_CHECK
    ret

TS_Unloadmenu::
    ; Reset
    call Actions_ResetActions
    ; Remove Text
    ld de, $9B77
    ld hl, TS_Text.BlankLine
    call UI_SafePrintText
    ld de, $9BB7
    ld hl, TS_Text.BlankLine
    call UI_SafePrintText
    ld de, $9AD2
    ld hl, TS_Text.BlankLine
    call UI_AniPrintText
    ld de, $9AC0
    ld hl, TS_Text.BlankLine
    call UI_AniPrintText
    ld de, $9AF2
    ld hl, TS_Text.BlankLine
    call UI_AniPrintText
    ld de, $9B12
    ld hl, TS_Text.BlankLine
    call UI_AniPrintText
    ret