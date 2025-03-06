INCLUDE "include/hardware.inc"
INCLUDE "include/charmap.inc"

SECTION "Util - Text Loading", ROM0

FontTileData: INCBIN "generated/fonts/text-font.2bpp"
FontTileDataEnd:

Text_LoadFont::
    ld de, FontTileData
    ld hl, _VRAM9000
    ld bc, FontTileDataEnd - FontTileData 
    call Memory_Copy
    ret

SECTION "Util - Text Functions", ROM0

Text_PrintText::
    ld de, $9800

Text_PrintTextLoop:
    ld a, [hli]
    cp 255
    ret z

    ld [de], a
    inc de

    jp Text_PrintTextLoop