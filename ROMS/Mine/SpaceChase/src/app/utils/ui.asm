INCLUDE "hardware.inc"
INCLUDE "charmap.inc"
INCLUDE "macros/input_macros.inc"
INCLUDE "macros/extra_macros.inc"
INCLUDE "macros/sprite_macros.inc"

EXPORT Menu.Selector
EXPORT Menu.Items
EXPORT Menu.DrawAddress

EXPORT Menu.Up
EXPORT Menu.Down
EXPORT Menu.Up_Action
EXPORT Menu.Down_Action

EXPORT Font
EXPORT FontEnd
EXPORT Buttons
EXPORT ButtonsEnd

SECTION "UI          - Variables", WRAM0

Menu::
    .Selector ds 1
    .Items ds 1
MenuItems::
    ds 20
MenuEnd::

DigitPointer: ds 1
CountBuffer: ds 1
DigitBuffer: ds 5

SECTION "UI          - Graphics", ROM0

Font: INCBIN "generated/ui/text-font.2bpp"
FontEnd:

DisplayBox: INCBIN "generated/ui/display-box.2bpp"
DisplayBoxEnd:

Buttons: INCBIN "generated/ui/buttons.2bpp"
ButtonsEnd:

SECTION "UI          - Functions", ROM0

Menu.Up
    CHECK_BUTTON sNewKeys, PADB_UP
    call Menu.Up_Action
    FALSE
    END_CHECK
    ret

Menu.Up_Action
    ld a, [Menu.Selector]
    cp 0
    ret z
    dec a
    ld [Menu.Selector], a
    ret

Menu.Down
    CHECK_BUTTON sNewKeys, PADB_DOWN
    call Menu.Down_Action
    FALSE
    END_CHECK
    ret

Menu.Down_Action
    ld a, [Menu.Items]
    dec a
    ld b, a
    ld a, [Menu.Selector]
    cp b
    ret z
    inc a
    ld [Menu.Selector], a
    ret

UI_Load::
    ld de, Font
    ld hl, _VRAM9000
    ld bc, FontEnd - Font 
    call Memory_Copy

    ld de, DisplayBox
    ld bc, DisplayBoxEnd - DisplayBox 
    call Memory_Copy

    ld de, Buttons
    ld bc, ButtonsEnd - Buttons 
    call Memory_Copy

    ret



; 255: End Character
; HL: Text Location
; DE: Print Location
UI_PrintText::
    ld a, [hl+]
    cp 255
    ret z

    ld [de], a
    inc de

    jr UI_PrintText

UI_AniPrintText::
    push de
    push hl
    call App_EndOfFrame
    pop hl
    pop de

    ld a, [hl+]
    cp 255
    ret z

    ld [de], a
    inc de

    jr UI_AniPrintText

UI_SafePrintText::
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

    jr UI_SafePrintText

UI_AniPrintName::
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

    ld [de], a
    inc de

    jr UI_AniPrintName

; BC = Source
; HL = OAM Starting Point
; D = X Offset
; E = Y Offset
UI_PrintTextAsObj::
    ld a, [bc]
    cp 255
    ret z

    ld a, 8
    add d
    ld d, a

    ld a, [bc]
    inc bc
    cp " "
    jr z, UI_PrintTextAsObj

    push bc
    add $10
    ld b, a
    CREATE_OBJECT b, d, e, 0
    pop bc

    jr UI_PrintTextAsObj

; BC = Source
; HL = OAM Starting Point
; D = X Offset
; E = Y Offset
UI_PrintNameAsObj::
    ld a, [bc]
    cp $82
    ret z

    ld a, 8
    add d
    ld d, a

    ld a, [bc]
    inc bc
    cp " "
    jr z, UI_PrintNameAsObj

    push bc
    add $10
    ld b, a
    CREATE_OBJECT b, d, e, 0
    pop bc

    jr UI_PrintNameAsObj



Divisors:
    ds 2
    dw 1
    dw 10
    dw 100
    dw 1000
    dw 10000

; BC = 2 byte number to print
; DE = Print location
UI_PrintNumbers::
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



UI_FadeIn::
    ld a, %01_00_00_00
    ld [rBGP], a
    ld [rOBP0], a
    ld [rOBP1], a

    WAIT_FRAMES 5
    
    ld a, %10_01_00_00
    ld [rBGP], a
    ld [rOBP0], a
    ld [rOBP1], a

    WAIT_FRAMES 5
    
    ld a, %11_10_01_00
    ld [rBGP], a
    ld [rOBP0], a
    ld [rOBP1], a
    
    ret

UI_FadeOut::
    ld a, %10_01_00_00
    ld [rBGP], a
    ld [rOBP0], a
    ld [rOBP1], a

    WAIT_FRAMES 5

    ld a, %01_00_00_00
    ld [rBGP], a
    ld [rOBP0], a
    ld [rOBP1], a

    WAIT_FRAMES 5

    ld a, %00_00_00_00
    ld [rBGP], a
    ld [rOBP0], a
    ld [rOBP1], a

    ret

UI_FadeInStarsX::
    ld a, %11_10_11_10
    ld [rBGP], a
    ld [rOBP0], a
    ld [rOBP1], a

    WAIT_FRAMES 5

    ld a, %11_10_10_01
    ld [rBGP], a
    ld [rOBP0], a
    ld [rOBP1], a

    WAIT_FRAMES 5

    ld a, %11_10_01_00
    ld [rBGP], a
    ld [rOBP0], a
    ld [rOBP1], a

    ret

UI_FadeOutStarsX::
    ld a, %11_10_10_01
    ld [rBGP], a
    ld [rOBP0], a
    ld [rOBP1], a

    WAIT_FRAMES 5
    
    ld a, %11_10_11_10
    ld [rBGP], a
    ld [rOBP0], a
    ld [rOBP1], a

    WAIT_FRAMES 5
    
    ld a, %11_10_11_11
    ld [rBGP], a
    ld [rOBP0], a
    ld [rOBP1], a
    
    ret

    

UI_NibbleToTile::
    cp 10
    jr c, .Number
    add $12
    ret
.Number
    add $11
    ret

UI_TileToNibble::
    cp 28
    jr c, .Number
    sub $12
    ret
.Number
    sub $11
    ret