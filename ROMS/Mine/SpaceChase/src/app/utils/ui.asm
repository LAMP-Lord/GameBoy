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
EXPORT DisplayBox
EXPORT DisplayBoxEnd
EXPORT Buttons
EXPORT ButtonsEnd

SECTION "UI          - Variables", WRAM0

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

Menu.Up
    CHECK_BUTTON sNewKeys, PADF_UP
    call Menu.Up_Action
    FALSE
    END_CHECK
    ret

Menu.Up_Action
    call SFX_Play_MenuMove

    ld a, [Menu.Selector]
    cp 0
    ret z
    dec a
    ld [Menu.Selector], a
    ret

Menu.Down
    CHECK_BUTTON sNewKeys, PADF_DOWN
    call Menu.Down_Action
    FALSE
    END_CHECK
    ret

Menu.Down_Action
    call SFX_Play_MenuMove

    ld a, [Menu.Items]
    dec a
    ld b, a
    ld a, [Menu.Selector]
    cp b
    ret z
    inc a
    ld [Menu.Selector], a
    ret



UI_FadeIn::
    ldh a, [CGBFlag]
    cp 1
    jr nz, .dmg

    
    
.dmg
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
    ldh a, [CGBFlag]
    cp 1
    jr nz, .dmg

    

.dmg
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



Fade:





UI_FadeInStarsX::
    ldh a, [CGBFlag]
    cp 1
    jr nz, .dmg

    
    
.dmg
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
    ldh a, [CGBFlag]
    cp 1
    jr nz, .dmg

    
    
.dmg
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



UI_CGB_BGP::
    ld a, BCPSF_AUTOINC
    ldh [rBCPS], a
    ld de, rBCPD
    jr CGB_loop

UI_CGB_OBJ::
    ld a, OCPSF_AUTOINC
    ldh [rOCPS], a
    ld de, rOCPD
    jr CGB_loop

CGB_loop:
    ld a, [hl+]
    ld [de], a
    dec bc
    ld a, b
    or c
    jr nz, CGB_loop
    ret