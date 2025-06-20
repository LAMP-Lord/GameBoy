include "include/hardware.inc"

; UNUSED

DEF MAX_ENEMY_COUNT EQU 10
DEF MAX_BULLET_COUNT EQU 5

DEF ENEMY_SPAWN_DELAY_MAX EQU 70

; from https://rgbds.gbdev.io/docs/v0.6.1/rgbasm.5#EXPRESSIONS
; The RS group of commands is a handy way of defining structure offsets:
RSRESET
DEF metasprite_y                RB   1
DEF metasprite_x                RB   1
DEF metasprite_tile             RB   1
DEF metasprite_flag             RB   1
DEF METASPRITE_BYTES_COUNT      RB   0

; from https://rgbds.gbdev.io/docs/v0.6.1/rgbasm.5#EXPRESSIONS
; The RS group of commands is a handy way of defining structure offsets:
RSRESET
DEF enemy_activeByte            RB   1
DEF enemy_xByte                 RB   1
DEF enemy_yLowByte              RB   1
DEF enemy_yHighByte             RB   1
DEF enemy_speedByte             RB   1
DEF enemy_healthByte            RB   1
DEF PER_ENEMY_BYTES_COUNT       RB   0

; ANCHOR: bullet-offset-constants
; from https://rgbds.gbdev.io/docs/v0.6.1/rgbasm.5#EXPRESSIONS
; The RS group of commands is a handy way of defining structure offsets:
RSRESET
DEF bullet_activeByte            RB   1
DEF bullet_xByte                 RB   1
DEF bullet_yLowByte              RB   1
DEF bullet_yHighByte             RB   1
DEF PER_BULLET_BYTES_COUNT       RB   0
; ANCHOR_END: bullet-offset-constants

; ANCHOR: sprite-vram-constants
RSRESET
DEF spriteTilesStart            RB _VRAM
DEF PLAYER_TILES_START          RB 4*16
DEF ENEMY_TILES_START           RB 4*16
DEF BULLET_TILES_START          RB 0
; ANCHOR_END: sprite-vram-constants


DEF ENEMY_MOVE_SPEED EQU 11
DEF BULLET_MOVE_SPEED EQU 20

DEF PLAYER_MOVE_SPEED EQU 15
DEF PADDLE_Y_POSITION EQU 136


DEF DISPLAYBOX_TOPLEFT     EQU $50
DEF DISPLAYBOX_TOP         EQU $51
DEF DISPLAYBOX_TOPRIGHT    EQU $52
DEF DISPLAYBOX_WALL        EQU $53
DEF DISPLAYBOX_BOTTOMLEFT  EQU $54
DEF DISPLAYBOX_BOTTOM      EQU $55
DEF DISPLAYBOX_BOTTOMRIGHT EQU $56