INCLUDE "include/hardware.inc"

SECTION "ROM Header", ROM0[$100]
    nop
    jp EntryPoint

    NintendoLogo:
        db	$ce,$ed,$66,$66,$cc,$0d,$00,$0b,$03,$73,$00,$83,$00,$0c,$00,$0d
        db	$00,$08,$11,$1f,$88,$89,$00,$0e,$dc,$cc,$6e,$e6,$dd,$dd,$d9,$99
        db	$bb,$bb,$67,$63,$6e,$0e,$ec,$cc,$dd,$dc,$99,$9f,$bb,$b9,$33,$3e

    ROMTitle:		db	"SPACECHASE",0,0,0,0,0			; ROM title (15 bytes)
    GBCSupport:		db	0								; GBC support (0 = DMG only, $80 = DMG/GBC, $C0 = GBC only)
    NewLicenseCode:	db	"  "							; new license code (2 bytes)
    SGBSupport:		db	0								; SGB support
    CartType:		db	$1E								; Cart type (MBC5 + RUMBLE + RAM + Battery)
    ROMSize:		ds	1								; ROM size (handled by post-linking tool)
    RAMSize:		ds	1								; RAM size
    DestCode:		db	1								; Destination code (0 = Japan, 1 = All others)
    OldLicenseCode:	db	$33								; Old license code (if $33, check new license code)
    ROMVersion:		db	0								; ROM version
    HeaderChecksum:	ds	1								; Header checksum (handled by post-linking tool)
    ROMChecksum:	ds	2								; ROM checksum (2 bytes) (handled by post-linking tool)