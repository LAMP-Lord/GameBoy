INCLUDE "include/hardware.inc"

SECTION "ROM Header", ROM0[$100]
    nop
    jp EntryPoint

    NintendoLogo:	; DO NOT MODIFY!!!
        db	$ce,$ed,$66,$66,$cc,$0d,$00,$0b,$03,$73,$00,$83,$00,$0c,$00,$0d
        db	$00,$08,$11,$1f,$88,$89,$00,$0e,$dc,$cc,$6e,$e6,$dd,$dd,$d9,$99
        db	$bb,$bb,$67,$63,$6e,$0e,$ec,$cc,$dd,$dc,$99,$9f,$bb,$b9,$33,$3e

    ROMTitle:		db	"SPACECHASE",0,0,0,0,0			; ROM title (15 bytes)
    GBCSupport:		db	0								; GBC support (0 = DMG only, $80 = DMG/GBC, $C0 = GBC only)
    NewLicenseCode:	db	"  "							; new license code (2 bytes)
    SGBSupport:		db	0								; SGB support
    CartType:		db	$03								; Cart type (MBC1 + RAM + Battery)
    ROMSize:		ds	1								; ROM size (handled by post-linking tool)
    RAMSize:		ds	1								; RAM size
    DestCode:		db	1								; Destination code (0 = Japan, 1 = All others)
    OldLicenseCode:	db	$33								; Old license code (if $33, check new license code)
    ROMVersion:		db	0								; ROM version
    HeaderChecksum:	ds	1								; Header checksum (handled by post-linking tool)
    ROMChecksum:	ds	2								; ROM checksum (2 bytes) (handled by post-linking tool)

SECTION "Entry Point", ROM0

EntryPoint:
    ld a, LCDCF_OFF
    ld [rLCDC], a

    ld a, %00_01_10_11
    ld [rBGP], a

    ; call Text_LoadFont

    ld a, $1
    ld [sMOL_Bank], a

    call Int_InitInterrupts

    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON | LCDCF_OBJ8 | LCDCF_WINON | LCDCF_WIN9C00
    ld [rLCDC], a

    ; call Text_PrintText

    call Music_MainTheme

Loop:
    ld a, PADF_A
    ld [mWaitKey], a

    call WaitForKeyFunction

    call SFX_Lazer

    jp Loop



SECTION "Test       - Text", ROM0
TestText:
    db "sigma"