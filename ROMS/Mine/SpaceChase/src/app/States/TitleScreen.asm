INCLUDE "include/hardware.inc"
INCLUDE "include/charmap.inc"
INCLUDE "include/input_macros.inc"
INCLUDE "include/transition_macros.inc"
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

    FADE_IN

    call Music_MainTheme

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