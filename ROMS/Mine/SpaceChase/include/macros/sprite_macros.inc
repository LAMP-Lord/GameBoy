; \1 = Tile ID
; \2 = X
; \3 = Y
; \4 = Attributes
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

