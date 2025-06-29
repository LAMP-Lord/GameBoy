INCLUDE "hardware.inc"
INCLUDE "charmap.inc"
INCLUDE "macros/input_macros.inc"
INCLUDE "macros/sprite_macros.inc"
INCLUDE "macros/extra_macros.inc"

SECTION "Intro       - Graphics Off-2", ROMX

Off:
    .TransData INCBIN "generated/backgrounds/intro_off1.2bpp" 
    .TransDataEnd
    .TransTile INCBIN "generated/backgrounds/intro_off1.tilemap" 
    .TransTileEnd
    .StaticData INCBIN "generated/backgrounds/intro_off2.2bpp" 
    .StaticDataEnd
    .StaticTile INCBIN "generated/backgrounds/intro_off2.tilemap" 
    .StaticTileEnd

; Confetti
Stage1:
    .Scan1Data INCBIN "generated/backgrounds/intro_stage1_1.2bpp" 
    .Scan1DataEnd
    .Scan2Data INCBIN "generated/backgrounds/intro_stage1_2.2bpp" 
    .Scan2DataEnd
    .Scan1Tile INCBIN "generated/backgrounds/intro_stage1_1.tilemap" 
    .Scan1TileEnd
    .Scan2Tile INCBIN "generated/backgrounds/intro_stage1_2.tilemap" 
    .Scan2TileEnd

    .Text1 db "Congratulations", 254, 254, "EMPLOYEE!", 255

; CDS Logo
Stage2:
    .Scan1Data INCBIN "generated/backgrounds/intro_stage2_1.2bpp" 
    .Scan1DataEnd
    .Scan2Data INCBIN "generated/backgrounds/intro_stage2_2.2bpp" 
    .Scan2DataEnd
    .Scan1Tile INCBIN "generated/backgrounds/intro_stage2_1.tilemap" 
    .Scan1TileEnd
    .Scan2Tile INCBIN "generated/backgrounds/intro_stage2_2.tilemap" 
    .Scan2TileEnd

    .Text1 db "Welcome to the", 254, 254, "CDS family. CDS", 254, 254, "commends you for-", 255
    .Text2 db "being elevated as", 254, 254, "PRIMARY VESSEL ", 254, 254, "OVERSEER.        ", 255

SECTION "Intro       - Graphics 3", ROMX

; Clipboard
Stage3_None:
    .Scan1Data INCBIN "generated/backgrounds/intro_stage3_none_1.2bpp" 
    .Scan1DataEnd
    .Scan2Data INCBIN "generated/backgrounds/intro_stage3_none_2.2bpp" 
    .Scan2DataEnd
    .Scan1Tile INCBIN "generated/backgrounds/intro_stage3_none_1.tilemap" 
    .Scan1TileEnd
    .Scan2Tile INCBIN "generated/backgrounds/intro_stage3_none_2.tilemap" 
    .Scan2TileEnd

    .Text1 db "As the sole human", 254, 254, "aboard, it is YOUR", 254, 254, "responsibility to", 255

; Ship
Stage3_MAINTAIN:
    .Scan1Data INCBIN "generated/backgrounds/intro_stage3_maintain_1.2bpp" 
    .Scan1DataEnd
    .Scan2Data INCBIN "generated/backgrounds/intro_stage3_maintain_2.2bpp" 
    .Scan2DataEnd
    .Scan1Tile INCBIN "generated/backgrounds/intro_stage3_maintain_1.tilemap" 
    .Scan1TileEnd
    .Scan2Tile INCBIN "generated/backgrounds/intro_stage3_maintain_2.tilemap" 
    .Scan2TileEnd

    .Text1 db "Maintain the ship.", 255

; Cargo
Stage3_DELIVER:
    .Scan1Data INCBIN "generated/backgrounds/intro_stage3_deliver_1.2bpp" 
    .Scan1DataEnd
    .Scan2Data INCBIN "generated/backgrounds/intro_stage3_deliver_2.2bpp" 
    .Scan2DataEnd
    .Scan1Tile INCBIN "generated/backgrounds/intro_stage3_deliver_1.tilemap" 
    .Scan1TileEnd
    .Scan2Tile INCBIN "generated/backgrounds/intro_stage3_deliver_2.tilemap" 
    .Scan2TileEnd

    .Text1 db "Deliver cargo.", 255

; CDS Flag
Stage3_UPHOLD:
    .Scan1Data INCBIN "generated/backgrounds/intro_stage3_uphold_1.2bpp" 
    .Scan1DataEnd
    .Scan2Data INCBIN "generated/backgrounds/intro_stage3_uphold_2.2bpp" 
    .Scan2DataEnd
    .Scan1Tile INCBIN "generated/backgrounds/intro_stage3_uphold_1.tilemap" 
    .Scan1TileEnd
    .Scan2Tile INCBIN "generated/backgrounds/intro_stage3_uphold_2.tilemap" 
    .Scan2TileEnd

    .Text1 db "And uphold the", 254, 254, "brand.", 255

SECTION "Intro       - Graphics 4 + Text", ROMX

; Thumbs up
Stage4:
    .Scan1Data INCBIN "generated/backgrounds/intro_stage4_1.2bpp" 
    .Scan1DataEnd
    .Scan2Data INCBIN "generated/backgrounds/intro_stage4_2.2bpp" 
    .Scan2DataEnd
    .Scan1Tile INCBIN "generated/backgrounds/intro_stage4_1.tilemap" 
    .Scan1TileEnd
    .Scan2Tile INCBIN "generated/backgrounds/intro_stage4_2.tilemap" 
    .Scan2TileEnd

    .Text1 db "Good luck Captain", 254, 254, "EMPLOYEE!", 255

Console:
    .Data1 INCBIN "generated/ui/font_scanned_1.2bpp"
    .Data1End
    .Data2 INCBIN "generated/ui/font_scanned_2.2bpp"
    .Data2End

    .Text db "Employee ID", 254, 253, 255
    .PrintWidget db 253, 255
    .QotD db "Quote of the Day", 254, 254, 253, 255
        
    .Widgets
        db "Route - Beta.Tau   ", 255
        db "Ship Temp - 023 C  ", 255
        db "Void Breaches - 0  ", 255
        db $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, 255
        db "-System Error-     ", 255
        db "Console Damaged    ", 255
        db "e$`3&6^zKL@jPo     ", 255
        db "Password - 1234    ", 255
        db "Jelly RPM - 978123 ", 255
        db "FunFact #6! Bees?  ", 255
        db "FunFact #7! Bees!  ", 255
        db "ERR SYSTEM/GLOOPED ", 255
        db "Forecast - Nebulae ", 255
        db "icymiidkwidrnfrfr  ", 255
        db "Please remove jelly", 255
        db "Loading...         ", 255

    .Quotes
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
        db "\"Vacation Request", 254, "404\"                            ", 255
        db "\"Don't\"                                           ", 255
        db "\"Risk boosts our", 254, "shareholder", 254, "value.\"              ", 255
        db "\"Sleeping is not", 254, "in our policy.\"                  ", 255
        db "\"Integrity audit", 254, "in progress.", 254, "Stay compliant.\"    ", 255



SECTION "Intro       - Functions", ROMX, BANK[$2]

Intro_EntryPoint::
    ; Move down because i am a dumbass :p
    ld a, $8
    ldh [rSCY], a

    ; Off Screen Data
    ld a, BANK(Off)
    ld [BankNumber], a

    PUT_ADDRESS Memory_Copy, FunctionPointer
    ld de, Off.StaticData
    ld hl, _VRAM8000
    ld bc, Off.StaticDataEnd - Off.StaticData
    call App_CallFromBank

    ld de, Off.TransData
    ld hl, $8400
    ld bc, Off.TransDataEnd - Off.TransData
    call App_CallFromBank

    ; Check Save Flag
    ld a, [ValidSave]
    cp 0
    jp z, .newgame

    ; Continue Selected
    ld a, BANK(Off)
    ld [BankNumber], a
    PUT_ADDRESS Memory_Copy, FunctionPointer

    ld de, Stage2.Scan1Data
    ld hl, _VRAM8800
    ld bc, Stage2.Scan1DataEnd - Stage2.Scan1Data
    call App_CallFromBank

    ld de, Stage2.Scan2Data
    ld hl, $8C00
    ld bc, Stage2.Scan2DataEnd - Stage2.Scan2Data
    call App_CallFromBank

    call LoadStage1

    ; Done Loading / Fade In
    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_BG8000 | LCDCF_BG9800 | LCDCF_OBJON
    ldh [rLCDC], a
    call UI_FadeIn

    ; Start Sequence
    call LoadStage2

    call .waitforA

    call Memory_LoadSave

    call LoadContinue
    PUT_ADDRESS Save.PlayerName, DynamicLabel
    PRINT_MULTILINE Console.Text, $9881, $C4

    ld hl, Console.Widgets
    ld b, 20
    call .genWidget
    PRINT_MULTILINE Console.PrintWidget, $98E1, $C4
    ld hl, Console.Widgets
    ld b, 20
    call .genWidget
    PRINT_MULTILINE Console.PrintWidget, $9901, $C4
    ld hl, Console.Widgets
    ld b, 20
    call .genWidget
    PRINT_MULTILINE Console.PrintWidget, $9921, $C4

    call .waitforA
    call ClearScreen

    ld hl, Console.Quotes
    ld b, 51
    call .genWidget
    PRINT_MULTILINE Console.QotD, $9881, $C4

    call .waitforA

    ; Turn Off and Leave
    call OFF
    WAIT_FRAMES 40
    call UI_FadeOut

    ld a, "M"
    ld [CurrentState], a
    jp ChangeState

.newgame
    ; New Game Selected
    ld a, BANK(Off)
    ld [BankNumber], a
    PUT_ADDRESS Memory_Copy, FunctionPointer
    
    ld de, Stage1.Scan1Data
    ld hl, _VRAM8800
    ld bc, Stage1.Scan1DataEnd - Stage1.Scan1Data
    call App_CallFromBank

    ld de, Stage1.Scan2Data
    ld hl, $8C00
    ld bc, Stage1.Scan2DataEnd - Stage1.Scan2Data
    call App_CallFromBank

    ; Done Loading / Fade In
    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_BG8000 | LCDCF_BG9800 | LCDCF_OBJON
    ldh [rLCDC], a
    call UI_FadeIn

    ; Start Sequence
    call LoadStage1
    PRINT_MULTILINE Stage1.Text1, $99A1

    call .waitforA

    call LoadStage2
    PRINT_MULTILINE Stage2.Text1, $99A1
    call .waitforA
    PRINT_MULTILINE Stage2.Text2, $99A1

    call .waitforA

    call LoadStage3_None
    PRINT_MULTILINE Stage3_None.Text1, $99A1
    call .waitforA
    call LoadStage3_MAINTAIN
    PRINT_MULTILINE Stage3_MAINTAIN.Text1, $99A1
    call .waitforA
    call LoadStage3_DELIVER
    PRINT_MULTILINE Stage3_DELIVER.Text1, $99A1
    call .waitforA
    call LoadStage3_UPHOLD
    PRINT_MULTILINE Stage3_UPHOLD.Text1, $99A1

    call .waitforA

    call LoadStage4
    PRINT_MULTILINE Stage4.Text1, $99A1

    call .waitforA

    ; Turn Off and Leave
    call OFF
    WAIT_FRAMES 40
    call UI_FadeOut

    ld a, "M"
    ld [CurrentState], a
    jp ChangeState

; Waits for button press
.waitforA
    CHECK_BUTTON sDrpKeys, PADF_A
    ret
    END_CHECK
    call App_EndOfFrame
    jr .waitforA

.genWidget
    push bc
    push hl
    call App_GenerateRandom
    pop hl
    pop bc
    ld a, [RandomNumber]
    and $0F
    ld e, a
    ld d, 0
.notdone
    add hl, de
    dec b
    jr nz, .notdone
    PUT_16_BITS l, h, DynamicLabel
    ret

; Main Functions

; Loops between the two frames of animation
ON_9800:
    SET_ACTION Actions.Up, ON_9C00
    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_BG8800 | LCDCF_BG9800 | LCDCF_OBJON
    ldh [rLCDC], a
    ret

ON_9C00:
    SET_ACTION Actions.Up, ON_9800
    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_BG8800 | LCDCF_BG9C00 | LCDCF_OBJON
    ldh [rLCDC], a
    ret

; Turns the CRT effect off
OFF:
    SET_ACTION Actions.Up, NopFunction
    
    ld a, LCDCF_OFF | LCDCF_BGON | LCDCF_BG8000 | LCDCF_BG9800 | LCDCF_OBJON
    ldh [rLCDC], a

    ld a, BANK(Off)
    ld [BankNumber], a

    PUT_ADDRESS Memory_CopyWithOffset, FunctionPointer
    ld a, -$40
    ld [MemOffset], a
    ld de, Off.TransTile
    ld hl, _SCRN1
    ld bc, Off.TransTileEnd - Off.TransTile
    call App_CallFromBank

    ld a, -$80
    ld [MemOffset], a
    ld de, Off.StaticTile
    ld hl, _SCRN0
    ld bc, Off.StaticTileEnd - Off.StaticTile
    call App_CallFromBank

    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_BG8000 | LCDCF_BG9C00 | LCDCF_OBJON
    ldh [rLCDC], a
    
    call App_EndOfFrame
    call App_EndOfFrame

    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_BG8000 | LCDCF_BG9800 | LCDCF_OBJON
    ldh [rLCDC], a

    ret



; Stage 1
LoadStage1:
    ld a, LCDCF_OFF | LCDCF_BGON | LCDCF_BG8000 | LCDCF_BG9800 | LCDCF_OBJON
    ldh [rLCDC], a

    ld a, BANK(Off)
    ld [BankNumber], a

    PUT_ADDRESS Memory_Copy, FunctionPointer
    ld de, Stage1.Scan1Tile
    ld hl, _SCRN0
    ld bc, Stage1.Scan1TileEnd - Stage1.Scan1Tile
    call App_CallFromBank

    PUT_ADDRESS Memory_CopyWithOffset, FunctionPointer
    ld a, $40
    ld [MemOffset], a
    ld de, Stage1.Scan2Tile
    ld hl, _SCRN1
    ld bc, Stage1.Scan2TileEnd - Stage1.Scan2Tile
    call App_CallFromBank

    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_BG8000 | LCDCF_BG9800 | LCDCF_OBJON
    ldh [rLCDC], a

    SET_ACTION Actions.Up, ON_9800
    ret

; Stage 2
LoadStage2:
    ld a, BANK(Off)
    ld [BankNumber], a

    PUT_ADDRESS Memory_SafeCopy, FunctionPointer
    ld de, Stage2.Scan1Data
    ld hl, _VRAM8800
    ld bc, Stage2.Scan1DataEnd - Stage2.Scan1Data
    call App_CallFromBank

    ld de, Stage2.Scan2Data
    ld hl, $8C00
    ld bc, Stage2.Scan2DataEnd - Stage2.Scan2Data
    call App_CallFromBank

    ld de, Stage2.Scan1Tile
    ld hl, _SCRN0
    ld bc, Stage2.Scan1TileEnd - Stage2.Scan1Tile
    call App_CallFromBank

    PUT_ADDRESS Memory_SafeCopyWithOffset, FunctionPointer
    ld a, $40
    ld [MemOffset], a
    ld de, Stage2.Scan2Tile
    ld hl, _SCRN1
    ld bc, Stage2.Scan2TileEnd - Stage2.Scan2Tile
    call App_CallFromBank
    ret

; Stage 3
LoadStage3_None:
    ld a, BANK(Stage3_None)
    ld [BankNumber], a

    PUT_ADDRESS Memory_SafeCopy, FunctionPointer
    ld de, Stage3_None.Scan1Data
    ld hl, _VRAM8800
    ld bc, Stage3_None.Scan1DataEnd - Stage3_None.Scan1Data
    call App_CallFromBank

    ld de, Stage3_None.Scan2Data
    ld hl, $8C00
    ld bc, Stage3_None.Scan2DataEnd - Stage3_None.Scan2Data
    call App_CallFromBank

    ld de, Stage3_None.Scan1Tile
    ld hl, _SCRN0
    ld bc, Stage3_None.Scan1TileEnd - Stage3_None.Scan1Tile
    call App_CallFromBank

    PUT_ADDRESS Memory_SafeCopyWithOffset, FunctionPointer
    ld a, $40
    ld [MemOffset], a
    ld de, Stage3_None.Scan2Tile
    ld hl, _SCRN1
    ld bc, Stage3_None.Scan2TileEnd - Stage3_None.Scan2Tile
    call App_CallFromBank
    ret

LoadStage3_MAINTAIN:
    ld a, BANK(Stage3_MAINTAIN)
    ld [BankNumber], a

    PUT_ADDRESS Memory_SafeCopy, FunctionPointer
    ld de, Stage3_MAINTAIN.Scan1Data
    ld hl, _VRAM8800
    ld bc, Stage3_MAINTAIN.Scan1DataEnd - Stage3_MAINTAIN.Scan1Data
    call App_CallFromBank

    ld de, Stage3_MAINTAIN.Scan2Data
    ld hl, $8C00
    ld bc, Stage3_MAINTAIN.Scan2DataEnd - Stage3_MAINTAIN.Scan2Data
    call App_CallFromBank

    ld de, Stage3_MAINTAIN.Scan1Tile
    ld hl, _SCRN0
    ld bc, Stage3_MAINTAIN.Scan1TileEnd - Stage3_MAINTAIN.Scan1Tile
    call App_CallFromBank

    PUT_ADDRESS Memory_SafeCopyWithOffset, FunctionPointer
    ld a, $40
    ld [MemOffset], a
    ld de, Stage3_MAINTAIN.Scan2Tile
    ld hl, _SCRN1
    ld bc, Stage3_MAINTAIN.Scan2TileEnd - Stage3_MAINTAIN.Scan2Tile
    call App_CallFromBank
    ret

LoadStage3_DELIVER:
    ld a, BANK(Stage3_DELIVER)
    ld [BankNumber], a

    PUT_ADDRESS Memory_SafeCopy, FunctionPointer
    ld de, Stage3_DELIVER.Scan1Data
    ld hl, _VRAM8800
    ld bc, Stage3_DELIVER.Scan1DataEnd - Stage3_DELIVER.Scan1Data
    call App_CallFromBank

    ld de, Stage3_DELIVER.Scan2Data
    ld hl, $8C00
    ld bc, Stage3_DELIVER.Scan2DataEnd - Stage3_DELIVER.Scan2Data
    call App_CallFromBank

    ld de, Stage3_DELIVER.Scan1Tile
    ld hl, _SCRN0
    ld bc, Stage3_DELIVER.Scan1TileEnd - Stage3_DELIVER.Scan1Tile
    call App_CallFromBank

    PUT_ADDRESS Memory_SafeCopyWithOffset, FunctionPointer
    ld a, $40
    ld [MemOffset], a
    ld de, Stage3_DELIVER.Scan2Tile
    ld hl, _SCRN1
    ld bc, Stage3_DELIVER.Scan2TileEnd - Stage3_DELIVER.Scan2Tile
    call App_CallFromBank
    ret

LoadStage3_UPHOLD:
    ld a, BANK(Stage3_UPHOLD)
    ld [BankNumber], a

    PUT_ADDRESS Memory_SafeCopy, FunctionPointer
    ld de, Stage3_UPHOLD.Scan1Data
    ld hl, _VRAM8800
    ld bc, Stage3_UPHOLD.Scan1DataEnd - Stage3_UPHOLD.Scan1Data
    call App_CallFromBank

    ld de, Stage3_UPHOLD.Scan2Data
    ld hl, $8C00
    ld bc, Stage3_UPHOLD.Scan2DataEnd - Stage3_UPHOLD.Scan2Data
    call App_CallFromBank

    ld de, Stage3_UPHOLD.Scan1Tile
    ld hl, _SCRN0
    ld bc, Stage3_UPHOLD.Scan1TileEnd - Stage3_UPHOLD.Scan1Tile
    call App_CallFromBank

    PUT_ADDRESS Memory_SafeCopyWithOffset, FunctionPointer
    ld a, $40
    ld [MemOffset], a
    ld de, Stage3_UPHOLD.Scan2Tile
    ld hl, _SCRN1
    ld bc, Stage3_UPHOLD.Scan2TileEnd - Stage3_UPHOLD.Scan2Tile
    call App_CallFromBank
    ret

; Stage 4
LoadStage4:
    ld a, BANK(Stage4)
    ld [BankNumber], a

    PUT_ADDRESS Memory_SafeCopy, FunctionPointer
    ld de, Stage4.Scan1Data
    ld hl, _VRAM8800
    ld bc, Stage4.Scan1DataEnd - Stage4.Scan1Data
    call App_CallFromBank

    ld de, Stage4.Scan2Data
    ld hl, $8C00
    ld bc, Stage4.Scan2DataEnd - Stage4.Scan2Data
    call App_CallFromBank

    ld de, Stage4.Scan1Tile
    ld hl, _SCRN0
    ld bc, Stage4.Scan1TileEnd - Stage4.Scan1Tile
    call App_CallFromBank

    PUT_ADDRESS Memory_SafeCopyWithOffset, FunctionPointer
    ld a, $40
    ld [MemOffset], a
    ld de, Stage4.Scan2Tile
    ld hl, _SCRN1
    ld bc, Stage4.Scan2TileEnd - Stage4.Scan2Tile
    call App_CallFromBank
    ret

; Continue Menu Thingy
LoadContinue:
    ld a, BANK(Console)
    ld [BankNumber], a

    PUT_ADDRESS Memory_SafeCopy, FunctionPointer
    ld de, Console.Data2
    ld hl, $8C00
    ld bc, Console.Data2End - Console.Data2
    call App_CallFromBank
    
    ld de, Console.Data1
    ld hl, $9200
    ld bc, Console.Data1End - Console.Data1
    call App_CallFromBank

    PUT_ADDRESS Memory_SafeFill, FunctionPointer
    ld d, $C4
    ld hl, $9860
    ld bc, $9954 - $9860
    call App_CallFromBank

    ld d, $24
    ld hl, $9C60
    ld bc, $9D54 - $9C60
    call App_CallFromBank
    ret

ClearScreen:
    ld a, BANK(Console)
    ld [BankNumber], a

    PUT_ADDRESS Memory_SafeFill, FunctionPointer
    ld d, $C4
    ld hl, $9860
    ld bc, $9954 - $9860
    call App_CallFromBank

    ld d, $24
    ld hl, $9C60
    ld bc, $9D54 - $9C60
    call App_CallFromBank
    ret

