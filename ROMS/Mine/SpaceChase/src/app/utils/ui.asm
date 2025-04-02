INCLUDE "include/hardware.inc"
INCLUDE "include/charmap.inc"
INCLUDE "include/constants.inc"

SECTION "UI         - Rendering Variables", WRAM0

UI_BoxWidth:: db
UI_BoxHeight:: db

SECTION "UI         - Functions", ROM0

FontTileData: INCBIN "generated/ui/text-font.2bpp"
FontTileDataEnd:

DisplayBoxTileData: INCBIN "generated/ui/display-box.2bpp"
DisplayBoxTileDataEnd:

UI_Load::
    ld de, FontTileData
    ld hl, _VRAM9000
    ld bc, FontTileDataEnd - FontTileData 
    call Memory_Copy

    ld de, DisplayBoxTileData
    ld bc, DisplayBoxTileDataEnd - DisplayBoxTileData 
    call Memory_Copy

    ret

UI_PlaceBox::
.uipb_init_toprow
    ld a, [UI_BoxWidth]
    ld b, a

    ld a, DISPLAYBOX_TOPLEFT
    ld [hl+], a

.uipb_placetoprow
    ld a, DISPLAYBOX_TOP
    ld [hl+], a

    dec b
    jr nz, .uipb_placetoprow

.uipb_topright
    ld a, DISPLAYBOX_TOPRIGHT
    ld [hl], a

.uipb_init_walls
    ld a, [UI_BoxWidth]
    ld b, a

    ld a, l
    sub b
    ld l, a

    ld de, $001F
    add hl, de

    ld a, [UI_BoxHeight]
    ld c, a

.uipb_placewalls:
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
    jr nz, .uipb_placewalls

.uipb_init_bottomrow

    ld a, DISPLAYBOX_BOTTOMLEFT
    ld [hl+], a

.uipb_placebottomrow
    ld a, DISPLAYBOX_BOTTOM
    ld [hl+], a

    dec b
    jr nz, .uipb_placebottomrow

.uipb_bottomright
    ld a, DISPLAYBOX_BOTTOMRIGHT
    ld [hl], a
    
    ret

UI_PrintText::
    ld de, $99E2

UI_PrintTextLoop:
    ld a, [hl+]
    cp 255
    ret z

    ld [de], a
    inc de

    jr UI_PrintTextLoop