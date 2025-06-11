INCLUDE "include/hardware.inc"
INCLUDE "include/charmap.inc"
INCLUDE "include/inputmacros.inc"

SECTION "Entry Point", ROM0

EntryPoint::
    ld a, LCDCF_OFF
    ld [rLCDC], a

    ld a, %11_10_01_00
    ld [rBGP], a

    ; Clear screen
    ; ld hl, _SCRN0
    ; ld bc, SCRN_VX_B * SCRN_VY_B
    ; ld d, $00
    ; call Memory_Fill

    ; Load stuff into memory
    call UI_Load

    ; Initialize input variables
    xor a
    ld [sCurKeys], a
    ld [sNewKeys], a
    ld [eCurKeys], a
    ld [eNewKeys], a
    call Input_ResetActionTable

    ; Set interrupts
    call Int_InitInterrupts

    ; Set up audio
    ld a, $1
    ld [sMOL_Bank], a
    ld hl, SFX
    call sMOL_init
    call Music_MainTheme
    call Audio_ResetChannels

    call UI_TitleScreenOpen

    ; Place testing boxes
    ; ld a, 8
    ; ld [UI_BoxWidth], a
    ; ld a, 2
    ; ld [UI_BoxHeight], a
    ; ld hl, $9800
    ; call UI_PlaceBox

    ; ld a, 12
    ; ld [UI_BoxWidth], a
    ; ld a, 1
    ; ld [UI_BoxHeight], a
    ; ld hl, $99E0
    ; call UI_PlaceBox

    ; ld de, $9A01
    ; ld hl, TestText
    ; call UI_PrintText

    ; ld de, $98A3
    ; ld hl, Item1
    ; call UI_PrintText
    ; ld de, $98E3
    ; ld hl, Item2
    ; call UI_PrintText
    ; ld de, $9923
    ; ld hl, Item3
    ; call UI_PrintText
    ; ld de, $9963
    ; ld hl, Item4
    ; call UI_PrintText

    ; ld hl, $98A1
    ; call UI_PlaceActiveButton

    ; ld hl, $98E1
    ; call UI_PlacePassiveButton

    ; ld hl, $9921
    ; call UI_PlacePassiveButton

    ; ld hl, $9961
    ; call UI_PlacePassiveButton

    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_WINOFF | LCDCF_BG8800 | LCDCF_BG9800
    ld [rLCDC], a

    call InitInputs

Loop:
    call Int_WaitForVBlank
    jp Loop



InitInputs:
    SET_ACTION Action_A, ButtonA
    SET_ACTION Action_B, ButtonB
    SET_ACTION Action_Select, ButtonSelect
    SET_ACTION Action_Start, ButtonStart

    SET_ACTION Action_Up, ButtonUp
    SET_ACTION Action_Down, ButtonDown
    SET_ACTION Action_Left, ButtonLeft
    SET_ACTION Action_Right, ButtonRight

    SET_ACTION Action_X, ButtonX
    SET_ACTION Action_Y, ButtonY

    SET_ACTION Action_L1, ButtonL
    SET_ACTION Action_L2, ButtonL2
    SET_ACTION Action_R1, ButtonR
    SET_ACTION Action_R2, ButtonR2

    ret



ButtonA:
    CHECK_BUTTON sNewKeys, PADB_A
    call SFX_Lazer
    ld hl, $9821
    ld a, $1C
    ld [hl], a
    ld hl, $98A1
    ld a, $59
    ld [hl], a
    ret
    
    FALSE
    ld hl, $9821
    ld a, $0
    ld [hl], a
    ld hl, $98A1
    ld a, $57
    ld [hl], a
    ret



ButtonB:
    CHECK_BUTTON sCurKeys, PADB_B
    ld hl, $9822
    ld a, $1D
    ld [hl], a
    ret
    
    FALSE
    ld hl, $9822
    ld a, $0
    ld [hl], a
    ret



ButtonSelect:
    CHECK_BUTTON sCurKeys, PADB_SELECT
    ld hl, $9823
    ld a, $2E
    ld [hl], a
    ret
    
    FALSE
    ld hl, $9823
    ld a, $0
    ld [hl], a
    ret



ButtonStart:
    CHECK_BUTTON sCurKeys, PADB_START
    ld hl, $9824
    ld a, $2F
    ld [hl], a
    ret
    
    FALSE
    ld hl, $9824
    ld a, $0
    ld [hl], a
    ret



ButtonUp:
    CHECK_BUTTON sCurKeys, PADB_UP
    ld hl, $9825
    ld a, $30
    ld [hl], a
    ret
    
    FALSE
    ld hl, $9825
    ld a, $0
    ld [hl], a
    ret



ButtonDown:
    CHECK_BUTTON sCurKeys, PADB_DOWN
    ld hl, $9826
    ld a, $1F
    ld [hl], a
    ret
    
    FALSE
    ld hl, $9826
    ld a, $0
    ld [hl], a
    ret



ButtonLeft:
    CHECK_BUTTON sCurKeys, PADB_LEFT
    ld hl, $9827
    ld a, $27
    ld [hl], a
    ret
    
    FALSE
    ld hl, $9827
    ld a, $0
    ld [hl], a
    ret



ButtonRight:
    CHECK_BUTTON sCurKeys, PADB_RIGHT
    ld hl, $9828
    ld a, $2D
    ld [hl], a
    ret
    
    FALSE
    ld hl, $9828
    ld a, $0
    ld [hl], a
    ret



ButtonX:
    CHECK_BUTTON eCurKeys, PADB_X
    ld hl, $9841
    ld a, $33
    ld [hl], a
    ret
    
    FALSE
    ld hl, $9841
    ld a, $0
    ld [hl], a
    ret



ButtonY:
    CHECK_BUTTON eCurKeys, PADB_Y
    ld hl, $9842
    ld a, $34
    ld [hl], a
    ret
    
    FALSE
    ld hl, $9842
    ld a, $0
    ld [hl], a
    ret



ButtonL:
    CHECK_BUTTON eCurKeys, PADB_L
    ld hl, $9843
    ld a, $27
    ld [hl], a
    ret
    
    FALSE
    ld hl, $9843
    ld a, $0
    ld [hl], a
    ret



ButtonL2:
    CHECK_BUTTON eCurKeys, PADB_L2
    ld hl, $9844
    ld a, $13
    ld [hl], a
    ret
    
    FALSE
    ld hl, $9844
    ld a, $0
    ld [hl], a
    ret



ButtonR:
    CHECK_BUTTON eCurKeys, PADB_R
    ld hl, $9845
    ld a, $2D
    ld [hl], a
    ret
    
    FALSE
    ld hl, $9845
    ld a, $0
    ld [hl], a
    ret



ButtonR2:
    CHECK_BUTTON eCurKeys, PADB_R2
    ld hl, $9846
    ld a, $14
    ld [hl], a
    ret
    
    FALSE
    ld hl, $9846
    ld a, $0
    ld [hl], a
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