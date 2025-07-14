; Menu Index Macros

; \1 = Menu Index (e.g. 2)
MACRO IS_MENU_INDEX
    ld a, [Menu.Selector]
    cp \1
    jr nz, .skip\1
ENDM

; \1 = Menu Index
; Must be used with IS_MENU_INDEX
MACRO NOT_MENU_INDEX
.skip\1
ENDM

; Button Placement Macros

; \1 = Button Location
MACRO PRESSED_BUTTON
    ld a, $59
    ld [\1], a

    ld a, 1
    ldh [rVBK], a

    ld a, %0000_0_010
    ld [\1], a

    ld a, 0
    ldh [rVBK], a
ENDM

MACRO ACTIVE_BUTTON
    ld a, $57
    ld [\1], a
    
    ld a, 1
    ldh [rVBK], a

    ld a, %0000_0_010
    ld [\1], a

    ld a, 0
    ldh [rVBK], a
ENDM

MACRO INACTIVE_BUTTON
    ld a, $58
    ld [\1], a

    ld a, 1
    ldh [rVBK], a

    ld a, %0000_0_010
    ld [\1], a

    ld a, 0
    ldh [rVBK], a
ENDM