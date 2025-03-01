INCLUDE "include/hardware.inc"
INCLUDE "include/text-macros.inc"

SECTION "TitleScreenState", ROM0

PressPlayText::  db "press a to play", 255
 
titleScreenTileData: INCBIN "generated/backgrounds/title-screen.2bpp"
titleScreenTileDataEnd:
 
titleScreenTileMap: INCBIN "generated/backgrounds/title-screen.tilemap"
titleScreenTileMapEnd:

InitTitleScreenState::

    call DrawTitleScreen

    ld hl, song
    call hUGE_init
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Draw the press play text
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; Call Our function that draws text onto background/window tiles
    ld de, $99C3
    ld hl, PressPlayText
    call DrawTextTilesLoop

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; Turn the LCD on
    ld a, LCDCF_ON  | LCDCF_BGON|LCDCF_OBJON | LCDCF_OBJ16
    ld [rLCDC], a

    ret

DrawTitleScreen::

    ; Copy the tile data
    ld de, titleScreenTileData ; de contains the address where data will be copied from;
    ld hl, $9340 ; hl contains the address where data will be copied to;
    ld bc, titleScreenTileDataEnd - titleScreenTileData ; bc contains how many bytes we have to copy.
    call CopyDEintoMemoryAtHL
    
    ; Copy the tilemap
    ld de, titleScreenTileMap
    ld hl, $9800
    ld bc, titleScreenTileMapEnd - titleScreenTileMap
    jp CopyDEintoMemoryAtHL_With52Offset

UpdateTitleScreenState::

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Wait for A
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; Save the passed value into the variable: mWaitKey
    ; The WaitForKeyFunction always checks against this vriable
    ld a, PADF_A
    ld [mWaitKey], a

    call WaitForKeyFunction

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ld a, 1
    ld [wGameState],a
    jp NextGameState