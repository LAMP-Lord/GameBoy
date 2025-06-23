INCLUDE "hardware.inc"
INCLUDE "charmap.inc"
INCLUDE "macros/input_macros.inc"
INCLUDE "macros/extra_macros.inc"

EXPORT Menu.Selector
EXPORT Menu.Items
EXPORT Menu.DrawAddress

SECTION "UI          - Menu Variables", WRAM0

Menu::
    .Selector ds 1
    .Items ds 1
MenuItems::
    ds 20
MenuEnd::

SECTION "UI          - Graphics", ROM0

Font: INCBIN "generated/ui/text-font.2bpp"
FontEnd:

DisplayBox: INCBIN "generated/ui/display-box.2bpp"
DisplayBoxEnd:

Buttons: INCBIN "generated/ui/buttons.2bpp"
ButtonsEnd:

SECTION "UI          - Functions", ROM0

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

UI_SafePrintText::
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

    jr UI_SafePrintText

Menu_Up::
    CHECK_BUTTON sNewKeys, PADB_UP
    ld a, [Menu.Selector]
    cp 0
    ret z

    dec a
    ld [Menu.Selector], a
    FALSE
    END_CHECK
    ret

Menu_Down::
    CHECK_BUTTON sNewKeys, PADB_DOWN
    ld a, [Menu.Items]
    dec a
    ld b, a

    ld a, [Menu.Selector]
    cp b
    ret z

    inc a
    ld [Menu.Selector], a
    FALSE
    END_CHECK
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