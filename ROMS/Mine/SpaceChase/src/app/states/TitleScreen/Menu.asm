INCLUDE "hardware.inc"
INCLUDE "charmap.inc"
INCLUDE "macros/input_macros.inc"
INCLUDE "macros/menu_macros.inc"

SECTION "TitleScreen - Menu Functions", ROMX, BANK[$1]

TitleScreen_MainMenuDraw::
    IS_MENU_INDEX 0

    INACTIVE_BUTTON $9A05

    CHECK_BUTTON sCurKeys, PADB_A
    PRESSED_BUTTON $99E5
    FALSE
    ACTIVE_BUTTON $99E5
    END_CHECK
    ret

    NOT_MENU_INDEX 0
    IS_MENU_INDEX 1

    INACTIVE_BUTTON $99E5

    CHECK_BUTTON sCurKeys, PADB_A
    PRESSED_BUTTON $9A05
    FALSE
    ACTIVE_BUTTON $9A05
    END_CHECK
    ret

    NOT_MENU_INDEX 1

TitleScreen_MainMenuA::
    IS_MENU_INDEX 0

    CHECK_BUTTON sDrpKeys, PADB_A
    call Actions_ResetActions
    ld a, [ValidSave]
    cp 0
    jp z, .skipConfirm
    call TitleScreen_WarningSetup
.skipConfirm
    FALSE
    END_CHECK
    ret

    NOT_MENU_INDEX 0
    IS_MENU_INDEX 1

    CHECK_BUTTON sDrpKeys, PADB_A
    call Memory_SaveGame
    call Memory_LoadSave
    call Actions_ResetActions
    call UI_FadeOut
    ld a, "T"
    ld [CurrentState], a
    jp ChangeState
    FALSE
    END_CHECK
    ret

    NOT_MENU_INDEX 1

TitleScreen_WarningMenuDraw::
    IS_MENU_INDEX 0

    INACTIVE_BUTTON $9BB7

    CHECK_BUTTON sCurKeys, PADB_A
    PRESSED_BUTTON $9B77
    FALSE
    ACTIVE_BUTTON $9B77
    END_CHECK
    ret

    NOT_MENU_INDEX 0
    IS_MENU_INDEX 1

    INACTIVE_BUTTON $9B77

    CHECK_BUTTON sCurKeys, PADB_A
    PRESSED_BUTTON $9BB7
    FALSE
    ACTIVE_BUTTON $9BB7
    END_CHECK
    ret

    NOT_MENU_INDEX 1

TitleScreen_WarningMenuA::
    IS_MENU_INDEX 0

    CHECK_BUTTON sDrpKeys, PADB_A
    ld sp, $FFFE
    call .unloadmenu
    ; Continue
    call TitleScreen_ScrollingAnimation.resetship
    xor a
    ld [$99B1], a
    ld [$99B2], a
    ld b, 132
    call TitleScreen_ScrollingAnimation
    jp TitleScreen_EntryPoint.start
    FALSE
    END_CHECK
    ret

    NOT_MENU_INDEX 0
    IS_MENU_INDEX 1

    CHECK_BUTTON sDrpKeys, PADB_A
    ld sp, $FFFE
    call .unloadmenu
    ; Continue
    call TitleScreen_ScrollingAnimation.resetship
    xor a
    ld [$99B1], a
    ld [$99B2], a
    ld b, 132
    call TitleScreen_ScrollingAnimation
    jp TitleScreen_EntryPoint.start
    FALSE
    END_CHECK
    ret

    NOT_MENU_INDEX 1

.unloadmenu
    ; Reset
    call Actions_ResetActions
    ; Remove Text
    ld de, $9AD2
    ld hl, Text.BlankLine
    call UI_SafePrintText
    ld de, $9AC0
    ld hl, Text.BlankLine
    call UI_SafePrintText
    ld de, $9AF2
    ld hl, Text.BlankLine
    call UI_SafePrintText
    ld de, $9B12
    ld hl, Text.BlankLine
    call UI_SafePrintText
    ld de, $9B77
    ld hl, Text.BlankLine
    call UI_SafePrintText
    ld de, $9BB7
    ld hl, Text.BlankLine
    call UI_SafePrintText
    ret