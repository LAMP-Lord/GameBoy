INCLUDE "src/main/utils/hardware.inc"
INCLUDE "src/main/utils/macros/text-macros.inc"

SECTION "TestState", ROM0
 
titleScreenTileData: INCBIN "src/generated/backgrounds/title-screen.2bpp"
titleScreenTileDataEnd:
    
titleScreenTileMap: INCBIN "src/generated/backgrounds/title-screen.tilemap"
titleScreenTileMapEnd:

particleData: INCBIN "src/generated/sprites/spark.2bpp"
particleDataEnd:

InitTestState::

    call DrawTestScreen
    
    ; Clear OAM (Object Attribute Memory)
    ld a, 0         ; Empty value
    ld b, 160       ; Full size of OAM
    ld hl, _OAMRAM  ; Location of OAM

ClearOam:
    ld [hli], a     ; Set location to 0
    dec b           ; Decrement counter
    jp nz, ClearOam ; Loop when not equal to zero

    ld de, _OAMRAM 
    ld a, 40
    ld [iteration], a
ParticleLoop:
    call rand

    push de
    pop hl

    ld a, b
    add a, 16
    ld [hli], a

    ld a, c
    add a, 8
    ld [hli], a

    ld a, 0
    ld [hli], a

    ld [hli], a

    push hl
    pop de
    
    ld a, [iteration]
    dec a
    ld [iteration], a
    cp 0
    jp nz, ParticleLoop

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

DrawTestScreen::

    ; Copy the tile data
    ld de, titleScreenTileData ; de contains the address where data will be copied from;
    ld hl, $9340 ; hl contains the address where data will be copied to;
    ld bc, titleScreenTileDataEnd - titleScreenTileData ; bc contains how many bytes we have to copy.
    call CopyDEintoMemoryAtHL

    ; Copy the tilemap
    ld de, titleScreenTileMap
    ld hl, $9800
    ld bc, titleScreenTileMapEnd - titleScreenTileMap
    call CopyDEintoMemoryAtHL_With52Offset

    ; Copy the particle data
    ld de, particleData ; de contains the address where data will be copied from;
    ld hl, $8000 ; hl contains the address where data will be copied to;
    ld bc, particleDataEnd - particleData ; bc contains how many bytes we have to copy.
    jp Memcopy

; Copy bytes from one area to another.
; @param de: Start Address
; @param hl: Memory Address
; @param bc: Length
Memcopy:
    ; Load a tile into VRAM (Video Memory) + increment
    ld a, [de]              ; Load "de" Address into Register "a"
    ld [hli], a             ; Load "a" value into location in memory & increment "hl"
    inc de                  ; Increment pointer
    dec bc                  ; Decrement counter

    ; Check to see if the loop is done
    ld a, b                 ; Load "b" into "a"
    or a, c                 ; Use "a" to do a OR check on "b" & "c". This will update flags.
    jp nz, Memcopy          ; If "bc" is 0, continue. (No more data needed to read)
    ret

UpdateTestState::

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