text: db $47, $49, 255
; ld a, [hl]
; cp 255
; ret z

; ; Write the current character (in hl) to the address
; ; on the tilemap (in de)
; ld a, [hl]
; ld [de], a

; inc hl
; inc de


Text_PrintText::
    ld hl, text
    
.ConstructTiles:
    ld a, [hli]
    cp 255
    ret z

    push hl

    ld e, a
    xor a
    ld d, a

    push de
    pop hl

    add hl, hl
    add hl, hl
    add hl, hl
    add hl, hl

    push hl
    pop de

    ld a, d
    add a, $88
    ld d, a

    ld a, $10
    ld c, a

    xor a
    ld b, a
    ld l, a

    ld a, $90
    ld h, a

    call Memory_Copy

    pop hl

    jp .ConstructTiles


.ConstructTileLoop:


.PlaceTileOnTilemap: