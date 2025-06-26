; UI Macros

MACRO WAIT_FRAMES
    ld a, \1
    ld [FrameCounter], a
    call App_WaitFrames
ENDM

; A  = Byte
; HL = Print Location + 1
MACRO PRINT_HEX
    ld a, \1
    ld hl, \2

    ld b, a
    and $0F

    call UI_NibbleToTile
    ld [hl-], a
    
    ld a, b
    swap a
    and $0F

    call UI_NibbleToTile
    ld [hl], a
ENDM

; HL = Pull Location
MACRO GET_HEX
    ld hl, \1
    ld a, [hl+]
    call UI_TileToNibble
    
    and $0F
    swap a
    ld b, a

    ld a, [hl]
    call UI_TileToNibble
    and $0F
    or b
ENDM

; Utility Macros

; \1 = Byte 1
; \2 = Byte 2
; \3 = Destination
MACRO PUT_16_BITS
    ld hl, \3
    ld a, \1
    ld [hli], a
    ld a, \2
    ld [hl], a
ENDM