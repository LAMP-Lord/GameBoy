INCLUDE "hardware.inc"
INCLUDE "charmap.inc"
INCLUDE "macros/input_macros.inc"
INCLUDE "macros/extra_macros.inc"

SECTION "Intro - Graphics - GBC 1", ROMX

I_Graphics_GBC_Off::
    .TransData:: INCBIN "generated/gbc/backgrounds/intro/off1.2bpp" 
    .TransDataEnd::
    .TransTile:: INCBIN "generated/gbc/backgrounds/intro/off1.tilemap" 
    .TransTileEnd::
    .TransAttr:: INCBIN "generated/gbc/backgrounds/intro/off1.attrmap" 
    .TransAttrEnd::
    .StaticData:: INCBIN "generated/gbc/backgrounds/intro/off2.2bpp" 
    .StaticDataEnd::
    .StaticTile:: INCBIN "generated/gbc/backgrounds/intro/off2.tilemap" 
    .StaticTileEnd::
    .StaticAttr:: INCBIN "generated/gbc/backgrounds/intro/off2.attrmap" 
    .StaticAttrEnd::
    .TransPal:: INCBIN "generated/gbc/backgrounds/intro/off1.pal" 
    .TransPalEnd:: INCBIN "generated/gbc/backgrounds/intro/off1.pal" 
    .StaticPal:: INCBIN "generated/gbc/backgrounds/intro/off2.pal" 
    .StaticPalEnd:: INCBIN "generated/gbc/backgrounds/intro/off2.pal" 

; Confetti
I_Graphics_GBC_Stage1::
    .Scan1Data:: INCBIN "generated/gbc/backgrounds/intro/stage1_1.2bpp" 
    .Scan1DataEnd::
    .Scan2Data:: INCBIN "generated/gbc/backgrounds/intro/stage1_2.2bpp" 
    .Scan2DataEnd::
    .Scan1Tile:: INCBIN "generated/gbc/backgrounds/intro/stage1_1.tilemap" 
    .Scan1TileEnd::
    .Scan2Tile:: INCBIN "generated/gbc/backgrounds/intro/stage1_2.tilemap" 
    .Scan2TileEnd::
    .Scan1Attr:: INCBIN "generated/gbc/backgrounds/intro/stage1_1.attrmap" 
    .Scan1AttrEnd::
    .Scan2Attr:: INCBIN "generated/gbc/backgrounds/intro/stage1_2.attrmap" 
    .Scan2AttrEnd::
    .Scan1Pal:: INCBIN "generated/gbc/backgrounds/intro/stage1_1.pal" 
    .Scan1PalEnd::
    .Scan2Pal:: INCBIN "generated/gbc/backgrounds/intro/stage1_2.pal" 
    .Scan2PalEnd::

    .Text1:: db "Congratulations", 254, 254, "EMPLOYEE!", 255

; CDS Logo
I_Graphics_GBC_Stage2::
    .Scan1Data:: INCBIN "generated/gbc/backgrounds/intro/stage2_1.2bpp" 
    .Scan1DataEnd::
    .Scan2Data:: INCBIN "generated/gbc/backgrounds/intro/stage2_2.2bpp" 
    .Scan2DataEnd::
    .Scan1Tile:: INCBIN "generated/gbc/backgrounds/intro/stage2_1.tilemap" 
    .Scan1TileEnd::
    .Scan2Tile:: INCBIN "generated/gbc/backgrounds/intro/stage2_2.tilemap" 
    .Scan2TileEnd::
    .Scan1Attr:: INCBIN "generated/gbc/backgrounds/intro/stage2_1.attrmap" 
    .Scan1AttrEnd::
    .Scan2Attr:: INCBIN "generated/gbc/backgrounds/intro/stage2_2.attrmap" 
    .Scan2AttrEnd::

    .Text1:: db "Welcome to the", 254, 254, "CDS family. CDS", 254, 254, "commends you for-", 255
    .Text2:: db "being elevated as", 254, 254, "PRIMARY VESSEL ", 254, 254, "OVERSEER.        ", 255

SECTION "Intro - Graphics - GBC 2", ROMX

; Clipboard
I_Graphics_GBC_Stage3_None::
    .Scan1Data:: INCBIN "generated/gbc/backgrounds/intro/stage3_none_1.2bpp" 
    .Scan1DataEnd::
    .Scan2Data:: INCBIN "generated/gbc/backgrounds/intro/stage3_none_2.2bpp" 
    .Scan2DataEnd::
    .Scan1Tile:: INCBIN "generated/gbc/backgrounds/intro/stage3_none_1.tilemap" 
    .Scan1TileEnd::
    .Scan2Tile:: INCBIN "generated/gbc/backgrounds/intro/stage3_none_2.tilemap" 
    .Scan2TileEnd::
    .Scan1Attr:: INCBIN "generated/gbc/backgrounds/intro/stage3_none_1.attrmap" 
    .Scan1AttrEnd::
    .Scan2Attr:: INCBIN "generated/gbc/backgrounds/intro/stage3_none_2.attrmap" 
    .Scan2AttrEnd::

    .Text1:: db "As the sole human", 254, 254, "aboard, it is YOUR", 254, 254, "responsibility to", 255

; Ship
I_Graphics_GBC_Stage3_MAINTAIN::
    .Scan1Data:: INCBIN "generated/gbc/backgrounds/intro/stage3_maintain_1.2bpp" 
    .Scan1DataEnd::
    .Scan2Data:: INCBIN "generated/gbc/backgrounds/intro/stage3_maintain_2.2bpp" 
    .Scan2DataEnd::
    .Scan1Tile:: INCBIN "generated/gbc/backgrounds/intro/stage3_maintain_1.tilemap" 
    .Scan1TileEnd::
    .Scan2Tile:: INCBIN "generated/gbc/backgrounds/intro/stage3_maintain_2.tilemap" 
    .Scan2TileEnd::
    .Scan1Attr:: INCBIN "generated/gbc/backgrounds/intro/stage3_maintain_1.attrmap" 
    .Scan1AttrEnd::
    .Scan2Attr:: INCBIN "generated/gbc/backgrounds/intro/stage3_maintain_2.attrmap" 
    .Scan2AttrEnd::

    .Text1:: db "Maintain the ship.", 255

; Cargo
I_Graphics_GBC_Stage3_DELIVER::
    .Scan1Data:: INCBIN "generated/gbc/backgrounds/intro/stage3_deliver_1.2bpp" 
    .Scan1DataEnd::
    .Scan2Data:: INCBIN "generated/gbc/backgrounds/intro/stage3_deliver_2.2bpp" 
    .Scan2DataEnd::
    .Scan1Tile:: INCBIN "generated/gbc/backgrounds/intro/stage3_deliver_1.tilemap" 
    .Scan1TileEnd::
    .Scan2Tile:: INCBIN "generated/gbc/backgrounds/intro/stage3_deliver_2.tilemap" 
    .Scan2TileEnd::
    .Scan1Attr:: INCBIN "generated/gbc/backgrounds/intro/stage3_deliver_1.attrmap" 
    .Scan1AttrEnd::
    .Scan2Attr:: INCBIN "generated/gbc/backgrounds/intro/stage3_deliver_2.attrmap" 
    .Scan2AttrEnd::

    .Text1:: db "Deliver cargo.", 255

SECTION "Intro - Graphics - GBC 3", ROMX

; CDS Flag
I_Graphics_GBC_Stage3_UPHOLD::
    .Scan1Data:: INCBIN "generated/gbc/backgrounds/intro/stage3_uphold_1.2bpp" 
    .Scan1DataEnd::
    .Scan2Data:: INCBIN "generated/gbc/backgrounds/intro/stage3_uphold_2.2bpp" 
    .Scan2DataEnd::
    .Scan1Tile:: INCBIN "generated/gbc/backgrounds/intro/stage3_uphold_1.tilemap" 
    .Scan1TileEnd::
    .Scan2Tile:: INCBIN "generated/gbc/backgrounds/intro/stage3_uphold_2.tilemap" 
    .Scan2TileEnd::
    .Scan1Attr:: INCBIN "generated/gbc/backgrounds/intro/stage3_uphold_1.attrmap" 
    .Scan1AttrEnd::
    .Scan2Attr:: INCBIN "generated/gbc/backgrounds/intro/stage3_uphold_2.attrmap" 
    .Scan2AttrEnd::

    .Text1:: db "And uphold the", 254, 254, "brand.", 255

; Thumbs up
I_Graphics_GBC_Stage4::
    .Scan1Data:: INCBIN "generated/gbc/backgrounds/intro/stage4_1.2bpp" 
    .Scan1DataEnd::
    .Scan2Data:: INCBIN "generated/gbc/backgrounds/intro/stage4_2.2bpp" 
    .Scan2DataEnd::
    .Scan1Tile:: INCBIN "generated/gbc/backgrounds/intro/stage4_1.tilemap" 
    .Scan1TileEnd::
    .Scan2Tile:: INCBIN "generated/gbc/backgrounds/intro/stage4_2.tilemap" 
    .Scan2TileEnd::
    .Scan1Attr:: INCBIN "generated/gbc/backgrounds/intro/stage4_1.attrmap" 
    .Scan1AttrEnd::
    .Scan2Attr:: INCBIN "generated/gbc/backgrounds/intro/stage4_2.attrmap" 
    .Scan2AttrEnd::

    .Text1:: db "Good luck Captain", 254, 254, "EMPLOYEE!", 255

I_Graphics_GBC_Console::
    .Data1:: INCBIN "generated/gbc/images8/intro/font_scanned_1.2bpp"
    .Data1End::
    .Data2:: INCBIN "generated/gbc/images8/intro/font_scanned_2.2bpp"
    .Data2End::

    .FontPal:: INCBIN "generated/gbc/images8/intro/font_scanned_1.pal"
    .FontPalEnd::

    .Text:: db "Employee ID", 254, 253, 255
    .PrintWidget:: db 253, 255
    .QotD:: db "Quote of the Day", 254, 254, 253, 255
        
    .Widgets::
        db $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $0, 255
        db "VacationReq 404    ", 255
        db "Ship Temp - 023 C  ", 255
        db "Void Breaches - 0  ", 255
        db "-System Error-     ", 255
        db "C0nSol3 d@MAg3d    ", 255
        db "e$`3&6^zKL@jPo     ", 255
        db "Password - 1234    ", 255
        db "Jelly RPM - 978123 ", 255
        db "FunFact #6! Bees?  ", 255
        db "FunFact #7! Bees!  ", 255
        db "ERR SYSTEM/GLOOPED ", 255
        db "Forecast - Nebulae ", 255
        db "icymiidkwidrnfrfr  ", 255
        db "Please remove hand ", 255
        db "Loading...         ", 255

    .Quotes::
        db "\"Don't be a", 254, "xenophobe!", 254, "Eugenics is", 254, "not tolerated\" ", 255
        db "\"Corporate hymn", 254, "at 0900.", 254, "Attendance is", 254, "mandatory.\"", 255
        db "\"Hungry? Try our", 254, "new Spacebar!\"                   ", 255
        db "\"Air isn't free!", 254, "Savour every", 254, "breath.\"            ", 255
        db "\"You can't spell", 254, "SUCCESS without", 254, "CDS!\"            ", 255
        db "\"Remember, Oxygen", 254, "is a privilage.\"                ", 255
        db "\"CDS sees your", 254, "profit margins.\"                   ", 255
        db "\"Don't forget the", 254, "hourly performance", 254, "reviews!\"    ", 255
        db "\"Smile! Moral", 254, "sensors are", 254, "active.\"                ", 255
        db "\"Think inside the", 254, "cargo box.\"                     ", 255
        db "\"36% of pilots", 254, "are fully", 254, "autonomous!\"             ", 255
        db "\"Efficiency is its", 254, "own reward.\"                   ", 255
        db "\"Don't\"                                           ", 255
        db "\"Risk boosts our", 254, "shareholder", 254, "value.\"              ", 255
        db "\"Sleeping is not", 254, "in our policy.\"                  ", 255
        db "\"Integrity audit", 254, "in progress.", 254, "Stay compliant.\"    ", 255



SECTION "Intro - GBC Graphics Loaders", ROMX, BANK[$2]
    
; Stage 1
I_Load_GBC_Stage1::
    ld a, LCDCF_OFF | LCDCF_BGON | LCDCF_BLK01 | LCDCF_BG9800 | LCDCF_OBJON
    ldh [rLCDC], a

    ld a, BANK(I_Graphics_GBC_Off)
    ld [BankNumber], a

    PUT_ADDRESS Memory_Copy, FunctionPointer
    ld de, I_Graphics_GBC_Stage1.Scan1Tile
    ld hl, _SCRN0
    ld bc, I_Graphics_GBC_Stage1.Scan1TileEnd - I_Graphics_GBC_Stage1.Scan1Tile
    call App_CallFromBank

    ld a, 1
    ldh [rVBK], a
    ld de, I_Graphics_GBC_Stage1.Scan1Attr
    ld hl, _SCRN0
    ld bc, I_Graphics_GBC_Stage1.Scan1AttrEnd - I_Graphics_GBC_Stage1.Scan1Attr
    call App_CallFromBank

    ld de, I_Graphics_GBC_Stage1.Scan2Attr
    ld hl, _SCRN1
    ld bc, I_Graphics_GBC_Stage1.Scan2AttrEnd - I_Graphics_GBC_Stage1.Scan2Attr
    call App_CallFromBank
    ld a, 0
    ldh [rVBK], a

    PUT_ADDRESS Memory_CopyWithOffset, FunctionPointer
    ld a, $40
    ld [MemOffset], a
    ld de, I_Graphics_GBC_Stage1.Scan2Tile
    ld hl, _SCRN1
    ld bc, I_Graphics_GBC_Stage1.Scan2TileEnd - I_Graphics_GBC_Stage1.Scan2Tile
    call App_CallFromBank

    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_BLK01 | LCDCF_BG9800 | LCDCF_OBJON
    ldh [rLCDC], a

    SET_ACTION Actions.Up, ON_9800
    ret

; Stage 2
I_Load_GBC_Stage2::
    ld a, BANK(I_Graphics_GBC_Off)
    ld [BankNumber], a

    PUT_ADDRESS Memory_SafeCopyVBK, FunctionPointer
    xor a
    ld [MemOffset], a
    ld de, I_Graphics_GBC_Stage2.Scan1Data
    ld hl, $8800
    ld bc, I_Graphics_GBC_Stage2.Scan1DataEnd - I_Graphics_GBC_Stage2.Scan1Data
    call App_CallFromBank

    ld de, I_Graphics_GBC_Stage2.Scan2Data
    ld hl, $8C00
    ld bc, I_Graphics_GBC_Stage2.Scan2DataEnd - I_Graphics_GBC_Stage2.Scan2Data
    call App_CallFromBank

    ld de, I_Graphics_GBC_Stage2.Scan1Tile
    ld hl, _SCRN0
    ld bc, I_Graphics_GBC_Stage2.Scan1TileEnd - I_Graphics_GBC_Stage2.Scan1Tile
    call App_CallFromBank

    ld a, $40
    ld [MemOffset], a
    ld de, I_Graphics_GBC_Stage2.Scan2Tile
    ld hl, _SCRN1
    ld bc, I_Graphics_GBC_Stage2.Scan2TileEnd - I_Graphics_GBC_Stage2.Scan2Tile
    call App_CallFromBank
    ret

; Stage 3
I_Load_GBC_Stage3_None::
    ld a, BANK(I_Graphics_GBC_Stage3_None)
    ld [BankNumber], a

    PUT_ADDRESS Memory_SafeCopyVBK, FunctionPointer
    xor a
    ld [MemOffset], a
    ld de, I_Graphics_GBC_Stage3_None.Scan1Data
    ld hl, $8800
    ld bc, I_Graphics_GBC_Stage3_None.Scan1DataEnd - I_Graphics_GBC_Stage3_None.Scan1Data
    call App_CallFromBank

    ld de, I_Graphics_GBC_Stage3_None.Scan2Data
    ld hl, $8C00
    ld bc, I_Graphics_GBC_Stage3_None.Scan2DataEnd - I_Graphics_GBC_Stage3_None.Scan2Data
    call App_CallFromBank

    ld de, I_Graphics_GBC_Stage3_None.Scan1Tile
    ld hl, _SCRN0
    ld bc, I_Graphics_GBC_Stage3_None.Scan1TileEnd - I_Graphics_GBC_Stage3_None.Scan1Tile
    call App_CallFromBank

    ld a, $40
    ld [MemOffset], a
    ld de, I_Graphics_GBC_Stage3_None.Scan2Tile
    ld hl, _SCRN1
    ld bc, I_Graphics_GBC_Stage3_None.Scan2TileEnd - I_Graphics_GBC_Stage3_None.Scan2Tile
    call App_CallFromBank
    ret

I_Load_GBC_Stage3_MAINTAIN::
    ld a, BANK(I_Graphics_GBC_Stage3_MAINTAIN)
    ld [BankNumber], a

    PUT_ADDRESS Memory_SafeCopyVBK, FunctionPointer
    xor a
    ld [MemOffset], a
    ld de, I_Graphics_GBC_Stage3_MAINTAIN.Scan1Data
    ld hl, $8800
    ld bc, I_Graphics_GBC_Stage3_MAINTAIN.Scan1DataEnd - I_Graphics_GBC_Stage3_MAINTAIN.Scan1Data
    call App_CallFromBank

    ld de, I_Graphics_GBC_Stage3_MAINTAIN.Scan2Data
    ld hl, $8C00
    ld bc, I_Graphics_GBC_Stage3_MAINTAIN.Scan2DataEnd - I_Graphics_GBC_Stage3_MAINTAIN.Scan2Data
    call App_CallFromBank

    ld de, I_Graphics_GBC_Stage3_MAINTAIN.Scan1Tile
    ld hl, _SCRN0
    ld bc, I_Graphics_GBC_Stage3_MAINTAIN.Scan1TileEnd - I_Graphics_GBC_Stage3_MAINTAIN.Scan1Tile
    call App_CallFromBank

    ld a, $40
    ld [MemOffset], a
    ld de, I_Graphics_GBC_Stage3_MAINTAIN.Scan2Tile
    ld hl, _SCRN1
    ld bc, I_Graphics_GBC_Stage3_MAINTAIN.Scan2TileEnd - I_Graphics_GBC_Stage3_MAINTAIN.Scan2Tile
    call App_CallFromBank
    ret

I_Load_GBC_Stage3_DELIVER::
    ld a, BANK(I_Graphics_GBC_Stage3_DELIVER)
    ld [BankNumber], a

    PUT_ADDRESS Memory_SafeCopyVBK, FunctionPointer
    xor a
    ld [MemOffset], a
    ld de, I_Graphics_GBC_Stage3_DELIVER.Scan1Data
    ld hl, $8800
    ld bc, I_Graphics_GBC_Stage3_DELIVER.Scan1DataEnd - I_Graphics_GBC_Stage3_DELIVER.Scan1Data
    call App_CallFromBank

    ld de, I_Graphics_GBC_Stage3_DELIVER.Scan2Data
    ld hl, $8C00
    ld bc, I_Graphics_GBC_Stage3_DELIVER.Scan2DataEnd - I_Graphics_GBC_Stage3_DELIVER.Scan2Data
    call App_CallFromBank

    ld de, I_Graphics_GBC_Stage3_DELIVER.Scan1Tile
    ld hl, _SCRN0
    ld bc, I_Graphics_GBC_Stage3_DELIVER.Scan1TileEnd - I_Graphics_GBC_Stage3_DELIVER.Scan1Tile
    call App_CallFromBank

    ld a, $40
    ld [MemOffset], a
    ld de, I_Graphics_GBC_Stage3_DELIVER.Scan2Tile
    ld hl, _SCRN1
    ld bc, I_Graphics_GBC_Stage3_DELIVER.Scan2TileEnd - I_Graphics_GBC_Stage3_DELIVER.Scan2Tile
    call App_CallFromBank
    ret

I_Load_GBC_Stage3_UPHOLD::
    ld a, BANK(I_Graphics_GBC_Stage3_UPHOLD)
    ld [BankNumber], a

    PUT_ADDRESS Memory_SafeCopyVBK, FunctionPointer
    xor a
    ld [MemOffset], a
    ld de, I_Graphics_GBC_Stage3_UPHOLD.Scan1Data
    ld hl, $8800
    ld bc, I_Graphics_GBC_Stage3_UPHOLD.Scan1DataEnd - I_Graphics_GBC_Stage3_UPHOLD.Scan1Data
    call App_CallFromBank

    ld de, I_Graphics_GBC_Stage3_UPHOLD.Scan2Data
    ld hl, $8C00
    ld bc, I_Graphics_GBC_Stage3_UPHOLD.Scan2DataEnd - I_Graphics_GBC_Stage3_UPHOLD.Scan2Data
    call App_CallFromBank

    ld de, I_Graphics_GBC_Stage3_UPHOLD.Scan1Tile
    ld hl, _SCRN0
    ld bc, I_Graphics_GBC_Stage3_UPHOLD.Scan1TileEnd - I_Graphics_GBC_Stage3_UPHOLD.Scan1Tile
    call App_CallFromBank

    ld a, $40
    ld [MemOffset], a
    ld de, I_Graphics_GBC_Stage3_UPHOLD.Scan2Tile
    ld hl, _SCRN1
    ld bc, I_Graphics_GBC_Stage3_UPHOLD.Scan2TileEnd - I_Graphics_GBC_Stage3_UPHOLD.Scan2Tile
    call App_CallFromBank
    ret

; Stage 4
I_Load_GBC_Stage4::
    ld a, BANK(I_Graphics_GBC_Stage4)
    ld [BankNumber], a

    PUT_ADDRESS Memory_SafeCopyVBK, FunctionPointer
    xor a
    ld [MemOffset], a
    ld de, I_Graphics_GBC_Stage4.Scan1Data
    ld hl, $8800
    ld bc, I_Graphics_GBC_Stage4.Scan1DataEnd - I_Graphics_GBC_Stage4.Scan1Data
    call App_CallFromBank

    ld de, I_Graphics_GBC_Stage4.Scan2Data
    ld hl, $8C00
    ld bc, I_Graphics_GBC_Stage4.Scan2DataEnd - I_Graphics_GBC_Stage4.Scan2Data
    call App_CallFromBank

    ld de, I_Graphics_GBC_Stage4.Scan1Tile
    ld hl, _SCRN0
    ld bc, I_Graphics_GBC_Stage4.Scan1TileEnd - I_Graphics_GBC_Stage4.Scan1Tile
    call App_CallFromBank

    ld a, $40
    ld [MemOffset], a
    ld de, I_Graphics_GBC_Stage4.Scan2Tile
    ld hl, _SCRN1
    ld bc, I_Graphics_GBC_Stage4.Scan2TileEnd - I_Graphics_GBC_Stage4.Scan2Tile
    call App_CallFromBank
    ret

; Continue Menu Thingy
I_Load_GBC_Continue::
    ld a, BANK(I_Graphics_GBC_Console)
    ld [BankNumber], a

    PUT_ADDRESS UI_GBC_BGP, FunctionPointer
    ld hl, I_Graphics_GBC_Console.FontPal
    ld bc, I_Graphics_GBC_Console.FontPalEnd - I_Graphics_GBC_Console.FontPal
    call App_CallFromBank

    PUT_ADDRESS Memory_SafeCopyVBK, FunctionPointer
    xor a
    ld [MemOffset], a
    ld de, I_Graphics_GBC_Console.Data2
    ld hl, $8C00
    ld bc, I_Graphics_GBC_Console.Data2End - I_Graphics_GBC_Console.Data2
    call App_CallFromBank
    
    ld de, I_Graphics_GBC_Console.Data1
    ld hl, $9200
    ld bc, I_Graphics_GBC_Console.Data1End - I_Graphics_GBC_Console.Data1
    call App_CallFromBank

    call I_GBC_ClearScreen
    ret

I_GBC_ClearScreen::
    ld a, BANK(I_Graphics_GBC_Console)
    ld [BankNumber], a

    PUT_ADDRESS Memory_SafeFill, FunctionPointer
    ld d, $C3
    ld hl, $9860
    ld bc, $9954 - $9860
    call App_CallFromBank

    ld d, $23
    ld hl, $9C60
    ld bc, $9D54 - $9C60
    call App_CallFromBank
    ret