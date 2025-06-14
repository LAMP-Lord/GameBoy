MACRO CREATE_OBJECT
    ld a, \3
    ld [hli], a
    ld a, \2
    ld [hli], a
    ld a, \1
    ld [hli], a
    ld a, \4
    ld [hli], a
ENDM