MACRO SET_ACTION
    ; \1 = destination (e.g. Action_A)
    ; \2 = source label (e.g. AOn)
    ld a, LOW(\2)
    ld [\1], a
    ld a, HIGH(\2)
    ld [\1 + 1], a
ENDM

MACRO CHECK_BUTTON
    ld a, [\1]
    bit \2, a
    jr z, .false
ENDM

MACRO FALSE
.false
ENDM