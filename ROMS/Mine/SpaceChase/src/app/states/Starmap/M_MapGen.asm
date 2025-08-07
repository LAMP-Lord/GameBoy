INCLUDE "hardware.inc"
INCLUDE "charmap.inc"
INCLUDE "macros/input_macros.inc"
INCLUDE "macros/sprite_macros.inc"
INCLUDE "macros/extra_macros.inc"

SECTION "Starmap - Generation - Variables", WRAM0[$C300]

; Generation
MapBuffer:: ds 8*8*2
MapBufferEnd::

MapIndex: ds 1
TotalLen: ds 1
LocationBuffer: ds 1
DirectionBuffer: ds 1
LastLocation: ds 1
IsEmpty: ds 1

MaxSystems: ds 1

SECTION "Starmap - Generation - Main", ROMX, BANK[$3]

M_GenerateMap::
    call Memory_LoadSave
    ; call App_GenerateSeed

    ld a, 28 + 9
    ld [MapIndex], a
    ld [LastLocation], a

    ld d, 0
    ld hl, MapBuffer
    ld bc, MapBufferEnd - MapBuffer
    call Memory_Fill

    ; Mix up seed value
    ld a, [Save.Seed + 1]
    swap a
    xor $5A
    ld b, a
    ld [RandomSeeded + 1], a
    ld a, [Save.Seed]
    add b
    xor $A5
    ld [RandomSeeded], a

    call App_GenerateRandomSeeded

    ld a, [Save.Sector + 1]
    ld b, a
    ld a, [Save.Sector]
    ld c, a
    ld a, [RandomSeeded]
    swap a
    or c
    swap a
    xor b
    xor $5A
    and %00000011
    add 2 ; (2-5 Systems)
    ld [MaxSystems], a

    ld a, [RandomSeeded + 1]
    and %00001111
    add 5  ; 5-20
    ld [TotalLen], a

    ; First location in system

    ; Is first system?
    ld a, [Save.System]
    cp 1
    jr z, .isFirstSystem

    ; Place Wormhole (Non-interactable)
    ld a, %0000_1110
    ld [LocationBuffer], a
    jr .end

.isFirstSystem
    ; Place Warehouse
    ld a, [RandomSeeded]
    and $F0
    ld b, a
    ld a, %0000_1101
    or b
    ld [LocationBuffer], a

.end
    call MapLoop.getindex
    inc hl
    ld a, [LocationBuffer]
    ld [hl], a

    ld a, [TotalLen]
    dec a
    ld [TotalLen], a

    call MapLoop
    ret



MapLoop:
    ; Generate random direction
    call App_GenerateRandomSeeded
    ld a, [RandomSeeded]
    and %00000111
    
    ld hl, .DirTable
    call .PickItem
    ld [DirectionBuffer], a

    ; Add to direction byte
    ld b, a
    call .getindex
    ld a, [hl]
    
    ; Check if something is here for later
    cp 0
    jr z, .empty
    ld a, 0
    ld [IsEmpty], a
    jr .done

.empty
    ld a, 1
    ld [IsEmpty], a

.done
    ld a, [hl]
    or b
    ld [hl], a

    ; Walk to next location
    ld a, [DirectionBuffer]
    bit 7, a
    jp nz, .u
    bit 6, a
    jp nz, .ur
    bit 5, a
    jp nz, .r
    bit 4, a
    jp nz, .dr
    bit 3, a
    jp nz, .d
    bit 2, a
    jp nz, .dl
    bit 1, a
    jp nz, .l
    bit 0, a
    jp nz, .ul
.AfterWalk

    ; Add inverse direction
    ld a, [DirectionBuffer]
    swap a
    ld b, a
    call .getindex
    ld a, [hl]
    or b
    ld [hl], a

    ; Check if last location
    ld a, [TotalLen]
    dec a
    ld [TotalLen], a
    jr nz, .skipLast

    ; If last system:
    ld a, [MaxSystems]
    ld b, a
    ld a, [Save.System]
    cp b
    jr z, .lastSystem
    
    ; Place Wormhole
    ld a, %0000_0110
    ld [LocationBuffer], a
    call .getindex
    inc hl
    ld a, [LocationBuffer]
    ld [hl], a
    ret

.lastSystem

    ; Place Planet
    ld a, [RandomSeeded + 1]
    ld b, %0000_0111
    or b
    ld [LocationBuffer], a
    call .getindex
    inc hl
    ld a, [LocationBuffer]
    ld [hl], a
    ret

.skipLast
    ld a, [IsEmpty]
    cp 0
    ; Z = It is empty   NZ = Something is here
    jp nz, MapLoop


.tryLocation
    ld a, [LastLocation]
    ld b, a

    ; Generate random location
    call App_GenerateRandomSeeded
    ld a, [RandomSeeded]
    and %00000111
    ld hl, .LocTable
    call .PickItem

    ; If same type, try again
    cp b
    jr z, .tryLocation
    ld [LocationBuffer], a

    ; Place Location
    call .getindex
    inc hl
    ld a, [LocationBuffer]
    ld [hl], a

    jp MapLoop

; Converts 3-bit value to 8-bit index
.PickItem
    add l
    ld l, a
    ld a, [hl]
    ret

.LocTable
    db %001, %001, %001, %011, %010, %000, %100, %001
.DirTable
    db $01, $02, $04, $08, $10, $20, $40, $80

; Direction walk modifiers
.u
    ld b, -$8
    call .ChangeY
    jp .AfterWalk
.ur
    ld b, -$8
    call .ChangeY
    ld b, $1
    call .ChangeX
    jp .AfterWalk
.r
    ld b, $1
    call .ChangeX
    jp .AfterWalk
.dr
    ld b, $8
    call .ChangeY
    ld b, $1
    call .ChangeX
    jp .AfterWalk
.d
    ld b, $8
    call .ChangeY
    jp .AfterWalk
.dl
    ld b, $8
    call .ChangeY
    ld b, -$1
    call .ChangeX
    jp .AfterWalk
.l
    ld b, -$1
    call .ChangeX
    jp .AfterWalk
.ul
    ld b, -$8
    call .ChangeY
    ld b, -$1
    call .ChangeX
    jp .AfterWalk

.ChangeX
    ; Increment X w/ Clamping
    ld a, [MapIndex]
    add b
    and %00000111
    ld b, a

    ; Write to MapIndex
    ld a, [MapIndex]
    and %11111000
    or b
    ld [MapIndex], a
    ret

.ChangeY
    ; Increment X w/ Clamping
    ld a, [MapIndex]
    add b
    and %00111111
    ld b, a

    ; Write to MapIndex
    ld a, [MapIndex]
    and %11000000
    or b
    ld [MapIndex], a
    ret

; Get memory location of index
.getindex
    ld a, [MapIndex]
    ld hl, MapBuffer
    ld d, 0
    ld e, a
    add hl, de
    add hl, de
    ret