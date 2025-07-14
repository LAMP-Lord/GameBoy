INCLUDE "hardware.inc"
INCLUDE "charmap.inc"
INCLUDE "macros/input_macros.inc"
INCLUDE "macros/sprite_macros.inc"
INCLUDE "macros/extra_macros.inc"

SECTION "Starmap     - Variables", WRAM0[$C300]

; Generation
MapBuffer: ds 16*16*2
MapBufferEnd:

MapIndex: ds 1
TotalLen: ds 1
LocationBuffer: ds 1
DirectionBuffer: ds 1

SECTION "Starmap     - Graphics", ROMX, BANK[$3]

SM_Graphics:
    .Main INCBIN "generated/images16/Starmap-Locations.2bpp"
    .MainEnd

    .Select INCBIN "generated/ui/Starmap-Selected.2bpp"
    .SelectEnd

SECTION "Starmap     - Functions", ROMX, BANK[$3]

Starmap_EntryPoint::
    ; ld a, 40
    ; ld [rSCX], a

    ; ld hl, OAM_DMA
    ; CREATE_OBJECT 0, 160, 78, 0
    ; CREATE_OBJECT 2, 168, 78, 0

    ld de, Font
    ld hl, _VRAM9000
    ld bc, FontEnd - Font 
    call Memory_Copy
    
    ld de, SM_Graphics.Main
    ld hl, _VRAM8000
    ld bc, SM_Graphics.MainEnd - SM_Graphics.Main
    call Memory_Copy

    ld de, SM_Graphics.Select
    ld bc, SM_Graphics.SelectEnd - SM_Graphics.Select
    call Memory_Copy

    call GenerateMap

    ld a, $2
    ld [$9821], a

    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_BG8800 | LCDCF_BG9800 | LCDCF_OBJON | LCDCF_OBJ16
    ldh [rLCDC], a

    call UI_FadeIn

    ld a, %11_10_01_00
    ld [rBGP], a

    ld a, %01_10_10_11
    ld [rOBP0], a

    ld a, %00_01_10_11
    ld [rOBP1], a

.loop
    call App_EndOfFrame

    ; ld hl, OAM_DMA + 1
    ; ld a, [hl]
    ; sub 2
    ; ld [hl], a
    ; ld hl, OAM_DMA + 5
    ; ld a, [hl]
    ; sub 2
    ; ld [hl], a

    ; ld a, [rSCX]
    ; sub 1
    ; ld [rSCX], a

    jr .loop



GenerateMap:
    call Memory_LoadSave
    ; call App_GenerateSeed

    xor a
    ld [MapIndex], a

    ld d, a
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

    ld a, [RandomSeeded + 1]
    and $03
    add 12  ; 12-20
    ld [TotalLen], a

    ; First location in system
    ld a, [Save.System]
    cp 1
    jr z, .isFirstSystem

    ; Place Wormhole (Non-interactable)
    jr .end

.isFirstSystem
    ; Place Warehouse

.end
    call MapLoop
    call FillWithStars
    ret



MapLoop:
    call App_GenerateRandomSeeded
    ld a, [RandomSeeded]
    and %00000111
    call PickDirection
    ld [DirectionBuffer], a
    ld a, $14
    ld [LocationBuffer], a
    call PlaceAtIndex

    ld a, [TotalLen]
    cp 0
    jr nz, MapLoop
    ret

PickDirection:
    ld hl, .BitTable
    add l
    ld l, a
    ld a, [hl]
    ret
.BitTable
    db $01, $02, $04, $08, $10, $20, $40, $80



PlaceAtIndex:
    call .getindex 
    inc hl

    ld a, [hl]
    cp 0
    jr nz, .skip
    
    ld a, [LocationBuffer]
    ld [hl-], a

    ld a, [TotalLen]
    dec a
    ld [TotalLen], a
.skip

    ; Add chosen direction
    ld a, [DirectionBuffer]
    ld b, a
    ld a, [hl]
    or b
    ld [hl], a

    ld a, [DirectionBuffer]

    ; Figure out where to walk
    bit 7, a
    jr nz, .u
    bit 6, a
    jr nz, .ur
    bit 5, a
    jr nz, .r
    bit 4, a
    jr nz, .dr
    bit 3, a
    jr nz, .d
    bit 2, a
    jr nz, .dl
    bit 1, a
    jr nz, .l
    bit 0, a
    jr nz, .ul

.u
    ld a, [MapIndex]
    sub $10
    ld [MapIndex], a
    call .placeinverse
    ret
.ur
    ld a, [MapIndex]
    sub $0F
    ld [MapIndex], a
    call .placeinverse
    ret
.r
    ld a, [MapIndex]
    add $01
    ld [MapIndex], a
    call .placeinverse
    ret
.dr
    ld a, [MapIndex]
    add $11
    ld [MapIndex], a
    call .placeinverse
    ret
.d
    ld a, [MapIndex]
    add $10
    ld [MapIndex], a
    call .placeinverse
    ret
.dl
    ld a, [MapIndex]
    add $0F
    ld [MapIndex], a
    call .placeinverse
    ret
.l
    ld a, [MapIndex]
    sub $01
    ld [MapIndex], a
    call .placeinverse
    ret
.ul
    ld a, [MapIndex]
    sub $11
    ld [MapIndex], a
    call .placeinverse
    ret

.placeinverse
    call .getindex
    ld a, [DirectionBuffer]
    swap a
    ld b, a
    ld a, [hl]
    or b
    ld [hl], a
    ret

.getindex
    ld a, [MapIndex]
    ld hl, MapBuffer
    ld d, 0
    ld e, a
    add hl, de
    add hl, de
    ret

FillWithStars:
    ld hl, MapBuffer
    ld de, MapBufferEnd - MapBuffer

.loop
    inc hl
    dec de

    call App_GenerateRandomSeeded
    ld a, [RandomSeeded]

    bit 0, a
    jr nz, .placestar

.end
    inc hl
    dec de
    ld a, d
    or e
    jr nz, .loop
    ret

.placestar
    ld a, [hl]
    cp 0
    jr nz, .end

    ld a, [RandomSeeded]
    bit 1, a
    jr nz, .placestar2

    ld a, $38
    ld [hl], a
    jr .end

.placestar2
    ld a, $3C
    ld [hl], a
    jr .end



SM_AdvanceSystem::
    ; Reset ship position
    xor a
    ld [Save.Location], a

    ; Go to new system
    ld a, [Save.System]
    inc a
    ld [Save.System], a

    ; Slightly increase difficulty
    ld a, [Save.Difficulty]
    ld b, a
    ld a, [Save.Difficulty + 1]
    ld c, a
    inc bc
    ld a, b
    ld [Save.Difficulty], a
    ld a, c
    ld [Save.Difficulty + 1], a
    
    ; Reload map
    call UI_FadeOut
    ld a, "M"
    ld [CurrentState], a
    jp ChangeState

SM_AdvanceSector::
    ; Deliver Cargo
    ; Get New Cargo

    ; Reset ship position
    xor a
    ld [Save.Location], a

    ; Reset system counter
    ld a, 1
    ld [Save.System], a

    ; Go to new sector
    ld a, [Save.Sector]
    ld b, a
    ld a, [Save.Sector + 1]
    ld c, a
    inc bc
    ld a, b
    ld [Save.Sector], a
    ld a, c
    ld [Save.Sector + 1], a

    ; Slightly increase difficulty
    ld a, [Save.Difficulty]
    ld b, a
    ld a, [Save.Difficulty + 1]
    ld c, a
    inc bc
    ld a, b
    ld [Save.Difficulty], a
    ld a, c
    ld [Save.Difficulty + 1], a
    
    ; Reload map
    call UI_FadeOut
    ld a, "M"
    ld [CurrentState], a
    jp ChangeState