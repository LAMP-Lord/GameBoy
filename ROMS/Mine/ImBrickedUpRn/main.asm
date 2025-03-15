INCLUDE "hardware.inc"

DEF BRICK_LEFT EQU $05
DEF BRICK_RIGHT EQU $06
DEF BLANK_TILE EQU $08

; Reserves room for the Header Information
; Sent here (Address $0100) from the Boot ROM
SECTION "Header", ROM0[$100]
    jp EntryPoint
    ds $150 - @, 0 ; Replace the next 150 bytes w/ $00 (i think?)

EntryPoint:

    ; Do not turn the LCD off outside of VBlank
    ; I'm told this can damage actual equipment
WaitVBlank:
    ld a, [rLY]
    cp 144
    jp c, WaitVBlank

    ; Turn the LCD off
    ld a, 0
    ld [rLCDC], a



    ; Copy the tile data
    ld de, Tiles            ; "de" Register = Start Address of Tiles / Pointer
    ld hl, $9000            ; "hl" Register = VRAM Address
    ld bc, TilesEnd - Tiles ; "bc" Register = Total Size of Tiles
    call Memcopy

    ; Copy the tilemap
    ld de, Tilemap              ; "de" Register = Start Address of Tilemap
    ld hl, $9800                ; "hl" Register = VRAM Address
    ld bc, TilemapEnd - Tilemap ; "bc" Register = Total Size of Tilemap
    call Memcopy

    ; Copy the paddle tile || You get it at this point
    ld de, Paddle
    ld hl, $8000
    ld bc, PaddleEnd - Paddle
    call Memcopy

    ; Copy the ball tile
    ld de, Ball
    ld hl, $8010
    ld bc, BallEnd - Ball
    call Memcopy

    

    ; Clear OAM (Object Attribute Memory)
    ld a, 0         ; Empty value
    ld b, 160       ; Full size of OAM
    ld hl, _OAMRAM  ; Location of OAM

ClearOam:
    ld [hli], a     ; Set location to 0
    dec b           ; Decrement counter
    jp nz, ClearOam ; Loop when not equal to zero

    ; Write particle to OAM
    ld hl, _OAMRAM 
    ld a, 128 + 16
    ld [hli], a
    ld a, 16 + 8
    ld [hli], a
    ld a, 0
    ld [hli], a
    ld [hli], a



    ; Turn the LCD on
    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON
    ld [rLCDC], a

    ; During the first (blank) frame, initialize display registers
    ld a, %11100100
    ld [rBGP], a
    ld a, %11100100
    ld [rOBP0], a



    ; Initialize global variables
    ld a, 0
    ld [wFrameCounter], a
    ld [wCurKeys], a
    ld [wNewKeys], a
    ld [wBounced], a



Main:
    ld a, [rLY]
    cp 144
    jp nc, Main
WaitVBlank2:
    ld a, [rLY]
    cp 144
    jp c, WaitVBlank2

    ; Add the ball's momentum to its position in OAM.
    ld a, [wBallMomentumX]
    ld b, a
    ld a, [_OAMRAM + 5]
    add a, b
    ld [_OAMRAM + 5], a

    ld a, [wBallMomentumY]
    ld b, a
    ld a, [_OAMRAM + 4]
    add a, b
    ld [_OAMRAM + 4], a

    ld [wBounced], 0

    ; Check the current keys every frame and move left or right.
    call UpdateKeys
    call BounceOnRight



    ; First, check if the left button is pressed.
CheckLeft:
    ld a, [wCurKeys]
    and a, PADF_LEFT
    jp z, CheckRight
Left:
    ; Move the paddle one pixel to the left.
    ld a, [_OAMRAM + 1]
    dec a
    ; If we've already hit the edge of the playfield, don't move.
    cp a, 15
    jp z, Main
    ld [_OAMRAM + 1], a
    jp Main

; Then check the right button.
CheckRight:
    ld a, [wCurKeys]
    and a, PADF_RIGHT
    jp z, Main
Right:
    ; Move the paddle one pixel to the right.
    ld a, [_OAMRAM + 1]
    inc a
    ; If we've already hit the edge of the playfield, don't move.
    cp a, 105
    jp z, Main
    ld [_OAMRAM + 1], a
    jp Main



UpdateKeys:
    ; Poll half the controller
    ld a, P1F_GET_BTN
    call .onenibble
    ld b, a ; B7-4 = 1; B3-0 = unpressed buttons
    
    ; Poll the other half
    ld a, P1F_GET_DPAD
    call .onenibble
    swap a ; A3-0 = unpressed directions; A7-4 = 1
    xor a, b ; A = pressed buttons + directions
    ld b, a ; B = pressed buttons + directions
    
    ; And release the controller
    ld a, P1F_GET_NONE
    ldh [rP1], a
    
    ; Combine with previous wCurKeys to make wNewKeys
    ld a, [wCurKeys]
    xor a, b ; A = keys that changed state
    and a, b ; A = keys that changed to pressed
    ld [wNewKeys], a
    ld a, b
    ld [wCurKeys], a
    ret
    
.onenibble
    ldh [rP1], a ; switch the key matrix
    call .knownret ; burn 10 cycles calling a known ret
    ldh a, [rP1] ; ignore value while waiting for the key matrix to settle
    ldh a, [rP1]
    ldh a, [rP1] ; this read counts
    or a, $F0 ; A7-4 = 1; A3-0 = unpressed keys
.knownret
    ret

; Convert a pixel position to a tilemap address
; hl = $9800 + X + Y * 32
; @param b: X
; @param c: Y
; @return hl: tile address
GetTileByPixel:
    ; First, we need to divide by 8 to convert a pixel position to a tile position.
    ; After this we want to multiply the Y position by 32.
    ; These operations effectively cancel out so we only need to mask the Y value.
    ld a, c
    and a, %11111000
    ld l, a
    ld h, 0
    ; Now we have the position * 8 in hl
    add hl, hl ; position * 16
    add hl, hl ; position * 32
    ; Convert the X position to an offset.
    ld a, b
    srl a ; a / 2
    srl a ; a / 4
    srl a ; a / 8
    ; Add the two offsets together.
    add a, l
    ld l, a
    adc a, h
    sub a, l
    ld h, a
    ; Add the offset to the tilemap's base address, and we are done!
    ld bc, $9800
    add hl, bc
    ret

; @param a: tile ID
; @return z: set if a is a wall.
IsWallTile:
    cp a, $00
    ret z
    cp a, $01
    ret z
    cp a, $02
    ret z
    cp a, $04
    ret z
    cp a, $05
    ret z
    cp a, $06
    ret z
    cp a, $07
    ret


; Start Wall Checks
; Remember to offset the OAM position!
; (8, 16) in OAM coordinates is (0, 0) on the screen.
BounceOnRight:
    ; Y Axis
    ld a, [_OAMRAM + 4]
    sub a, 16
    ld c, a

    ; X Axis
    ld a, [_OAMRAM + 5]
    sub a, 8 - 7
    ld b, a

    call GetTileByPixel ; Returns tile address in hl
    ld a, [hl]

    call IsWallTile
    jp nz, BounceOnLeft

    jp [wBounced], BounceOnLeft
    call CheckAndHandleBrick

    ; Change Ball Momentum if necessary
    ld a, -1
    ld [wBallMomentumX], a
    ld [wBounced], 1

BounceOnLeft:
    ; Y Axis
    ld a, [_OAMRAM + 4]
    sub a, 16
    ld c, a
    
    ; X Axis
    ld a, [_OAMRAM + 5]
    sub a, 8
    ld b, a

    call GetTileByPixel ; Returns tile address in hl
    ld a, [hl]

    call IsWallTile
    jp nz, BounceOnTop

    jp [wBounced], BounceOnTop
    call CheckAndHandleBrick

    ; Change Ball Momentum if necessary
    ld a, 1
    ld [wBallMomentumX], a
    ld [wBounced], 1

BounceOnTop:
    ; Y Axis
    ld a, [_OAMRAM + 4]
    sub a, 16 + 1
    ld c, a

    ; X Axis
    ld a, [_OAMRAM + 5]
    sub a, 8
    ld b, a

    call GetTileByPixel ; Returns tile address in hl
    ld a, [hl]

    call IsWallTile
    jp nz, BounceOnBottom

    jp [wBounced], BounceOnBottom
    call CheckAndHandleBrick

    ; Change Ball Momentum if necessary
    ld a, 1
    ld [wBallMomentumY], a
    ld [wBounced], 1

BounceOnBottom:
    ; Y Axis
    ld a, [_OAMRAM + 4]
    sub a, 16 - 6
    ld c, a
    
    ; X Axis
    ld a, [_OAMRAM + 5]
    sub a, 8
    ld b, a

    call GetTileByPixel ; Returns tile address in hl
    ld a, [hl]

    call IsWallTile
    jp nz, BounceDone

    jp [wBounced], BounceDone
    call CheckAndHandleBrick

    ; Change Ball Momentum if necessary
    ld a, -1
    ld [wBallMomentumY], a
    ld [wBounced], 1

BounceDone:

    ; First, check if the ball is low enough to bounce off the paddle.
    ld a, [_OAMRAM]
    sub a, 5
    ld b, a
    ld a, [_OAMRAM + 4]
    cp a, b
    jp nz, PaddleBounceDone ; If the ball isn't at the same Y position as the paddle, it can't bounce.
    ; Now let's compare the X positions of the objects to see if they're touching.
    ld a, [_OAMRAM + 5] ; Ball's X position.
    ld b, a
    ld a, [_OAMRAM + 1] ; Paddle's X position.
    sub a, 8
    cp a, b
    jp nc, PaddleBounceDone
    add a, 8 + 16 ; 8 to undo, 16 as the width.
    cp a, b
    jp c, PaddleBounceDone

    ld a, -1
    ld [wBallMomentumY], a
PaddleBounceDone:

; Checks if a brick was collided with and breaks it if possible.
; @param hl: address of tile.
CheckAndHandleBrick:
    ld a, [hl]
    cp a, BRICK_LEFT

    jr nz, CheckAndHandleBrickRight

    ; Break a brick from the left side.
    ld [hl], BLANK_TILE
    inc hl
    ld [hl], BLANK_TILE

CheckAndHandleBrickRight:
    cp a, BRICK_RIGHT

    ret nz

    ; Break a brick from the right side.
    ld [hl], BLANK_TILE
    dec hl
    ld [hl], BLANK_TILE
    ret



; Copy bytes from one area to another.
; @param de: Start Address
; @param hl: Memory Address
; @param bc: Length
Memcopy:
    ; Load a tile into VRAM (Video Memory) + increment
    ld a, [de]              ; Load "de" Address into Register "a"
    ld [hli], a             ; Load "a" value into location in memory & increment "hl"
    inc de                  ; Increment pointer
    dec bc                  ; Decrement counter

    ; Check to see if the loop is done
    ld a, b                 ; Load "b" into "a"
    or a, c                 ; Use "a" to do a OR check on "b" & "c". This will update flags.
    jp nz, Memcopy          ; If "bc" is 0, continue. (No more data needed to read)
    ret



    ; Giving the program a treat for doing so well
    ; AKA busywork so it doesn't get distracted and crash the program
    Done:
        jp Done



; Imports
INCLUDE "tileset.asm"
INCLUDE "tilemap.asm"
INCLUDE "paddle.asm"
INCLUDE "ball.asm"

; Work RAM
SECTION "Counter", WRAM0
wFrameCounter: db

SECTION "Input Variables", WRAM0
wCurKeys: db
wNewKeys: db

SECTION "Ball Data", WRAM0
wBallMomentumX: db
wBallMomentumY: db
wBounced: db