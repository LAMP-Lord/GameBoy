INCLUDE "hardware.inc"
INCLUDE "charmap.inc"
INCLUDE "macros/sprite_macros.inc"

SECTION "Utilities - Text - WRAM", WRAM0

DigitPointer: ds 1
CountBuffer: ds 1
DigitBuffer: ds 5

DynamicLabel:: ds 2

SECTION "Utilities - Text - Main", ROM0

; 255: End Character
; HL: Text Location
; DE: Print Location
Text_PrintText::
    ld a, [hl+]
    cp 255
    ret z

    add c
    ld [de], a
    inc de

    jr Text_PrintText

Text_AniPrintText::
    push bc
    push de
    push hl
    call App_EndOfFrame
    pop hl
    pop de
    pop bc

    ld a, [hl+]
    cp 255
    ret z

    add c
    ld [de], a
    inc de

    jr Text_AniPrintText

Text_SafePrintText::
    ldh a, [rSTAT]
    and %11
    cp $1
    jp z, .safe
    push de
    push hl
    call App_EndOfFrame
    pop hl
    pop de
.safe
    ld a, [hl+]
    cp 255
    ret z

    ld [de], a
    inc de

    jr Text_SafePrintText

Text_AniPrintName::
    push de
    call .printloop
    cp $82
    jr nz, .skip
    ld h, d
    ld l, e
    pop de
    ld d, h
    ld e, l
    ret
.skip
    pop de
    cp 255
    ret z

    push hl
    ld hl, $20
    add hl, de
    ld d, h
    ld e, l
    pop hl

    jr Text_AniPrintName

.printloop
    push bc
    push de
    push hl
    call App_EndOfFrame
    pop hl
    pop de
    pop bc

    ld a, [hl+]
    cp $82
    ret z
    cp 254
    ret z
    cp 255
    ret z

    add c
    ld [de], a
    inc de

    jr .printloop

; BC = Source
; HL = OAM Starting Point
; D = X Offset
; E = Y Offset
Text_PrintTextAsObj::
    ld a, [bc]
    cp 255
    ret z

    ld a, 8
    add d
    ld d, a

    ld a, [bc]
    inc bc
    cp " "
    jr z, Text_PrintTextAsObj

    push bc
    add $10
    ld b, a
    CREATE_OBJECT b, d, e, 0
    pop bc

    jr Text_PrintTextAsObj

; BC = Source
; HL = OAM Starting Point
; D = X Offset
; E = Y Offset
Text_PrintNameAsObj::
    ld a, [bc]
    cp $82
    ret z

    ld a, 8
    add d
    ld d, a

    ld a, [bc]
    inc bc
    cp " "
    jr z, Text_PrintNameAsObj

    push bc
    add $10
    ld b, a
    CREATE_OBJECT b, d, e, 0
    pop bc

    jr Text_PrintNameAsObj



Divisors:
    ds 2
    dw 1
    dw 10
    dw 100
    dw 1000
    dw 10000

; BC = 2 byte number to print
; DE = Print location
Text_PrintNumbers::
    ; Setup
    push de

    xor a
    ld [CountBuffer], a

    ld a, 5
    jr .skipdigit

.nextdigit
    ; Store current digit
    ld d, 0
    ld a, [DigitPointer]
    dec a
    ld e, a
    ld hl, DigitBuffer
    add hl, de

    ld a, [CountBuffer]
    ld [hl], a

    xor a
    ld [CountBuffer], a

    ; Decrement Pointer
    ld a, [DigitPointer]
    dec a
    jr z, .startprint

.skipdigit
    ; Go to next digit
    ld [DigitPointer], a
    add a

    ld hl, Divisors
    add l
    jr nc, .AddHSkip
    inc h
    .AddHSkip
    ld l, a
    
    ld e, [hl]
    inc hl
    ld d, [hl]

.digitCheck
    ; BC >= DE
    ld a, b
    cp d
    jr c, .nextdigit
    jr nz, .subtract
    ld a, c
    cp e
    jr c, .nextdigit

.subtract
    ;  BC – DE
    ld a, c
    sub e
    ld c, a

    ld a, b
    sbc a, d
    ld b, a

    ld a, [CountBuffer]
    inc a
    ld [CountBuffer], a

    jr .digitCheck

.startprint
    pop de
    ld hl, DigitBuffer + 4
    ld b, 5
.loop
    ldh a, [rSTAT]
    and %11
    cp $1
    jp z, .safe
    push bc
    push de
    push hl
    call App_EndOfFrame
    pop hl
    pop de
    pop bc
.safe
    ld a, [hl-]
    add 17
    ld [de], a
    inc de

    dec b
    jr nz, .loop
    ret

Text_NibbleToTile::
    cp 10
    jr c, .Number
    add $12
    ret
.Number
    add $11
    ret

Text_TileToNibble::
    cp 28
    jr c, .Number
    sub $12
    ret
.Number
    sub $11
    ret



; DE = Source
; HL = Destination
; BC = Character Offset
Text_PrintDynamicLine::
    push hl
    call .printloop
    pop hl
    cp 255
    ret z

    push bc
    ld bc, $20
    add hl, bc
    pop bc

    jr Text_PrintDynamicLine

.printloop
    push bc
    push de
    push hl
    call App_EndOfFrame
    pop hl
    pop de
    pop bc

    ld a, [de]
    inc de

    cp 255
    ret z
    cp 254
    ret z
    cp 253
    jr nz, .skip
    push de
    ld d, h
    ld e, l
    ld a, [DynamicLabel+1]
    ld h, a
    ld a, [DynamicLabel]
    ld l, a
    call Text_AniPrintName
    ld h, d
    ld l, e
    pop de
    ld a, [de]
    inc de
    cp 255
    ret z
.skip

    add c
    ld [hl+], a
    jr .printloop