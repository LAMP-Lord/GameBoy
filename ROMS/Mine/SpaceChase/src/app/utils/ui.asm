INCLUDE "include/hardware.inc"
INCLUDE "include/charmap.inc"

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
    inc l
    ld bc, DisplayBoxTileDataEnd - DisplayBoxTileData 
    call Memory_Copy

    ret

UI_PlaceBox::
    ret

UI_PrintText::
    ld de, $9800

UI_PrintTextLoop:
    ld a, [hli]
    cp 255
    ret z

    ld [de], a
    inc de

    jr UI_PrintTextLoop