INCLUDE "hardware.inc"
INCLUDE "charmap.inc"

EXPORT Save.Checksum
EXPORT Save.Version

EXPORT Save.Seed
EXPORT Save.Sector
EXPORT Save.System
EXPORT Save.Location

EXPORT Save.PlayerName
EXPORT Save.Money
EXPORT Save.CurrentFuel
EXPORT Save.CargoType
EXPORT Save.CargoHealth
EXPORT Save.HullHealth
EXPORT Save.Difficulty
EXPORT Save.TotalMoney
EXPORT Save.TotalKills

EXPORT Save.FuelTanks
EXPORT Save.Generators
EXPORT Save.Padding
EXPORT Save.Insurance
EXPORT Save.HullPlating
EXPORT Save.OxygenTanks
EXPORT Save.ReactivePlating

DEF VERSION_HI EQU "S"
DEF VERSION_LO EQU "C"

SECTION "Memory Offset Value", HRAM
MemOffset:: ds 1

SECTION "Save Storage", SRAM

SRAM_Save:
    ; Metadata
    .Checksum ds 1
    .Version ds 2

    ; Generation
    .Seed ds 2
    .Sector ds 2
    .System ds 1
    .Location ds 1

    ; Run Info
    .PlayerName ds 10
    ds 1
    .Money ds 2
    .CurrentFuel ds 1
    .CargoType ds 1
    .CargoHealth ds 1
    .HullHealth ds 1
    .Difficulty ds 2
    .TotalMoney ds 2
    .TotalKills ds 2

    ; Upgrades
    .FuelTanks ds 1
    .Generators ds 1
    .Padding ds 1
    .Insurance ds 1
    .HullPlating ds 1
    .OxygenTanks ds 1
    .ReactivePlating ds 1
SRAM_SaveEnd:

SRAM_Mirror:
    ; Metadata
    .Checksum ds 1
    .Version ds 2

    ; Generation
    .Seed ds 2
    .Sector ds 2
    .System ds 1
    .Location ds 1

    ; Run Info
    .PlayerName ds 10
    ds 1
    .Money ds 2
    .CurrentFuel ds 1
    .CargoType ds 1
    .CargoHealth ds 1
    .HullHealth ds 1
    .Difficulty ds 2
    .TotalMoney ds 2
    .TotalKills ds 2

    ; Upgrades
    .FuelTanks ds 1
    .Generators ds 1
    .Padding ds 1
    .Insurance ds 1
    .HullPlating ds 1
    .OxygenTanks ds 1
    .ReactivePlating ds 1
SRAM_MirrorEnd:

SECTION "Save Variables", WRAM0

ValidSave:: ds 1

Save::
    ; Metadata
    .Checksum ds 1
    .Version ds 2

    ; Generation
    .Seed ds 2
    .Sector ds 2
    .System ds 1
    .Location ds 1

    ; Run Info
    .PlayerName ds 10
    ds 1
    .Money ds 2
    .CurrentFuel ds 1
    .CargoType ds 1
    .CargoHealth ds 1
    .HullHealth ds 1
    .Difficulty ds 2
    .TotalMoney ds 2
    .TotalKills ds 2

    ; Upgrades
    .FuelTanks ds 1
    .Generators ds 1
    .Padding ds 1
    .Insurance ds 1
    .HullPlating ds 1
    .OxygenTanks ds 1
    .ReactivePlating ds 1
SaveEnd::

SECTION "Memory      - Memory Functions", ROM0

Memory_CopyWithOffset::
    push bc
.loop
    ld a, [de]
    ld b, a
    ld a, [MemOffset]
    add b
    ld [hli], a

    inc de
    pop bc
    dec bc
    ld a, b
    or c
    push bc

    jr nz, .loop
    pop bc
    ret

Memory_SafeCopyWithOffset::
    push bc
.loop
    ldh a, [rSTAT]
    and %11
    cp $1
    call nz, notSafe

    ld a, [de]
    ld b, a
    ld a, [MemOffset]
    add b
    ld [hli], a

    inc de
    pop bc
    dec bc
    ld a, b
    or c
    push bc

    jr nz, .loop
    pop bc
    ret

; DE = Source
; HL = Destination
; BC = Bytes
Memory_Copy::
    ld a, [de]
    ld [hli], a

    inc de
    dec bc

    ld a, b
    or c
    jr nz, Memory_Copy
    ret

Memory_CopyForSprite::
    push   bc
    ; — fetch one 8-pixel row (Low, High) —
    ld     a, [de]        ; A = low-plane byte
    inc    de
    ld     b, a           ; save it in B
    ld     a, [de]        ; A = high-plane byte
    inc    de
    ld     c, a           ; save it in C

    ; — new LOW plane = ~(Low ⊕ High)  (XNOR) —
    ld     a, b
    xor    c             ; A = Low ⊕ High
    cpl                  ; A = ~(Low ⊕ High)
    ld     [hli], a      ; write new low plane

    ; — new HIGH plane = Low ∨ High —
    ld     a, b
    or     c             ; A = Low ∨ High
    ld     [hli], a      ; write new high plane

    ; — restore counter and loop —
    pop    bc            ; BC = remaining bytes*2
    dec    bc
    dec    bc
    ld     a, b
    or     c             ; Z when BC == 0
    jr     nz, Memory_CopyForSprite
    ret

; DE = Source
; HL = Destination
; BC = Bytes
Memory_SafeCopy::
    ldh a, [rSTAT]
    and %11
    cp $1
    call nz, notSafe

    ld a, [de]
    ld [hli], a

    inc de
    dec bc

    ld a, b
    or c
    jr nz, Memory_SafeCopy
    ret 
    
notSafe:
    push de
    push hl
    push bc
    call App_EndOfFrame
    pop bc
    pop hl
    pop de
    ret

; D  = Source
; HL = Destination
; BC = Bytes
Memory_Fill::
    ld a, d
    ld [hli], a
    dec bc
    ld a, b
    or c
    jr nz, Memory_Fill
    ret

Memory_SafeFill::
    ldh a, [rSTAT]
    and %11
    cp $1
    call nz, notSafe

    ld a, d
    ld [hli], a
    dec bc
    ld a, b
    or c
    jr nz, Memory_SafeFill
    ret

; HL = Save Location (Start at .Version)
; B  = Save Size (SaveEnd - Save.Version)
; C  = Checksum
Memory_CalculateChecksum:
    ld c, 0
.loop
    ld a, [hli]
    xor c
    ld c, a

    dec b
    jr nz, .loop
    ret

Memory_LoadSave::
    ld a, CART_SRAM_ENABLE
    ld [rRAMG], a

    ; Checksum
    ld hl, SRAM_Save + 1
    ld b, SRAM_SaveEnd - SRAM_Save - 1 ; (Skips the checksum)
    call Memory_CalculateChecksum

    ld a, [SRAM_Save.Checksum]
    cp c
    jr nz, .TestMirror

    ; Version Check
    ld a, [SRAM_Save.Version]
    cp VERSION_HI
    jr nz, .TestMirror

    ld a, [SRAM_Save.Version+1]
    cp VERSION_LO
    jr nz, .TestMirror
    
    ; Valid Save
    ld de, SRAM_Save
    ld hl, Save
    ld bc, SRAM_SaveEnd - SRAM_Save
    call Memory_Copy

    jr .continue

.TestMirror
    ; Checksum
    ld hl, SRAM_Mirror + 1
    ld b, SRAM_MirrorEnd - SRAM_Mirror - 1 ; (Skips the checksum)
    call Memory_CalculateChecksum
    
    ld a, [SRAM_Mirror.Checksum]
    cp c
    jr z, .Invalid

    ; Version Check
    ld a, [SRAM_Mirror.Version]
    cp VERSION_HI
    jr nz, .Invalid

    ld a, [SRAM_Mirror.Version+1]
    cp VERSION_LO
    jr nz, .Invalid
    
    ; Valid Save
    ld de, SRAM_Mirror
    ld hl, Save
    ld bc, SRAM_MirrorEnd - SRAM_Mirror
    call Memory_Copy

    jr .continue

.Invalid
    ; Failed both checksums
    ; Bad save
    ld a, CART_SRAM_DISABLE
    ld [rRAMG], a

    ld a, 0
    ld [ValidSave], a

    ret

.continue
    ld a, CART_SRAM_DISABLE
    ld [rRAMG], a

    ld a, 1
    ld [ValidSave], a

    ret

Memory_SaveGame::
    ld a, VERSION_HI
    ld [Save.Version], a
    ld a, VERSION_LO
    ld [Save.Version+1], a

    ld hl, Save + 1
    ld b, SaveEnd - Save - 1
    call Memory_CalculateChecksum
    ld a, c
    ld [Save.Checksum], a

    ld a, CART_SRAM_ENABLE
    ld [rRAMG], a

    ld de, Save
    ld hl, SRAM_Save
    ld bc, SaveEnd - Save
    call Memory_Copy

    ld de, Save
    ld hl, SRAM_Mirror
    ld bc, SaveEnd - Save
    call Memory_Copy

    ld a, CART_SRAM_DISABLE
    ld [rRAMG], a

    ret