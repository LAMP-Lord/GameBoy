INCLUDE "include/hardware.inc"
INCLUDE "include/charmap.inc"

SECTION "Entry Point", ROM0

EntryPoint::
    ld a, LCDCF_OFF
    ld [rLCDC], a

    ld a, %11_10_01_00
    ld [rBGP], a

    call UI_Load

    ; Clear screen (tile map at $9800)
    ld hl, _SCRN0
    ld bc, SCRN_VX_B * SCRN_VY_B  ; 32x32 tiles = 1024 bytes
    ld d, $00                     ; Blank tile
    call Memory_Fill

    ld a, 0
    ld [OnCart], a

    ; Initialize input variables
    xor a
    ld [sCurKeys], a
    ld [sNewKeys], a
    ld [eCurKeys], a
    ld [eNewKeys], a

    call Input_ResetActionTable

    ld a, $1
    ld [sMOL_Bank], a

    call Int_InitInterrupts

    ld a, 8
    ld [UI_BoxWidth], a
    ld a, 2
    ld [UI_BoxHeight], a
    ld hl, $9800
    call UI_PlaceBox

    ld a, 12
    ld [UI_BoxWidth], a
    ld a, 1
    ld [UI_BoxHeight], a
    ld hl, $99E0
    call UI_PlaceBox

    ld hl, SFX
    call sMOL_init

    call Music_MainTheme

    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_WINOFF | LCDCF_BG8800 | LCDCF_BG9800
    ld [rLCDC], a

    call Int_WaitForVBlank

    ld de, $9A01
    ld hl, TestText
    call UI_PrintText

    ld de, $98A3
    ld hl, Item1
    call UI_PrintText
    ld de, $98E3
    ld hl, Item2
    call UI_PrintText
    ld de, $9923
    ld hl, Item3
    call UI_PrintText
    ld de, $9963
    ld hl, Item4
    call UI_PrintText

    ld hl, $98A1
    call UI_PlaceActiveButton

    ld hl, $98E1
    call UI_PlacePassiveButton

    ld hl, $9921
    call UI_PlacePassiveButton

    ld hl, $9961
    call UI_PlacePassiveButton

    ld a, LOW(ActionTest)
    ld [ActionA], a
    ld a, HIGH(ActionTest)
    ld [ActionA + 1], a

Loop:
    ; ld a, PADF_A
    ; ld [WaitKeys], a
    ; call Input_WaitForKeyPress

    ; call SFX_Lazer

    ; call Int_WaitForVBlank
    ; ld hl, $98A1
    ; call UI_PlacePressedButton

    ; ld a, PADF_A
    ; ld [WaitKeys], a
    ; call Input_WaitForKeyPress

    ; call Int_WaitForVBlank
    ; ld hl, $98A1
    ; call UI_PlaceActiveButton

    call Int_WaitForVBlank

    jp Loop

ActionTest:
    ld hl, $98A1
    call UI_PlacePressedButton
    ret


SECTION "Test       - Text", ROM0
TestText:
    db "sigma gaming", 255

Item1:
    db "Selected Item", 255

Item2:
    db "Happy", 255

Item3:
    db "Sad", 255

Item4:
    db "Angry", 255


SECTION "Display - Functions", ROM0
DisplayInputs::
    ; --- Standard Inputs (Row 1 at $9800) ---
    ld hl, _SCRN0 + $21          ; $9800
    ld a, [sCurKeys]       ; Load standard inputs
    ld b, a                ; B holds inverted wCurKeys

    ; A (bit 0)
    bit PADB_A, b          ; Test bit 0
    ld a, "A" & $FF
    jr nz, .set_a          ; Bit = 1 -> pressed
    ld a, " " & $FF
.set_a:
    ld [hli], a

    ; B (bit 1)
    bit PADB_B, b
    ld a, "B" & $FF
    jr nz, .set_b
    ld a, " "
.set_b:
    ld [hli], a

    ; Select (bit 2)
    bit PADB_SELECT, b
    ld a, "S" & $FF
    jr nz, .set_select
    ld a, " "
.set_select:
    ld [hli], a

    ; Start (bit 3)
    bit PADB_START, b
    ld a, "T" & $FF
    jr nz, .set_start
    ld a, " "
.set_start:
    ld [hli], a

    ; Right (bit 4)
    bit PADB_RIGHT, b
    ld a, "R" & $FF
    jr nz, .set_right
    ld a, " "
.set_right:
    ld [hli], a

    ; Left (bit 5)
    bit PADB_LEFT, b
    ld a, "L" & $FF
    jr nz, .set_left
    ld a, " "
.set_left:
    ld [hli], a

    ; Up (bit 6)
    bit PADB_UP, b
    ld a, "U" & $FF
    jr nz, .set_up
    ld a, " "
.set_up:
    ld [hli], a

    ; Down (bit 7)
    bit PADB_DOWN, b
    ld a, "D" & $FF
    jr nz, .set_down
    ld a, " "
.set_down:
    ld [hli], a

    ; --- Extra Inputs (Row 2 at $9820) ---
    ld hl, _SCRN0 + SCRN_VX_B + $21  ; $9820
    ld a, [eCurKeys]           ; Load extra inputs
    ld b, a                    ; B holds nCurKeys (active-high)

    ; X (bit 0)
    bit 0, b
    ld a, "X" & $FF
    jr nz, .set_x          ; Bit = 1 -> pressed
    ld a, " "
.set_x:
    ld [hli], a

    ; Y (bit 1)
    bit 1, b
    ld a, "Y" & $FF
    jr nz, .set_y
    ld a, " "
.set_y:
    ld [hli], a

    ; L (bit 4)
    bit 4, b
    ld a, "L" & $FF
    jr nz, .set_l
    ld a, " "
.set_l:
    ld [hli], a

    ; R (bit 5)
    bit 5, b
    ld a, "R" & $FF
    jr nz, .set_r
    ld a, " "
.set_r:
    ld [hli], a

    ; L2 (bit 6)
    bit 6, b
    ld a, "2" & $FF
    jr nz, .set_l2
    ld a, " "
.set_l2:
    ld [hli], a

    ; R2 (bit 7)
    bit 7, b
    ld a, "3" & $FF
    jr nz, .set_r2
    ld a, " "
.set_r2:
    ld [hli], a

    ret