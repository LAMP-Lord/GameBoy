; Action Macros

; \1 = destination (e.g. Action_A)
; \2 = source label (e.g. AOn)
MACRO SET_ACTION
    ld a, LOW(\2)
    ld [\1], a
    ld a, HIGH(\2)
    ld [\1 + 1], a
ENDM

; Button Confirmation Macros

; \1 = Input Set (e.g. sNewKeys)
; \2 = Input Bit (e.g. PADB_A)
MACRO CHECK_BUTTON
    ldh a, [\1]
    bit \2, a
    jr z, :+
ENDM

; Must be used with CHECK_BUTTON
MACRO FALSE
    jr :++
:
ENDM

MACRO END_CHECK
:
ENDM