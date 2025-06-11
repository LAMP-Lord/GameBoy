INCLUDE "include/hardware.inc"
INCLUDE "include/charmap.inc"
INCLUDE "include/constants.inc"

SECTION "UI         - Rendering Variables", WRAM0

UI_BoxWidth:: db
UI_BoxHeight:: db

SECTION "UI         - Data", ROM0

Font: INCBIN "generated/ui/text-font.2bpp"
FontEnd:

DisplayBox: INCBIN "generated/ui/display-box.2bpp"
DisplayBoxEnd:

Buttons: INCBIN "generated/ui/buttons.2bpp"
ButtonsEnd:

TitleScreen: INCBIN "generated/backgrounds/title-screen.2bpp"
TitleScreenEnd:

TitleScreenMap: INCBIN "generated/backgrounds/title-screen.tilemap"
TitleScreenMapEnd:

SECTION "UI         - Functions", ROM0

UI_Load::
    ld de, Font
    ld hl, _VRAM9000
    ld bc, FontEnd - Font 
    call Memory_Copy

    ld de, DisplayBox
    ld bc, DisplayBoxEnd - DisplayBox 
    call Memory_Copy

    ld de, Buttons
    ld bc, ButtonsEnd - Buttons 
    call Memory_Copy

    ld de, TitleScreen
    ld hl, _VRAM8800
    ld bc, TitleScreenEnd - TitleScreen
    call Memory_Copy

    ret

UI_PlaceBox::
.init_toprow
    ld a, [UI_BoxWidth]
    ld b, a

    ld a, DISPLAYBOX_TOPLEFT
    ld [hl+], a

.placetoprow
    ld a, DISPLAYBOX_TOP
    ld [hl+], a

    dec b
    jr nz, .placetoprow

.topright
    ld a, DISPLAYBOX_TOPRIGHT
    ld [hl], a

.init_walls
    ld a, [UI_BoxWidth]
    ld b, a

    ld a, l
    sub b
    ld l, a

    ld de, $001F
    add hl, de

    ld a, [UI_BoxHeight]
    ld c, a

.placewalls:
    ld a, DISPLAYBOX_WALL
    ld [hl], a

    ld a, [UI_BoxWidth]
    add 1

    ld e, a
    ld d, 0
    add hl, de

    ld a, DISPLAYBOX_WALL
    ld [hl], a

    ld a, [UI_BoxWidth]
    ld b, a

    ld a, l
    sub b
    sub 1
    ld l, a

    ld a, $20
    ld e, a
    ld d, 0
    add hl, de

    dec c
    jr nz, .placewalls

.init_bottomrow

    ld a, DISPLAYBOX_BOTTOMLEFT
    ld [hl+], a

.placebottomrow
    ld a, DISPLAYBOX_BOTTOM
    ld [hl+], a

    dec b
    jr nz, .placebottomrow

.bottomright
    ld a, DISPLAYBOX_BOTTOMRIGHT
    ld [hl], a
    
    ret

UI_PrintText::
    ld a, [hl+]
    cp 255
    ret z

    ld [de], a
    inc de

    jr UI_PrintText



UI_TitleScreenOpen::
    ld de, TitleScreenMap
    ld hl, _SCRN0
    ld bc, TitleScreenMapEnd - TitleScreenMap
    call Memory_Copy

    ret