INCLUDE "hardware.inc"
INCLUDE "charmap.inc"
INCLUDE "macros/input_macros.inc"
INCLUDE "macros/sprite_macros.inc"
INCLUDE "macros/extra_macros.inc"

SECTION "Starmap - Display - Variables", WRAM0

MapBufferIndex: ds 1
XY: ds 1

SECTION "Starmap - Display", ROMX, BANK[$3]

M_Display::
    call DisplayLocations
    call HideLocations
    ret



; \1 = Location ID
; \2 = Location Name
; \3 = Tile ID
; \4 = Attributes
MACRO CREATE_LOCATION
    cp \1
    jr nz, .\2

    ld d, \3
    ld e, \4
    call CreateLocation
.\2
ENDM
    
DisplayLocations:
    xor a
    ld [MapBufferIndex], a
    ld [XY], a

    ld hl, OAM_DMA
    ld de, OAM_DMA_End - OAM_DMA
    ld bc, (MapBufferEnd - MapBuffer) / 2
    push de

.loop
    call .getindex   
    cp 0
    jp z, .empty

    ld a, [MapBufferIndex]
    inc a
    ld [MapBufferIndex], a

    call .getindex
    and %00000111 ; Mask location ID

    CREATE_LOCATION %000, Spaceport, $00, $00
    CREATE_LOCATION %001, Waystation, $04, $00
    CREATE_LOCATION %010, BlackMarket, $08, $00
    CREATE_LOCATION %011, Scrapyard, $0C, $00
    CREATE_LOCATION %100, FTLPass, $10, $00
    CREATE_LOCATION %101, Warehouse, $14, $00
    CREATE_LOCATION %110, Wormhole, $18, $00
    CREATE_LOCATION %111, Planet, $1C, $00

    pop de
    dec de
    push de

.skip
    ld a, [MapBufferIndex]
    inc a
    ld [MapBufferIndex], a

    ld a, [XY]
    inc a
    ld [XY], a

    dec bc
    ld a, b
    or c
    jp nz, .loop

    ; Fill remaining space
    pop de
    srl e
    srl e
    srl e

    ld b, 0
    ld c, e
.fill
    push bc
    call .makeStarTile
    call .makeStarTile
    pop bc
    
    dec bc
    dec bc
    ld a, b
    or c
    jr nz, .fill
    ret

.empty
    ld a, [MapBufferIndex]
    inc a
    ld [MapBufferIndex], a
    jr .skip

.makeStarTile
    call App_GenerateRandom
    ld a, [RandomNumber]
    ld [hl+], a

    call App_GenerateRandom
    ld a, [RandomNumber]
    ld [hl+], a

    call App_GenerateRandom
    ld a, [RandomNumber]
    and %00000111
    add $38
    ld [hl+], a

    ld a, 0
    ld [hl+], a
    ret

    

.getindex
    push hl
    ld a, [MapBufferIndex]
    ld hl, MapBuffer
    ld d, 0
    ld e, a
    add hl, de
    ld a, [hl]
    pop hl
    ret



CreateLocation:
    call .GetY
    ld [hl+], a

    call .GetX
    ld [hl+], a

    ld a, d
    ld [hl+], a
    ld a, e
    ld [hl+], a

    call .GetY
    ld [hl+], a

    call .GetX
    or %00001000
    ld [hl+], a

    ld a, d
    add $02
    ld [hl+], a
    ld a, e
    ld [hl+], a
    ret

.GetX
    ld a, [XY]
    and %00000111 ; X component
    sla a
    sla a
    sla a
    sla a
    sla a
    ret

.GetY
    ld a, [XY]
    and %00111000 ; Y component
    sla a
    sla a
    ret



HideLocations:
    ld hl, OAM_DMA + 2
    ld a, [Save.Fog]
    ld c, a
    call .loopinit
    ld a, [Save.Fog + 1]
    ld c, a
    call .loopinit
    ld a, [Save.Fog + 2]
    or %00001111
    ld c, a
    call .loopinit
    ret

.loopinit
    ld b, 8
.byteloop
    bit 7, c
    jr nz, .skip

    ld a, [hl]
    cp $38
    jr nc, .skip

    ld a, $34
    ld [hl], a
    ld de, 4
    add hl, de

    ld a, $36
    ld [hl], a
    ld de, 4
    add hl, de

    sla c
    dec b
    jr nz, .byteloop
    ret

.skip
    ld de, 8
    add hl, de

    sla c
    dec b
    jr nz, .byteloop
    ret