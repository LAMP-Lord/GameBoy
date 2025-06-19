INCLUDE "include/hardware.inc"
INCLUDE "include/charmap.inc"
INCLUDE "include/input_macros.inc"
INCLUDE "include/sprite_macros.inc"

SECTION "TitleScreen - Graphics", ROMX, BANK[$1]

Graphics:
    .Main INCBIN "generated/backgrounds/title-screen.2bpp"
    .MainEnd

    .Map INCBIN "generated/backgrounds/title-screen.tilemap"
    .MapEnd

    .Ship INCBIN "generated/sprites/TitleScreenShip.2bpp"
    .ShipEnd

SECTION "TitleScreen - Functions", ROMX, BANK[$1]

TitleScreen_Animation::
    ld de, Graphics.Main
    ld hl, _VRAM8800
    ld bc, Graphics.MainEnd - Graphics.Main
    call Memory_Copy

    ld de, Graphics.Map
    ld hl, _SCRN0
    ld bc, Graphics.MapEnd - Graphics.Map
    call Memory_Copy

    ld de, Graphics.Ship
    ld hl, _VRAM8000
    ld bc, Graphics.ShipEnd - Graphics.Ship
    call Memory_Copy

    ld hl, _OAMRAM

    CREATE_OBJECT 1, 80, 72, 0
    CREATE_OBJECT 2, 80, 80, 0
    CREATE_OBJECT 3, 80, 88, 0

    CREATE_OBJECT 4, 88, 72, 0
    CREATE_OBJECT 5, 88, 80, 0
    CREATE_OBJECT 6, 88, 88, 0

    CREATE_OBJECT 7, 96, 64, 0
    CREATE_OBJECT 8, 96, 72, 0
    CREATE_OBJECT 9, 96, 80, 0

    CREATE_OBJECT 10, 104, 64, 0
    CREATE_OBJECT 11, 104, 72, 0
    CREATE_OBJECT 12, 104, 80, 0

    CREATE_OBJECT 13, 112, 64, 0
    CREATE_OBJECT 14, 112, 72, 0
    CREATE_OBJECT 15, 120, 72, 0

    ; Print Text
    ld de, $99E6
    ld hl, Text_NewGame
    call UI_PrintText

    ld de, $9A06
    ld hl, Text_Continue
    call UI_PrintText

    ; Init Menu
    ld a, 2
    ld [Menu.Items], a

    SET_ACTION Actions.DrawAddress, TitleMenu_Draw
    SET_ACTION Actions.Up, Menu_Up
    SET_ACTION Actions.Down, Menu_Down

    ; Music
    ld a, $1
    ld [ActiveBank], a
    call Music_MainTheme

    call Memory_LoadSave

    call UI_FadeIn

.animation
    ld a, 40
    ld [FrameCounter], a
    call App_WaitFrames

    ld hl, _OAMRAM
    ld b, 15
    call .loop_down

    ld a, 40
    ld [FrameCounter], a
    call App_WaitFrames

    ld hl, _OAMRAM
    ld b, 15
    call .loop_down

    ld a, 40
    ld [FrameCounter], a
    call App_WaitFrames

    ld hl, _OAMRAM
    ld b, 15
    call .loop_up

    ld a, 40
    ld [FrameCounter], a
    call App_WaitFrames

    ld hl, _OAMRAM
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



SECTION "TitleScreen - Menu Data", ROMX, BANK[$1]

Text_NewGame: db "New Game", 255
Text_Continue: db "Continue", 255

SECTION "TitleScreen - Menu Functions", ROMX, BANK[$1]

TitleMenu_Draw:
    ld a, [ValidSave]
    add $11
    ld [$9803], a

    ld a, [Menu.Selector]
    cp 0
    jr nz, Continue

    SET_ACTION Actions.A, TitleMenu_NewGame

    ld a, [Save.Seed]
    ld [$9800], a
    ld a, [Save.Seed + 1]
    ld [$9801], a

    CHECK_BUTTON sCurKeys, PADB_A
    ld a, $59
    ld [$99E5], a
    ld a, $58
    ld [$9A05], a
    ret
    FALSE
    ld a, $57
    ld [$99E5], a
    ld a, $58
    ld [$9A05], a
    ret

Continue:
    SET_ACTION Actions.A, TitleMenu_Continue

    CHECK_BUTTON sCurKeys, PADB_A
    ld a, $58
    ld [$99E5], a
    ld a, $59
    ld [$9A05], a

    ld a, [Save.Seed]
    ld [$9820], a
    ld a, [Save.Seed + 1]
    ld [$9821], a
    ret
    FALSE
    ld a, $58
    ld [$99E5], a
    ld a, $57
    ld [$9A05], a
    ret


TitleMenu_NewGame:
    CHECK_BUTTON sCurKeys, PADB_A
    ; call UI_FadeOut
    call App_GenerateSeed
    FALSE
    ret

TitleMenu_Continue:
    CHECK_BUTTON sDrpKeys, PADB_A
    ; call UI_FadeOut
    call Memory_SaveGame
    call Memory_LoadSave

    FALSE
    ret