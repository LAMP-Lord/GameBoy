INCLUDE "hardware.inc"
INCLUDE "charmap.inc"
INCLUDE "macros/input_macros.inc"
INCLUDE "macros/sprite_macros.inc"
INCLUDE "macros/extra_macros.inc"
INCLUDE "macros/menu_macros.inc"

EXPORT Keyboard.LeaveKeyMode
EXPORT Keyboard.ExitCheck
EXPORT Keyboard.SelectKey
EXPORT Keyboard.Up
EXPORT Keyboard.Down
EXPORT Keyboard.Left
EXPORT Keyboard.Right
EXPORT Keyboard.LoadState
EXPORT Keyboard.SaveState

EXPORT TitleScreen_ScrollingAnimation.resetship

SECTION "TitleScreen - Helper Functions", ROMX, BANK[$1]

Keyboard::
.LeaveKeyMode
    call Keyboard.SaveState
    SET_ACTION Actions.DrawAddress, SetupMenu.Draw

    SET_ACTION Actions.Up, SetupMenu.Up
    SET_ACTION Actions.Down, SetupMenu.Down
    SET_ACTION Actions.Left, NopFunction
    SET_ACTION Actions.Right, NopFunction
    
    SET_ACTION Actions.A, NopFunction
    SET_ACTION Actions.B, SetupMenu.Exit
    ret

.ExitCheck
    CHECK_BUTTON sDrpKeys, PADF_B
    jr Keyboard.LeaveKeyMode
    FALSE
    END_CHECK
    ret

.SelectKey
    CHECK_BUTTON sDrpKeys, PADF_A
    ld a, [OAM_DMA+2]
    cp $1B
    jr nz, .skipUndo

    ld a, [TS_CurCharacters]
    cp 0
    jr z, .maxcharactersreached
    dec a
    ld [TS_CurCharacters], a

    ld a, [TS_PrintLocation]
    ld h, a
    ld a, [TS_PrintLocation+1]
    ld l, a
    
    ld a, $82
    dec hl
    ld [hl], a

    ld a, h
    ld [TS_PrintLocation], a
    ld a, l
    ld [TS_PrintLocation+1], a
    jr .maxcharactersreached
.skipUndo

    ld a, [OAM_DMA+2]
    cp $62
    jp z, Keyboard.LeaveKeyMode

    ld a, [TS_MaxCharacters]
    ld b, a
    ld a, [TS_CurCharacters]
    cp b
    jr z, .maxcharactersreached

    inc a
    ld [TS_CurCharacters], a
    ld a, [TS_PrintLocation]
    ld h, a
    ld a, [TS_PrintLocation+1]
    ld l, a
    ld a, [OAM_DMA+2]
    sub $10
    ld [hli], a
    ld a, h
    ld [TS_PrintLocation], a
    ld a, l
    ld [TS_PrintLocation+1], a
    FALSE
    END_CHECK
.maxcharactersreached
    ret



.Up
    CHECK_BUTTON sNewKeys, PADF_UP
    ld a, [OAM_DMA]
    cp 108
    jr z, .loopUp

    ld a, [OAM_DMA]
    cp 124
    jr nz, .skipSpecialUp
    ld a, [OAM_DMA+2]
    add $25
    ld [OAM_DMA+2], a
.skipSpecialUp

    ; ID
    ld a, [OAM_DMA+2]
    sub 13
    ld b, a
    ; X
    ld a, [OAM_DMA+1]
    ld c, a
    ; Y
    ld a, [OAM_DMA]
    sub 8
    ld d, a
    ; Store values
    ld hl, OAM_DMA
    CREATE_OBJECT b, c, d, 0
    FALSE
    END_CHECK
    ret

.loopUp
    ; ID
    ld a, [OAM_DMA+2]
    sub 11
    ld b, a
    ; X
    ld a, [OAM_DMA+1]
    ld c, a
    ; Y
    ld a, [OAM_DMA]
    add 16
    ld d, a
    ; Store values
    ld hl, OAM_DMA
    CREATE_OBJECT b, c, d, 0
    ret

.Down
    CHECK_BUTTON sNewKeys, PADF_DOWN
    ld a, [OAM_DMA]
    cp 124
    jr z, .loopDown

    ld a, [OAM_DMA]
    cp 116
    jr nz, .skipSpecialDown
    ld a, [OAM_DMA+2]
    sub $25
    ld [OAM_DMA+2], a
.skipSpecialDown

    ; ID
    ld a, [OAM_DMA+2]
    add 13
    ld b, a
    ; X
    ld a, [OAM_DMA+1]
    ld c, a
    ; Y
    ld a, [OAM_DMA]
    add 8
    ld d, a
    ; Store values
    ld hl, OAM_DMA
    CREATE_OBJECT b, c, d, 0
    FALSE
    END_CHECK
    call .DetermineSpecialCharacter
    ret

.loopDown
    ; ID
    ld a, [OAM_DMA+2]
    add 11
    ld b, a
    ; X
    ld a, [OAM_DMA+1]
    cp 132
    jr nz, .skipM
    ld a, $38
    ld b, a
.skipM
    cp 124
    jr nz, .skipL
    ld a, $37
    ld b, a
.skipL
    cp 116
    jr nz, .skipK
    ld a, $36
    ld b, a
.skipK
    ld a, [OAM_DMA+1]
    ld c, a
    ; Y
    ld a, [OAM_DMA]
    sub 16
    ld d, a
    ; Store values
    ld hl, OAM_DMA
    CREATE_OBJECT b, c, d, 0
    ret

.Left
    CHECK_BUTTON sNewKeys, PADF_LEFT
    ld a, [OAM_DMA+1]
    cp 36
    jr z, .loopLeft
    ; ID
    ld a, [OAM_DMA+2]
    dec a
    ld b, a
    ; X
    ld a, [OAM_DMA+1]
    sub 8
    ld c, a
    ; Y
    ld a, [OAM_DMA]
    ld d, a
    ; Store values
    ld hl, OAM_DMA
    CREATE_OBJECT b, c, d, 0
    FALSE
    END_CHECK
    ret

.loopLeft
    ; ID
    ld a, [OAM_DMA+2]
    add 12
    ld b, a
    ; X
    ld a, [OAM_DMA+1]
    add 96
    ld c, a
    ; Y
    ld a, [OAM_DMA]
    ld d, a
    ; Store values
    ld hl, OAM_DMA
    CREATE_OBJECT b, c, d, 0
    ret

.Right
    CHECK_BUTTON sNewKeys, PADF_RIGHT
    ld a, [OAM_DMA+1]
    cp 132
    jr z, .loopRight
    ; ID
    ld a, [OAM_DMA+2]
    inc a
    ld b, a
    ; X
    ld a, [OAM_DMA+1]
    add 8
    ld c, a
    ; Y
    ld a, [OAM_DMA]
    ld d, a
    ; Store values
    ld hl, OAM_DMA
    CREATE_OBJECT b, c, d, 0
.skipRight
    FALSE
    END_CHECK
    ret

.loopRight
    ; ID
    ld a, [OAM_DMA+2]
    sub 12
    ld b, a
    ; X
    ld a, [OAM_DMA+1]
    sub 96
    ld c, a
    ; Y
    ld a, [OAM_DMA]
    cp 124
    jr nz, .skip0
    ld a, $21
    ld b, a
.skip0
    ld a, [OAM_DMA]
    ld d, a
    ; Store values
    ld hl, OAM_DMA
    CREATE_OBJECT b, c, d, 0
    ret



.DetermineSpecialCharacter
    ld a, [OAM_DMA]
    cp 124
    jr nz, .skipSpecialCharacters

    ; 9
    ld a, [OAM_DMA+1]
    cp 108
    jr nz, .skip9
    ld a, $2A
    ld [OAM_DMA+2], a
.skip9
    ; Space
    ld a, [OAM_DMA+1]
    cp 116
    jr nz, .skipSpace
    ld a, $10
    ld [OAM_DMA+2], a
.skipSpace
    ; Backspace
    ld a, [OAM_DMA+1]
    cp 124
    jr nz, .skipBack
    ld a, $1B
    ld [OAM_DMA+2], a
.skipBack
    ; Confirm
    ld a, [OAM_DMA+1]
    cp 132
    jr nz, .skipSpecialCharacters
    CHECK_BUTTON sCurKeys, PADF_A
    ld a, $62
    ld [OAM_DMA+2], a
    FALSE
    ld a, $60
    ld [OAM_DMA+2], a
    END_CHECK
.skipSpecialCharacters
    ld a, [OAM_DMA]
    cp 116
    jr nz, .skipXYZ

    ; X
    ld a, [OAM_DMA+1]
    cp 116
    jr nz, .skipX
    ld a, $43
    ld [OAM_DMA+2], a
.skipX
    ; Y
    ld a, [OAM_DMA+1]
    cp 124
    jr nz, .skipY
    ld a, $44
    ld [OAM_DMA+2], a
.skipY
    ; Z
    ld a, [OAM_DMA+1]
    cp 132
    jr nz, .skipXYZ
    ld a, $45
    ld [OAM_DMA+2], a
.skipXYZ
    ret

; A  = TS_Index
; DE = Print Location
.LoadState
    ld [TS_Index], a
    ld hl, TS_PrintLocationTable
    ld c, a
    ld b, 0
    add hl, bc
    add hl, bc

    ld a, [hli]
    ld b, a
    ld a, [hl]

    and b
    jr z, .useDefault

    ld a, b
    ld [TS_PrintLocation], a
    ld a, [hl]
    ld [TS_PrintLocation+1], a
    jr .endLoadState

.useDefault
    PUT_16_BITS d, e, TS_PrintLocation

.endLoadState
    ld hl, TS_CurCharactersTable
    ld a, [TS_Index]
    add l
    ld l, a
    ld a, [hl]
    ld [TS_CurCharacters], a

    ld a, 108
    ld [OAM_DMA],   a
    ld a, 36
    ld [OAM_DMA+1], a
    ld a, $2C
    ld [OAM_DMA+2], a
    ret

.SaveState
    ld hl, TS_PrintLocationTable
    ld a, [Menu.Selector]
    ld c, a
    ld b, 0
    add hl, bc
    add hl, bc
    ld a, [TS_PrintLocation]
    ld [hli], a
    ld a, [TS_PrintLocation+1]
    ld [hl], a

    ld hl, TS_CurCharactersTable
    ld a, [Menu.Selector]
    add l
    ld l, a
    ld a, [TS_CurCharacters]
    ld [hl], a
    ret



TitleScreen_DrawPopup::
    ld de, TS_Graphics.BoxTileMapLeft
    ld hl, $9E40
.leftrow
    ld a, [de]
    cp 255
    jr z, .leftdone

    ld a, [de]
    cp 254
    jr nz, .skipresetleft
    inc de
    ld a, l
    and $1F
    ld l, a
    ld h, HIGH($9C00)
.skipresetleft

    ld b, 2
.leftcol
    ldh a, [rSTAT]
    and %11
    cp $1
    call nz, .notSafe

    ld a, [de]
    inc de
    ld [hl+], a

    dec b
    jr nz, .leftcol
    
    ld bc, 32 - 2
    add hl, bc

    jr .leftrow
.leftdone   

    ld de, TS_Graphics.BoxTileMapRight
    ld hl, $9E51
.rightrow
    ld a, [de]
    cp 255
    jr z, .rightdone

    ld a, [de]
    cp 254
    jr nz, .skipresetright
    inc de
    ld a, l
    and $1F
    ld l, a
    ld h, HIGH($9C00)
.skipresetright

    ld b, 15
.rightcol
    ldh a, [rSTAT]
    and %11
    cp $1
    call nz, .notSafe

    ld a, [de]
    inc de
    ld [hl+], a

    dec b
    jr nz, .rightcol
    
    ld bc, 32 - 15
    add hl, bc

    jr .rightrow
.rightdone
    ret

.notSafe
    push de
    push hl
    push bc
    call App_EndOfFrame
    pop bc
    pop hl
    pop de
    ret



TitleScreen_ScrollingAnimation::
    SET_ACTION Actions.DrawAddress, TitleScreen_MainMenuDraw
.loop
    push bc
    call App_EndOfFrame
    pop bc

    ld a, b
    cp 100
    jp nz, .skip_addtile

    ld a, $F6
    ld [$99B1], a
    ld a, $F7
    ld [$99B2], a

.skip_addtile
    ldh a, [rSCX]
    inc a
    ldh [rSCX], a

    ldh a, [rSCY]
    dec a
    ldh [rSCY], a

    ld hl, OAM_DMA + 1
    ld c, 15
    call .moveallright

    dec b
    jr nz, .loop
    ret

.moveallright
    ld a, [hl]
    inc a
    ld [hl], a

    inc hl
    inc hl
    inc hl
    inc hl

    dec c
    jr nz, .moveallright
    ret

.resetship
    call App_ResetOAM

    ld hl, OAM_DMA
    CREATE_OBJECT 1, 204, 72, 0
    CREATE_OBJECT 2, 204, 80, 0
    CREATE_OBJECT 3, 204, 88, 0

    CREATE_OBJECT 4, 212, 72, 0
    CREATE_OBJECT 5, 212, 80, 0
    CREATE_OBJECT 6, 212, 88, 0

    CREATE_OBJECT 7, 220, 72, 0
    CREATE_OBJECT 8, 220, 80, 0

    CREATE_OBJECT 9, 228, 64, 0
    CREATE_OBJECT 10, 228, 72, 0
    CREATE_OBJECT 11, 228, 80, 0

    CREATE_OBJECT 12, 236, 64, 0
    CREATE_OBJECT 13, 236, 72, 0
    CREATE_OBJECT 14, 236, 80, 0
    CREATE_OBJECT 15, 244, 72, 0
    ret