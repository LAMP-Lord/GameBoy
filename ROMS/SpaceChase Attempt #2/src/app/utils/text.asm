INCLUDE "include/hardware.inc"

SECTION "Util - Text Functions", ROM0

textFontTileData: INCBIN "generated/fonts/text-two.2bpp"
textFontTileDataEnd:

Text_LoadFont::
    ld de, textFontTileData
    ld hl, $9000
    ld bc, textFontTileDataEnd - textFontTileData 
    jp Memory_Copy