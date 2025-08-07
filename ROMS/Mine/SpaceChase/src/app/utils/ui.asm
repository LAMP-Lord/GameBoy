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

EXPORT UI_DMG.Font
EXPORT UI_DMG.FontEnd
EXPORT UI_DMG.DisplayBox
EXPORT UI_DMG.DisplayBoxEnd
EXPORT UI_DMG.Buttons
EXPORT UI_DMG.ButtonsEnd

EXPORT UI_GBC.Font
EXPORT UI_GBC.FontEnd
EXPORT UI_GBC.DisplayBox
EXPORT UI_GBC.DisplayBoxEnd
EXPORT UI_GBC.Buttons
EXPORT UI_GBC.ButtonsEnd
EXPORT UI_GBC.ButtonsPal
EXPORT UI_GBC.ButtonsPalEnd

SECTION "Utilities - UI - WRAM", WRAM0

Menu::
    .Selector ds 1
    .Items ds 1
MenuItems::
    ds 20
MenuEnd::

C_RED: ds 1
C_GREEN: ds 1
C_BLUE: ds 1

T_RED: ds 1
T_GREEN: ds 1
T_BLUE: ds 1

FadeSteps: ds 1

CurrntBuffer: ds 128
CurrntBufferEnd:
FadeIn_Target::
TargetBuffer: ds 128
FadeIn_TargetEnd::
TargetBufferEnd:

SECTION "Utilities - UI - Graphics", ROM0

UI_DMG::
    .Font INCBIN "generated/dmg/images8/text-font.2bpp"
    .FontEnd

    .DisplayBox INCBIN "generated/dmg/images8/display-box.2bpp"
    .DisplayBoxEnd

    .Buttons INCBIN "generated/dmg/images8/buttons.2bpp"
    .ButtonsEnd

UI_GBC::
    .Font INCBIN "generated/gbc/images8/text-font.2bpp"
    .FontEnd

    .DisplayBox INCBIN "generated/gbc/images8/display-box.2bpp"
    .DisplayBoxEnd

    .Buttons INCBIN "generated/gbc/images8/buttons.2bpp"
    .ButtonsEnd

    .ButtonsPal INCBIN "generated/gbc/images8/buttons.pal"
    .ButtonsPalEnd

SECTION "Utilities - UI - Main", ROM0

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
    ldh a, [ConsoleFlag]
    cp BOOTUP_A_CGB
    jr nz, .dmg

    call GBC_Fade
    ret

.dmg
    ld a, %01_00_00_00
    ld [rBGP], a
    ld [rOBP0], a
    ld [rOBP1], a
    WAIT_FRAMES 8
    ld a, %10_01_00_00
    ld [rBGP], a
    ld [rOBP0], a
    ld [rOBP1], a
    WAIT_FRAMES 8
    ld a, %11_10_01_00
    ld [rBGP], a
    ld [rOBP0], a
    ld [rOBP1], a
    WAIT_FRAMES 24
    ret



UI_FadeOut::
    ldh a, [ConsoleFlag]
    cp BOOTUP_A_CGB
    jp nz, .dmg

    ld d, $FF
    ld hl, FadeIn_Target
    ld bc, FadeIn_TargetEnd - FadeIn_Target
    call Memory_Fill
    call GBC_Fade
    ret

.dmg
    WAIT_FRAMES 24
    ld a, %10_01_00_00
    ld [rBGP], a
    ld [rOBP0], a
    ld [rOBP1], a
    WAIT_FRAMES 8
    ld a, %01_00_00_00
    ld [rBGP], a
    ld [rOBP0], a
    ld [rOBP1], a
    WAIT_FRAMES 8
    ld a, %00_00_00_00
    ld [rBGP], a
    ld [rOBP0], a
    ld [rOBP1], a
    ret
    


GBC_Fade:
    ld a, 32
    ld [FadeSteps], a

    ld a, SPDF_PREPARE
    ld [rSPD], a
    stop

    call App_EndOfFrame
    call CopyToBufferBGP
    call CopyToBufferOBJ

.step
    call App_EndOfFrame
    ld bc, 64
    ld hl, CurrntBuffer
    call UI_GBC_BGP
    call App_EndOfFrame
    ld bc, 64
    ld hl, CurrntBuffer + 64
    call UI_GBC_OBJ
    ld hl, CurrntBuffer

.loop
    ; Read bytes from current
    ld a, [hl+]
    ld e, a
    ld a, [hl]
    ld d, a

    ; Blue
    call .blue
    ld [C_BLUE], a
    ; Green
    call .green
    ld [C_GREEN], a
    ; Red
    call .red
    ld [C_RED], a

    ; Offset to TargetBuffer
    push hl
    ld bc, TargetBuffer - CurrntBuffer
    add hl, bc
    ; Read bytes from target
    ld a, [hl-]
    ld d, a
    ld a, [hl]
    ld e, a
    pop hl

    ; Blue
    call .blue
    ld [T_BLUE], a
    ; Green
    call .green
    ld [T_GREEN], a
    ; Red
    call .red
    ld [T_RED], a

    ; Compare and adjust
    ld a, [C_BLUE]
    ld b, a
    ld a, [T_BLUE]
    call .compare
    ld [C_BLUE], a

    ld a, [C_GREEN]
    ld b, a
    ld a, [T_GREEN]
    call .compare
    ld [C_GREEN], a

    ld a, [C_RED]
    ld b, a
    ld a, [T_RED]
    call .compare
    ld [C_RED], a

    ; Reconstruct low byte   (GGG_BBBBB)
    ld a, [C_GREEN]
    and %00000_111
    swap a
    rla
    ld e, a
    ld a, [C_BLUE]
    or e
    ld e, a

    ; Reconstruct high byte  (0RRRRR_GG)
    ld a, [C_GREEN]
    and %000_11_000
    rra
    rra
    rra
    ld b, a

    ld a, [C_RED]
    rla
    rla
    and %01111100
    or b
    ld d, a

    ; Write bytes
    ld a, d
    ld [hl-], a
    ld a, e
    ld [hl], a
    inc hl
    inc hl

    ; Check if step is complete
    ld de, CurrntBufferEnd
    ld a, l
    cp e
    jp nz, .loop
    ld a, h
    cp d
    jp nz, .loop

    ; Check if fade is complete
    ld a, [FadeSteps]
    dec a
    ld [FadeSteps], a
    jp nz, .step

    ld a, SPDF_PREPARE
    ld [rSPD], a
    stop
    ret

.red
    ld a, d
    rra 
    rra
    and %000_11111
    ret

.green
    ld a, e
    swap a
    rra
    and %00000_111
    ld b, a
    ld a, d
    and %000000_11
    rla
    rla
    rla
    or b
    and %000_11111
    ret

.blue
    ld a, e
    and %000_11111
    ret

.compare
    cp b
    ret z
    jr c, .dec
    inc b
    ld a, b
    ret
.dec
    dec b
    ld a, b
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



; Copies BGP to BGP Buffer
CopyToBufferBGP:
    xor a
    ldh [rBCPS], a
    ld c, a
    ld de, CurrntBuffer
    ld hl, rBCPD
    ld b, 64
.loop
    ld a, [hl]
    ld [de], a
    inc de
    inc c
    ld a, c
    ldh [rBCPS], a
    dec b
    jr nz, .loop
    ret

; Copies OBJ to OBJ Buffer
CopyToBufferOBJ:
    xor a
    ldh [rOCPS], a
    ld c, a
    ld de, CurrntBuffer + 64
    ld hl, rOCPD
    ld b, 64
.loop
    ld a, [hl]
    ld [de], a
    inc c
    ld a, c
    ldh [rOCPS], a
    dec b
    jr nz, .loop
    ret

; HL = Palette Data
; BC = Byte Length
UI_GBC_BGP::
    or a, BGPIF_AUTOINC
    ldh [rBCPS], a
    ld de, rBCPD
    jr GBC_loop

UI_GBC_OBJ::
    or a, OBPIF_AUTOINC
    ldh [rOCPS], a
    ld de, rOCPD
    jr GBC_loop

GBC_loop:
    ld a, [hl+]
    ld [de], a
    dec bc
    ld a, b
    or c
    jr nz, GBC_loop
    ret


; DE = Bytes
; C  = Index
; HL = Destination
; B  = Width (Tiles)
UI_BasicTilemap::
    push bc
.loop
    ld a, c
    ld [hli], a
    inc c
    dec de
    ld a, d
    or e
    jr z, .end
    dec b
    jr nz, .loop ; End of line
    ld a, c
    pop bc
    ld c, a
    ld a, 32
    sub b
    push de
    ld d, 0
    ld e, a
    add hl, de
    pop de
    jr UI_BasicTilemap
.end
    pop bc
    ret

; DE = Source (1bpp)
; HL = Destination (2x Size)
; BC = Bytes
UI_DecompressCopy::
    push bc
    ld a, [de]
    call .DecompressFirstNibble
    call .DecompressSecondNibble
    inc de
    pop bc
    dec bc
    ld a, b
    or c
    jr nz, UI_DecompressCopy
    ret

.DecompressFirstNibble
    ld c, a
.DecompressSecondNibble
    ld b, 4 ; 4 bits -> 8 bits
.loop
    push bc
    rl c ; Extract MSB of c
    rla ; Into LSB of a
    pop bc
    rl c ; Extract that same bit
    rla ; So that bit is inserted twice in a (= horizontally doubled)
    dec b
    jr nz, .loop
    
    ld b, a
    ld a, h
    cp $98
    call z, .reseth
    ld a, b
    ; Note: Adjust palette color by skipping/writing planes (below)
    ld [hli], a
    ld [hli], a
    ; Also double vertically
    ld [hli], a
    ld [hli], a
    ret

.reseth
    ld h, $88
    ret