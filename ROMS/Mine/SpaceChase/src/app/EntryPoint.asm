INCLUDE "include/hardware.inc"
INCLUDE "include/charmap.inc"

SECTION "Entry Point", ROM0

EntryPoint::
    ld a, LCDCF_OFF
    ld [rLCDC], a

    ld a, %11_10_01_00
    ld [rBGP], a

    ; Clear screen
    ld hl, _SCRN0
    ld bc, SCRN_VX_B * SCRN_VY_B
    ld d, $00
    call Memory_Fill

    ; Initialize input variables
    xor a
    ld [sCurKeys], a
    ld [sNewKeys], a
    ld [eCurKeys], a
    ld [eNewKeys], a
    call Input_ResetActionTable

    ; Load stuff into memory
    call UI_Load

    ; Set interrupts
    call Int_InitInterrupts

    ; Set up audio
    ld a, $1
    ld [sMOL_Bank], a
    ld hl, SFX
    call sMOL_init
    call Music_MainTheme
    call Audio_ResetChannels

    ; Place testing boxes
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

    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_WINOFF | LCDCF_BG8800 | LCDCF_BG9800
    ld [rLCDC], a

    call InitInputs

Loop:
    call Int_WaitForVBlank
    jp Loop

; SetButton:
;     ld hl, $98A1
;     call UI_PlacePressedButton

;     call Input_ResetPressActionTable

;     ld a, LOW(UnsetButton)
;     ld [ReleaseAction_A], a
;     ld a, HIGH(UnsetButton)
;     ld [ReleaseAction_A + 1], a

;     ret

; UnsetButton:
;     ld hl, $98A1
;     call UI_PlaceActiveButton

;     call Input_ResetReleaseActionTable

;     ld a, LOW(SetButton)
;     ld [PressAction_A], a
;     ld a, HIGH(SetButton)
;     ld [PressAction_A + 1], a

;     ret

InitInputs:
    ld a, LOW(AOn)
    ld [PressAction_A], a
    ld a, HIGH(AOn)
    ld [PressAction_A + 1], a

    ld a, LOW(AOn)
    ld [PressAction_B], a
    ld a, HIGH(AOn)
    ld [PressAction_B + 1], a

    ld a, LOW(AOn)
    ld [PressAction_Select], a
    ld a, HIGH(AOn)
    ld [PressAction_Select + 1], a

    ld a, LOW(AOn)
    ld [PressAction_Start], a
    ld a, HIGH(AOn)
    ld [PressAction_Start + 1], a



    ld a, LOW(AOn)
    ld [PressAction_Up], a
    ld a, HIGH(AOn)
    ld [PressAction_Up + 1], a

    ld a, LOW(AOn)
    ld [PressAction_Down], a
    ld a, HIGH(AOn)
    ld [PressAction_Down + 1], a

    ld a, LOW(AOn)
    ld [PressAction_Left], a
    ld a, HIGH(AOn)
    ld [PressAction_Left + 1], a

    ld a, LOW(AOn)
    ld [PressAction_Right], a
    ld a, HIGH(AOn)
    ld [PressAction_Right + 1], a

    ret

AOn:
    ld hl, $9821
    ld a, $1C
    ld [hl], a

    ld a, LOW(NopFunction)
    ld [PressAction_A], a
    ld a, HIGH(NopFunction)
    ld [PressAction_A + 1], a

    ld a, LOW(AOff)
    ld [ReleaseAction_A], a
    ld a, HIGH(AOff)
    ld [ReleaseAction_A + 1], a

    ret

AOff:
    ld hl, $9821
    ld a, $0
    ld [hl], a

    ld a, LOW(AOn)
    ld [PressAction_A], a
    ld a, HIGH(AOn)
    ld [PressAction_A + 1], a

    ld a, LOW(NopFunction)
    ld [ReleaseAction_A], a
    ld a, HIGH(NopFunction)
    ld [ReleaseAction_A + 1], a

    ret

BOn:
    ld hl, $9821
    ld a, $1C
    ld [hl], a

    ld a, LOW(NopFunction)
    ld [PressAction_A], a
    ld a, HIGH(NopFunction)
    ld [PressAction_A + 1], a

    ld a, LOW(AOff)
    ld [ReleaseAction_A], a
    ld a, HIGH(AOff)
    ld [ReleaseAction_A + 1], a

    ret

BOff:
    ld hl, $9821
    ld a, $1C
    ld [hl], a

    ld a, LOW(NopFunction)
    ld [PressAction_A], a
    ld a, HIGH(NopFunction)
    ld [PressAction_A + 1], a

    ld a, LOW(AOff)
    ld [ReleaseAction_A], a
    ld a, HIGH(AOff)
    ld [ReleaseAction_A + 1], a

    ret


SelectOn:
    ld hl, $9821
    ld a, $1C
    ld [hl], a

    ld a, LOW(NopFunction)
    ld [PressAction_A], a
    ld a, HIGH(NopFunction)
    ld [PressAction_A + 1], a

    ld a, LOW(AOff)
    ld [ReleaseAction_A], a
    ld a, HIGH(AOff)
    ld [ReleaseAction_A + 1], a

    ret

SelectOff:
    ld hl, $9821
    ld a, $1C
    ld [hl], a

    ld a, LOW(NopFunction)
    ld [PressAction_A], a
    ld a, HIGH(NopFunction)
    ld [PressAction_A + 1], a

    ld a, LOW(AOff)
    ld [ReleaseAction_A], a
    ld a, HIGH(AOff)
    ld [ReleaseAction_A + 1], a

    ret


StartOn:
    ld hl, $9821
    ld a, $1C
    ld [hl], a

    ld a, LOW(NopFunction)
    ld [PressAction_A], a
    ld a, HIGH(NopFunction)
    ld [PressAction_A + 1], a

    ld a, LOW(AOff)
    ld [ReleaseAction_A], a
    ld a, HIGH(AOff)
    ld [ReleaseAction_A + 1], a

    ret

StartOff:
    ld hl, $9821
    ld a, $1C
    ld [hl], a

    ld a, LOW(NopFunction)
    ld [PressAction_A], a
    ld a, HIGH(NopFunction)
    ld [PressAction_A + 1], a

    ld a, LOW(AOff)
    ld [ReleaseAction_A], a
    ld a, HIGH(AOff)
    ld [ReleaseAction_A + 1], a

    ret


UpOn:
    ld hl, $9821
    ld a, $1C
    ld [hl], a

    ld a, LOW(NopFunction)
    ld [PressAction_A], a
    ld a, HIGH(NopFunction)
    ld [PressAction_A + 1], a

    ld a, LOW(AOff)
    ld [ReleaseAction_A], a
    ld a, HIGH(AOff)
    ld [ReleaseAction_A + 1], a

    ret

UpOff:
    ld hl, $9821
    ld a, $1C
    ld [hl], a

    ld a, LOW(NopFunction)
    ld [PressAction_A], a
    ld a, HIGH(NopFunction)
    ld [PressAction_A + 1], a

    ld a, LOW(AOff)
    ld [ReleaseAction_A], a
    ld a, HIGH(AOff)
    ld [ReleaseAction_A + 1], a

    ret


DownOn:
    ld hl, $9821
    ld a, $1C
    ld [hl], a

    ld a, LOW(NopFunction)
    ld [PressAction_A], a
    ld a, HIGH(NopFunction)
    ld [PressAction_A + 1], a

    ld a, LOW(AOff)
    ld [ReleaseAction_A], a
    ld a, HIGH(AOff)
    ld [ReleaseAction_A + 1], a

    ret

DownOff:
    ld hl, $9821
    ld a, $1C
    ld [hl], a

    ld a, LOW(NopFunction)
    ld [PressAction_A], a
    ld a, HIGH(NopFunction)
    ld [PressAction_A + 1], a

    ld a, LOW(AOff)
    ld [ReleaseAction_A], a
    ld a, HIGH(AOff)
    ld [ReleaseAction_A + 1], a

    ret


LeftOn:
    ld hl, $9821
    ld a, $1C
    ld [hl], a

    ld a, LOW(NopFunction)
    ld [PressAction_A], a
    ld a, HIGH(NopFunction)
    ld [PressAction_A + 1], a

    ld a, LOW(AOff)
    ld [ReleaseAction_A], a
    ld a, HIGH(AOff)
    ld [ReleaseAction_A + 1], a

    ret

LeftOff:
    ld hl, $9821
    ld a, $1C
    ld [hl], a

    ld a, LOW(NopFunction)
    ld [PressAction_A], a
    ld a, HIGH(NopFunction)
    ld [PressAction_A + 1], a

    ld a, LOW(AOff)
    ld [ReleaseAction_A], a
    ld a, HIGH(AOff)
    ld [ReleaseAction_A + 1], a

    ret


RightOn:
    ld hl, $9821
    ld a, $1C
    ld [hl], a

    ld a, LOW(NopFunction)
    ld [PressAction_A], a
    ld a, HIGH(NopFunction)
    ld [PressAction_A + 1], a

    ld a, LOW(AOff)
    ld [ReleaseAction_A], a
    ld a, HIGH(AOff)
    ld [ReleaseAction_A + 1], a

    ret

RightOff:
    ld hl, $9821
    ld a, $1C
    ld [hl], a

    ld a, LOW(NopFunction)
    ld [PressAction_A], a
    ld a, HIGH(NopFunction)
    ld [PressAction_A + 1], a

    ld a, LOW(AOff)
    ld [ReleaseAction_A], a
    ld a, HIGH(AOff)
    ld [ReleaseAction_A + 1], a

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