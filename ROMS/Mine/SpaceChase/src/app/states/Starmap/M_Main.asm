INCLUDE "hardware.inc"
INCLUDE "charmap.inc"
INCLUDE "macros/input_macros.inc"
INCLUDE "macros/sprite_macros.inc"
INCLUDE "macros/extra_macros.inc"

SECTION "Starmap - Graphics", ROMX, BANK[$3]

DMG_Graphics:
    .Loc_Data INCBIN "generated/dmg/images16/starmap/locations.2bpp"
    .Loc_DataEnd

    .Star_Data INCBIN "generated/dmg/images8/starmap/star_patterns.2bpp"
    .Star_DataEnd

    .Select INCBIN "generated/dmg/images8/starmap/selected.2bpp"
    .SelectEnd

GBC_Graphics:
    .Loc_Data INCBIN "generated/gbc/images16/starmap/locations.2bpp"
    .Loc_DataEnd

    .Loc_Palette INCBIN "generated/gbc/images16/starmap/locations.pal"
    .Loc_PaletteEnd

    .Star_Data INCBIN "generated/gbc/images8/starmap/star_patterns.2bpp"
    .Star_DataEnd

    .Select INCBIN "generated/gbc/images8/starmap/selected.2bpp"
    .SelectEnd

SECTION "Starmap - Entry Point", ROMX, BANK[$3]

Starmap_EntryPoint::
    ; ld a, 40
    ; ld [rSCX], a

    ; ld hl, OAM_DMA
    ; CREATE_OBJECT 0, 160, 78, 0
    ; CREATE_OBJECT 2, 168, 78, 0

    ; Graphics Loading
    ldh a, [ConsoleFlag]
    cp BOOTUP_A_CGB
    jp nz, .dmg

    ; UI
    ld de, UI_GBC.Font
    ld hl, $9000
    ld bc, UI_GBC.FontEnd - UI_GBC.Font 
    call Memory_Copy
    
    ld de, GBC_Graphics.Loc_Data
    ld hl, $8000
    ld bc, GBC_Graphics.Loc_DataEnd - GBC_Graphics.Loc_Data
    call Memory_Copy

    ld de, GBC_Graphics.Star_Data
    ld hl, $8810
    ld bc, GBC_Graphics.Star_DataEnd - GBC_Graphics.Star_Data
    call Memory_Copy

    ld de, GBC_Graphics.Select
    ld bc, GBC_Graphics.SelectEnd - GBC_Graphics.Select
    call Memory_Copy

    ; GBC Palettes
    ld de, GBC_Graphics.Loc_Palette
    ld hl, FadeIn_Target + 64
    ld bc, GBC_Graphics.Loc_PaletteEnd - GBC_Graphics.Loc_Palette
    call Memory_Copy
    jr .end

.dmg
    ld de, UI_DMG.Font
    ld hl, $9000
    ld bc, UI_DMG.FontEnd - UI_DMG.Font 
    call Memory_Copy
    
    ld de, DMG_Graphics.Loc_Data
    ld hl, $8000
    ld bc, DMG_Graphics.Loc_DataEnd - DMG_Graphics.Loc_Data
    call Memory_Copy

    ld de, DMG_Graphics.Star_Data
    ld hl, $8810
    ld bc, DMG_Graphics.Star_DataEnd - DMG_Graphics.Star_Data
    call Memory_Copy

    ld de, DMG_Graphics.Select
    ld bc, DMG_Graphics.SelectEnd - DMG_Graphics.Select
    call Memory_Copy
.end

    call M_GenerateMap

    ; ld d, 0
    ; ld hl, MapBuffer
    ; ld bc, MapBufferEnd - MapBuffer
    ; call Memory_Fill

    ; ld a, $08
    ; ld [$C312], a
    ; swap a
    ; ld [$C322], a

    ; ld a, %0000_1101 ; Warehouse - Normal Cargo
    ; ld [$C313], a
    ; ld a, %0000_1111 ; Planet - Skin 1
    ; ld [$C323], a

    call M_Display

    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_BLK21 | LCDCF_BG9800 | LCDCF_OBJON | LCDCF_OBJ16
    ldh [rLCDC], a

    call UI_FadeIn

    ld a, %11_10_01_00
    ld [rBGP], a

    ld a, %00_01_10_11
    ld [rOBP0], a

    ld a, %00_01_10_11
    ld [rOBP1], a

    ; call UI_FadeOut
    
    ; ld a, "T"
    ; ld [CurrentState], a
    ; jp ChangeState

.loop
    call App_EndOfFrame

    ; ld hl, OAM_DMA + 1
    ; ld a, [hl]
    ; sub 2
    ; ld [hl], a
    ; ld hl, OAM_DMA + 5
    ; ld a, [hl]
    ; sub 2
    ; ld [hl], a

    ; ld a, [rSCX]
    ; sub 1
    ; ld [rSCX], a

    jr .loop