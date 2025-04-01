INCLUDE "include/hardware.inc"
INCLUDE "include/charmap.inc"

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

    call Text_LoadFont

    ; Clear screen (tile map at $9800)
    ld hl, _SCRN0
    ld bc, SCRN_VX_B * SCRN_VY_B  ; 32x32 tiles = 1024 bytes
    ld a, $00                     ; Blank tile
    call Memory_Fill

    ld a, 1
    ld [OnCart], a

    ; Initialize input variables
    xor a
    ld [wCurKeys], a
    ld [wNewKeys], a
    ld [nCurKeys], a
    ld [nNewKeys], a

    ld a, $1
    ld [sMOL_Bank], a

    call Int_InitInterrupts

    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_WINOFF | LCDCF_BG8800 | LCDCF_BG9800
    ld [rLCDC], a

    ; call Text_PrintText

    ld hl, SFX
    call sMOL_init

    call Music_MainTheme

Loop:
    ld a, PADF_A
    ld [mWaitKey], a
    call WaitForKeyFunction

    jp Loop



SECTION "Test       - Text", ROM0
TestText:
    db "sigma"


SECTION "Display - Functions", ROM0
DisplayInputs::
    ; --- Standard Inputs (Row 1 at $9800) ---
    ld hl, _SCRN0          ; $9800
    ld a, [wCurKeys]       ; Load standard inputs
    ld b, a                ; B holds inverted wCurKeys

    ; A (bit 0)
    bit PADB_A, b          ; Test bit 0
    ld a, "A" & $FF
    jr nz, .set_a          ; Bit = 1 -> pressed
    ld a, " " & $FF
.set_a:
    ld [hli], a

    ; B (bit 1)
    bit PADB_B, b
    ld a, "B" & $FF
    jr nz, .set_b
    ld a, " "
.set_b:
    ld [hli], a

    ; Select (bit 2)
    bit PADB_SELECT, b
    ld a, "S" & $FF
    jr nz, .set_select
    ld a, " "
.set_select:
    ld [hli], a

    ; Start (bit 3)
    bit PADB_START, b
    ld a, "T" & $FF
    jr nz, .set_start
    ld a, " "
.set_start:
    ld [hli], a

    ; Right (bit 4)
    bit PADB_RIGHT, b
    ld a, "R" & $FF
    jr nz, .set_right
    ld a, " "
.set_right:
    ld [hli], a

    ; Left (bit 5)
    bit PADB_LEFT, b
    ld a, "L" & $FF
    jr nz, .set_left
    ld a, " "
.set_left:
    ld [hli], a

    ; Up (bit 6)
    bit PADB_UP, b
    ld a, "U" & $FF
    jr nz, .set_up
    ld a, " "
.set_up:
    ld [hli], a

    ; Down (bit 7)
    bit PADB_DOWN, b
    ld a, "D" & $FF
    jr nz, .set_down
    ld a, " "
.set_down:
    ld [hli], a

    ; --- Extra Inputs (Row 2 at $9820) ---
    ld hl, _SCRN0 + SCRN_VX_B  ; $9820
    ld a, [nCurKeys]           ; Load extra inputs
    ld b, a                    ; B holds nCurKeys (active-high)

    ; X (bit 0)
    bit 0, b
    ld a, "X" & $FF
    jr nz, .set_x          ; Bit = 1 -> pressed
    ld a, " "
.set_x:
    ld [hli], a

    ; Y (bit 1)
    bit 1, b
    ld a, "Y" & $FF
    jr nz, .set_y
    ld a, " "
.set_y:
    ld [hli], a

    ; L (bit 4)
    bit 4, b
    ld a, "L" & $FF
    jr nz, .set_l
    ld a, " "
.set_l:
    ld [hli], a

    ; R (bit 5)
    bit 5, b
    ld a, "R" & $FF
    jr nz, .set_r
    ld a, " "
.set_r:
    ld [hli], a

    ; L2 (bit 6)
    bit 6, b
    ld a, "2" & $FF
    jr nz, .set_l2
    ld a, " "
.set_l2:
    ld [hli], a

    ; R2 (bit 7)
    bit 7, b
    ld a, "3" & $FF
    jr nz, .set_r2
    ld a, " "
.set_r2:
    ld [hli], a

    ret