; UI Macros

MACRO WAIT_FRAMES
    ld a, \1
    ld [FrameCounter], a
    call App_WaitFrames
ENDM

MACRO PRINT_MULTILINE
    ld a, BANK(\1)
    ld [BankNumber], a
    PUT_ADDRESS Text_PrintDynamicLine, FunctionPointer

    IF _NARG == 3
        ld bc, \3
        ld de, \1
        ld hl, \2
        call App_CallFromBank

        ld bc, \3 - $A0
        ld de, \1
        ld hl, \2 + $400
        call App_CallFromBank
    ELSE
        ld bc, 0
        ld de, \1
        ld hl, \2
        call App_CallFromBank

        ld bc, 0
        ld de, \1
        ld hl, \2 + $400
        call App_CallFromBank
    ENDC
ENDM

; A  = Byte
; HL = Print Location + 1
MACRO PRINT_HEX
    ld a, \1
    ld hl, \2

    ld b, a
    and $0F

    call Text_NibbleToTile
    ld [hl-], a
    
    ld a, b
    swap a
    and $0F

    call Text_NibbleToTile
    ld [hl], a
ENDM

; HL = Pull Location
MACRO GET_HEX
    ld hl, \1
    ld a, [hl+]
    call Text_TileToNibble
    
    and $0F
    swap a
    ld b, a

    ld a, [hl]
    call Text_TileToNibble
    and $0F
    or b
ENDM

; Utility Macros

; \1 = Byte 1
; \2 = Byte 2
; \3 = Destination
MACRO PUT_16_BITS
    ld a, \1
    ld [\3], a
    ld a, \2
    ld [\3 + 1], a
ENDM

MACRO PUT_ADDRESS
    ld a, LOW(\1)
    ld [\2], a
    ld a, HIGH(\1)
    ld [\2 + 1], a
ENDM