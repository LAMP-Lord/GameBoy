INCLUDE "hardware.inc"

SECTION "ROM Header", ROM0[$100]
    nop
    jp EntryPoint

    NINTENDO_LOGO

    ROMTitle:		db	"SPACECHASE",0,0,0,0,0			; ROM title (15 bytes)
    GBCSupport:		db	CART_COMPATIBLE_GBC			; GBC support (0 = DMG only, $80 = DMG/GBC, $C0 = GBC only)
    NewLicenseCode:	db	"  "							; new license code (2 bytes)
    SGBSupport:		db	CART_INDICATOR_GB				; SGB support
    CartType:		db	CART_ROM_MBC5_RAM_BAT_RUMBLE	; Cart type
    ROMSize:		ds	1								; ROM size (handled by post-linking tool)
    RAMSize:		ds	1								; RAM size
    DestCode:		db	CART_DEST_NON_JAPANESE			; Destination code (0 = Japan, 1 = All others)
    OldLicenseCode:	db	$33								; Old license code (if $33, check new license code)
    ROMVersion:		db	0								; ROM version
    HeaderChecksum:	ds	1								; Header checksum (handled by post-linking tool)
    ROMChecksum:	ds	2								; ROM checksum (2 bytes) (handled by post-linking tool)