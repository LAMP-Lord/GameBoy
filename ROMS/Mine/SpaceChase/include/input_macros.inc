; \1 = destination (e.g. Action_A)
; \2 = source label (e.g. AOn)
MACRO SET_ACTION
    ld a, LOW(\2)
    ld [\1], a
    ld a, HIGH(\2)
    ld [\1 + 1], a
ENDM

; \1 = Input Set (e.g. sNewKeys)
; \2 = Input Bit (e.g. PADB_A)
MACRO CHECK_BUTTON
    ld a, [\1]
    bit \2, a
    jr z, .false
ENDM

; Must be used with CHECK_BUTTON
MACRO FALSE
.false
ENDM