INCLUDE "hardware.inc"
INCLUDE "charmap.inc"
INCLUDE "macros/input_macros.inc"
INCLUDE "macros/sprite_macros.inc"
INCLUDE "macros/menu_macros.inc"
INCLUDE "macros/extra_macros.inc"

EXPORT TitleScreen_EntryPoint.start
EXPORT T_Graphics.BoxTileMapLeft
EXPORT T_Graphics.BoxTileMapRight
EXPORT T_Text.Yes
EXPORT T_Text.No
EXPORT T_Text.ContinueQ
EXPORT T_Text.BlankLine

EXPORT T_Text.nConfirm1
EXPORT T_Text.nConfirm2
EXPORT T_Text.nConfirm3

EXPORT T_Text.cTotalMoney
EXPORT T_Text.cTotalKills

SECTION "Titlescreen - Graphics", ROMX, BANK[$1]

T_Graphics: 
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

DMG_Graphics:
    .Main INCBIN "generated/dmg/backgrounds/titlescreen/background.2bpp"
    .MainEnd

    .Tilemap INCBIN "generated/dmg/backgrounds/titlescreen/background.tilemap"
    .TilemapEnd

    .Ship INCBIN "generated/dmg/images16/titlescreen/ship.2bpp"
    .ShipEnd

GBC_Graphics:
    .Main INCBIN "generated/gbc/backgrounds/titlescreen/background.2bpp"
    .MainEnd

    .Tilemap INCBIN "generated/gbc/backgrounds/titlescreen/background.tilemap"
    .TilemapEnd

    .BG_Palette INCBIN "generated/gbc/backgrounds/titlescreen/background.pal"
    .BG_PaletteEnd

    .Attrmap INCBIN "generated/gbc/backgrounds/titlescreen/background.attrmap"
    .AttrmapEnd

    .Ship INCBIN "generated/gbc/images16/titlescreen/ship.2bpp"
    .ShipEnd

    .Ship_Palette INCBIN "generated/gbc/images16/titlescreen/ship.pal"
    .Ship_PaletteEnd

SECTION "Titlescreen - Text Data", ROMX, BANK[$1]

T_Text:
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

SECTION "Titlescreen - Main Menu", ROMX, BANK[$1]

TitleScreen_EntryPoint::
    ; Timer (Random Seed Generation)
    ld a, %00000101
    ld [rTAC], a

    ; Graphics Loading
    ldh a, [ConsoleFlag]
    cp BOOTUP_A_CGB
    jp nz, .dmg

    ; UI Shadow
    ; this is so unimaginably dumb
    ld de, UI_GBC.Font
    ld hl, $8000 + 16*16
    ld bc, 16
    call Memory_CopyForSprite

    ld de, UI_GBC.Font + 16
    ld hl, $8000 + 16*16 + 16
    ld bc, UI_GBC.FontEnd - UI_GBC.Font - 16
    call Memory_Copy

    ld de, UI_GBC.Buttons
    ld bc, UI_GBC.ButtonsEnd - UI_GBC.Buttons
    call Memory_CopyForSprite

    ; Background
    ld de, GBC_Graphics.Tilemap
    ld hl, _SCRN1
    ld bc, GBC_Graphics.TilemapEnd - GBC_Graphics.Tilemap
    call Memory_Copy

    ld de, GBC_Graphics.Main
    ld hl, $8800
    ld bc, GBC_Graphics.MainEnd - GBC_Graphics.Main
    call Memory_Copy

    ld de, GBC_Graphics.Tilemap
    ld hl, _SCRN0
    ld bc, GBC_Graphics.TilemapEnd - GBC_Graphics.Tilemap
    call Memory_Copy

    ; Ship
    ld de, GBC_Graphics.Ship
    ld hl, $8000
    ld bc, GBC_Graphics.ShipEnd - GBC_Graphics.Ship
    call Memory_Copy

    ; UI
    ld de, UI_GBC.Font
    ld hl, $9000
    ld bc, UI_GBC.FontEnd - UI_GBC.Font 
    call Memory_Copy

    ld de, UI_GBC.DisplayBox
    ld bc, UI_GBC.DisplayBoxEnd - UI_GBC.DisplayBox 
    call Memory_Copy

    ld de, UI_GBC.Buttons
    ld bc, UI_GBC.ButtonsEnd - UI_GBC.Buttons 
    call Memory_Copy

    ; GBC Palettes
    ld de, GBC_Graphics.BG_Palette
    ld hl, FadeIn_Target
    ld bc, GBC_Graphics.BG_PaletteEnd - GBC_Graphics.BG_Palette
    call Memory_Copy

    ld de, GBC_Graphics.BG_Palette
    ld hl, FadeIn_Target + 64
    ld bc, GBC_Graphics.BG_PaletteEnd - GBC_Graphics.BG_Palette
    call Memory_Copy

    ld de, GBC_Graphics.Ship_Palette
    ld hl, FadeIn_Target + 64 + (4 * 8)
    ld bc, GBC_Graphics.Ship_PaletteEnd - GBC_Graphics.Ship_Palette
    call Memory_Copy

    ld de, UI_GBC.ButtonsPal
    ld hl, FadeIn_Target + 64 + (7 * 8)
    ld bc, UI_GBC.ButtonsPalEnd - UI_GBC.ButtonsPal
    call Memory_Copy

    ld a, $1
    ldh [rVBK], a

    ld de, GBC_Graphics.Attrmap
    ld hl, _SCRN0
    ld bc, GBC_Graphics.AttrmapEnd - GBC_Graphics.Attrmap
    call Memory_Copy

    ld a, $0
    ldh [rVBK], a

    jp .end

.dmg
    ; UI Shadow
    ld de, UI_DMG.Font
    ld hl, $8000 + 16*16
    ld bc, UI_DMG.FontEnd - UI_DMG.Font
    call Memory_Copy

    ld de, UI_DMG.Buttons
    ld bc, UI_DMG.ButtonsEnd - UI_DMG.Buttons
    call Memory_CopyForSprite

    ; Background
    ld de, DMG_Graphics.Tilemap
    ld hl, _SCRN1
    ld bc, DMG_Graphics.TilemapEnd - DMG_Graphics.Tilemap
    call Memory_Copy

    ld de, DMG_Graphics.Main
    ld hl, $8800
    ld bc, DMG_Graphics.MainEnd - DMG_Graphics.Main
    call Memory_Copy

    ld de, DMG_Graphics.Tilemap
    ld hl, _SCRN0
    ld bc, DMG_Graphics.TilemapEnd - DMG_Graphics.Tilemap
    call Memory_Copy

    ; Ship
    ld de, DMG_Graphics.Ship
    ld hl, $8000
    ld bc, DMG_Graphics.ShipEnd - DMG_Graphics.Ship
    call Memory_Copy

    ; UI
    ld de, UI_DMG.Font
    ld hl, $9000
    ld bc, UI_DMG.FontEnd - UI_DMG.Font 
    call Memory_Copy

    ld de, UI_DMG.DisplayBox
    ld bc, UI_DMG.DisplayBoxEnd - UI_DMG.DisplayBox 
    call Memory_Copy

    ld de, UI_DMG.Buttons
    ld bc, UI_DMG.ButtonsEnd - UI_DMG.Buttons 
    call Memory_Copy

.end
    ; Print Text
    ld bc, 0
    ld de, $99E7
    ld hl, T_Text.NewGame
    call Text_PrintText

    ld bc, 0
    ld de, $9A07
    ld hl, T_Text.Continue
    call Text_PrintText

    ; Create Ship Sprite
    ld hl, OAM_DMA

    CREATE_OBJECT 1, 80, 72, %00000_100
    CREATE_OBJECT 2, 80, 80, %00000_100
    CREATE_OBJECT 3, 80, 88, %00000_100

    CREATE_OBJECT 4, 88, 72, %00000_100
    CREATE_OBJECT 5, 88, 80, %00000_100
    CREATE_OBJECT 6, 88, 88, %00000_100

    CREATE_OBJECT 7, 96, 72, %00000_100
    CREATE_OBJECT 8, 96, 80, %00000_100

    CREATE_OBJECT 9, 104, 64, %00000_100
    CREATE_OBJECT 10, 104, 72, %00000_100
    CREATE_OBJECT 11, 104, 80, %00000_100

    CREATE_OBJECT 12, 112, 64, %00000_100
    CREATE_OBJECT 13, 112, 72, %00000_101
    CREATE_OBJECT 14, 112, 80, %00000_101
    CREATE_OBJECT 15, 120, 72, %00000_100

    SET_ACTION Actions.DrawAddress, TitleScreen_MainMenuDraw

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

    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_BLK21 | LCDCF_BG9800 | LCDCF_OBJON
    ldh [rLCDC], a

    call Music_TitleScreen
    call UI_FadeIn

.start
    call Memory_LoadSave
    ; Init Menu
    ld a, [ValidSave]
    cp 0
    jr nz, .validsave2
    ld a, 1
    ld [Menu.Items], a
    jr .continue2
.validsave2
    ld a, 2
    ld [Menu.Items], a
.continue2

    xor a
    ld [Menu.Selector], a

    SET_ACTION Actions.DrawAddress, TitleScreen_MainMenuDraw
    SET_ACTION Actions.Up, Menu.Up
    SET_ACTION Actions.Down, Menu.Down
    SET_ACTION Actions.A, TitleScreen_MainMenuA

.animation
    WAIT_FRAMES 56

    ld hl, OAM_DMA
    ld b, 15
    call .loop_down

    WAIT_FRAMES 56

    ld hl, OAM_DMA
    ld b, 15
    call .loop_down

    WAIT_FRAMES 56

    ld hl, OAM_DMA
    ld b, 15
    call .loop_up

    WAIT_FRAMES 56

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
    ld bc, 0
    ld de, $9AD2
    ld hl, T_Text.nAreYouSure1
    call Text_AniPrintText
    ld bc, 0
    ld de, $9AC0
    ld hl, T_Text.nAreYouSureE
    call Text_AniPrintText
    ld bc, 0
    ld de, $9AF2
    ld hl, T_Text.nAreYouSure2
    call Text_AniPrintText
    ld bc, 0
    ld de, $9B12
    ld hl, T_Text.ContinueQ
    call Text_AniPrintText

    ld a, 1
    ld [Menu.Selector], a
    SET_ACTION Actions.DrawAddress, TitleScreen_DrawYesNo

    ld de, $9B79
    ld hl, T_Text.Yes
    call Text_SafePrintText
    ld de, $9BB9
    ld hl, T_Text.No
    call Text_SafePrintText
    
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

    CHECK_BUTTON sCurKeys, PADF_A
    PRESSED_BUTTON $99E5
    FALSE
    ACTIVE_BUTTON $99E5
    END_CHECK

    NOT_MENU_INDEX 0
    IS_MENU_INDEX 1

    INACTIVE_BUTTON $99E5

    CHECK_BUTTON sCurKeys, PADF_A
    PRESSED_BUTTON $9A05
    FALSE
    ACTIVE_BUTTON $9A05
    END_CHECK

    NOT_MENU_INDEX 1
    ret



TitleScreen_MainMenuA::
    IS_MENU_INDEX 0

    CHECK_BUTTON sDrpKeys, PADF_A
    call SFX_Play_MenuSelect
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

    CHECK_BUTTON sDrpKeys, PADF_A
    call SFX_Play_MenuSelect

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

    CHECK_BUTTON sCurKeys, PADF_A
    PRESSED_BUTTON $9B77
    FALSE
    ACTIVE_BUTTON $9B77
    END_CHECK

    NOT_MENU_INDEX 0
    IS_MENU_INDEX 1

    INACTIVE_BUTTON $9B77

    CHECK_BUTTON sCurKeys, PADF_A
    PRESSED_BUTTON $9BB7
    FALSE
    ACTIVE_BUTTON $9BB7
    END_CHECK

    NOT_MENU_INDEX 1
    ret



TitleScreen_WarningMenuA::
    CHECK_BUTTON sDrpKeys, PADF_B
    call SFX_Play_MenuBack
    jr .exit
    FALSE
    END_CHECK

    IS_MENU_INDEX 0
    CHECK_BUTTON sDrpKeys, PADF_A
    call SFX_Play_MenuSelect

    ld sp, $FFFE
    call T_Unloadmenu
    jp TitleScreen_GoTo_NewGame

    FALSE
    END_CHECK
    NOT_MENU_INDEX 0
    IS_MENU_INDEX 1
    CHECK_BUTTON sDrpKeys, PADF_A
    call SFX_Play_MenuSelect
.exit
    ld sp, $FFFE
    call T_Unloadmenu
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

    FALSE
    END_CHECK
    NOT_MENU_INDEX 1
    ret

T_Unloadmenu::
    ; Reset
    call Actions_ResetActions
    ; Remove Text
    ld de, $9B77
    ld hl, T_Text.BlankLine
    call Text_SafePrintText
    ld de, $9BB7
    ld hl, T_Text.BlankLine
    call Text_SafePrintText
    ld bc, 0
    ld de, $9AD2
    ld hl, T_Text.BlankLine
    call Text_AniPrintText
    ld bc, 0
    ld de, $9AC0
    ld hl, T_Text.BlankLine
    call Text_AniPrintText
    ld bc, 0
    ld de, $9AF2
    ld hl, T_Text.BlankLine
    call Text_AniPrintText
    ld bc, 0
    ld de, $9B12
    ld hl, T_Text.BlankLine
    call Text_AniPrintText
    ret