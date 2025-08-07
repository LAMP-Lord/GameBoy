INCLUDE "hardware.inc"

SECTION "App - ROM Header", ROM0[$100]
    nop
    jp EntryPoint

    NintendoLogo:
        db $CE, $ED, $66, $66, $CC, $0D, $00, $0B, $03, $73, $00, $83, $00, $0C, $00, $0D
        db $00, $08, $11, $1F, $88, $89, $00, $0E, $DC, $CC, $6E, $E6, $DD, $DD, $D9, $99
        db $BB, $BB, $67, $63, $6E, $0E, $EC, $CC, $DD, $DC, $99, $9F, $BB, $B9, $33, $3E

    ROMTitle:		db	"SPACECHASE",0,0,0,0,0			; ROM title (15 bytes)
    GBCSupport:		db	$00                 			; GBC support
    NewLicenseCode:	db	"  "							; new license code (2 bytes)
    SGBSupport:		db	$00              				; SGB support
    CartType:		db	$1B                            	; Cart type
    ROMSize:		db	$05								; ROM size
    RAMSize:		db	$02								; RAM size
    DestCode:		db	$01                 			; Destination code
    OldLicenseCode:	db	$33								; Old license code
    ROMVersion:		db	0								; ROM version
    HeaderChecksum:	ds	1								; Header checksum
    ROMChecksum:	ds	2								; ROM checksum