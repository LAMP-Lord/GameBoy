INCLUDE "hardware.inc"
INCLUDE "charmap.inc"
INCLUDE "macros/input_macros.inc"
INCLUDE "macros/sprite_macros.inc"
INCLUDE "macros/extra_macros.inc"

EXPORT TitleScreen_EntryPoint.start
EXPORT TitleScreen_ScrollingAnimation.resetship
EXPORT Text.BlankLine

SECTION "TitleScreen - Variables", WRAM0

TitleScreenState: ds 1

SECTION "TitleScreen - Graphics", ROMX, BANK[$1]

Graphics:
    .Main INCBIN "generated/backgrounds/title-screen.2bpp"
    .MainEnd

    .Map INCBIN "generated/backgrounds/title-screen.tilemap"
    .MapEnd

    .Ship INCBIN "generated/sprites/TitleScreenShip.2bpp"
    .ShipEnd

SECTION "TitleScreen - Menu Data", ROMX, BANK[$1]

Text:
    .NewGame: db "New Game", 255
    .Continue: db "Continue", 255

    .nAreYouSure1: db "This will eras", 255
    .nAreYouSureE: db "e", 255
    .nAreYouSure2: db "your save.    ", 255
    .nAreYouSure3: db "Continue?     ", 255

    .nYes: db "Yes", 255
    .nNo: db "No", 255

    .BlankLine: db "              ", 255

SECTION "TitleScreen - Main", ROMX, BANK[$1]

TitleScreen_EntryPoint::
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

    ; Timer (Random Seed Generation)
    ld a, %00000101
    ld [rTAC], a

    ; Print Text
    ld de, $99E7
    ld hl, Text.NewGame
    call UI_PrintText

    ld de, $9A07
    ld hl, Text.Continue
    call UI_PrintText

    ld hl, _OAMRAM

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

    call Memory_LoadSave

.start
    ; Init Menu
    ld a, 2
    ld [Menu.Items], a
    xor a
    ld [Menu.Selector], a

    SET_ACTION Actions.DrawAddress, TitleScreen_MainMenuDraw
    SET_ACTION Actions.Up, Menu_Up
    SET_ACTION Actions.Down, Menu_Down
    SET_ACTION Actions.A, TitleScreen_MainMenuA

.animation
    WAIT_FRAMES 40

    ld hl, _OAMRAM
    ld b, 15
    call .loop_down

    WAIT_FRAMES 40

    ld hl, _OAMRAM
    ld b, 15
    call .loop_down

    WAIT_FRAMES 40

    ld hl, _OAMRAM
    ld b, 15
    call .loop_up

    WAIT_FRAMES 40

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

TitleScreen_WarningSetup::
    ld b, 124
    call TitleScreen_ScrollingAnimation

    ld de, $9AD2
    ld hl, Text.nAreYouSure1
    call UI_SafePrintText
    ld de, $9AC0
    ld hl, Text.nAreYouSureE
    call UI_SafePrintText
    ld de, $9AF2
    ld hl, Text.nAreYouSure2
    call UI_SafePrintText
    ld de, $9B12
    ld hl, Text.nAreYouSure3
    call UI_SafePrintText

    ld a, 1
    ld [Menu.Selector], a
    SET_ACTION Actions.DrawAddress, TitleScreen_WarningMenuDraw

    ld de, $9B79
    ld hl, Text.nYes
    call UI_SafePrintText
    ld de, $9BB9
    ld hl, Text.nNo
    call UI_SafePrintText
    
    SET_ACTION Actions.Up, Menu_Up
    SET_ACTION Actions.Down, Menu_Down
    SET_ACTION Actions.A, TitleScreen_WarningMenuA

    ret


TitleScreen_ScrollingAnimation::
.loop
    push bc
    call App_EndOfFrame
    pop bc

    ld a, b
    cp 100
    jp nz, .skip_addtile

    ld a, $F6
    ld [$99B1], a
    ld a, $F7
    ld [$99B2], a

.skip_addtile
    ldh a, [rSCX]
    inc a
    ldh [rSCX], a

    ldh a, [rSCY]
    dec a
    ldh [rSCY], a

    ld hl, _OAMRAM + 1
    ld c, 15
    call .moveallright

    dec b
    jr nz, .loop
    ret

.moveallright
    ld a, [hl]
    inc a
    ld [hl], a

    inc hl
    inc hl
    inc hl
    inc hl

    dec c
    jr nz, .moveallright
    ret

.resetship
    ld hl, _OAMRAM
    CREATE_OBJECT 1, 204, 72, 0
    CREATE_OBJECT 2, 204, 80, 0
    CREATE_OBJECT 3, 204, 88, 0

    CREATE_OBJECT 4, 212, 72, 0
    CREATE_OBJECT 5, 212, 80, 0
    CREATE_OBJECT 6, 212, 88, 0

    CREATE_OBJECT 7, 220, 72, 0
    CREATE_OBJECT 8, 220, 80, 0

    CREATE_OBJECT 9, 228, 64, 0
    CREATE_OBJECT 10, 228, 72, 0
    CREATE_OBJECT 11, 228, 80, 0

    CREATE_OBJECT 12, 236, 64, 0
    CREATE_OBJECT 13, 236, 72, 0
    CREATE_OBJECT 14, 236, 80, 0
    CREATE_OBJECT 15, 244, 72, 0
    ret



TitleScreen_AdvanceTo_NewGame::
    ret

TitleScreen_AdvanceTo_Continue::
    ret