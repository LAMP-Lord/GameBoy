INCLUDE "include/hardware.inc"

EXPORT Save.Checksum
EXPORT Save.Seed
EXPORT Save.Sector
EXPORT Save.System
EXPORT Save.Location
EXPORT Save.Money
EXPORT Save.CurrentFuel
EXPORT Save.CargoType
EXPORT Save.CargoHealth
EXPORT Save.HullHealth
EXPORT Save.Difficulty
EXPORT Save.TotalMoney
EXPORT Save.EnemiesKilled
EXPORT Save.FuelTanks
EXPORT Save.Generators
EXPORT Save.Padding
EXPORT Save.Insurance
EXPORT Save.HullPlating
EXPORT Save.OxygenTanks
EXPORT Save.ReactivePlating

SECTION "Save Storage", SRAM

SRAM_Save:
    ; Metadata
    .Checksum ds 1

    ; Generation
    .Seed ds 2
    .Sector ds 2
    .System ds 1
    .Location ds 1

    ; Run Info
    .Money ds 2
    .CurrentFuel ds 2
    .CargoType ds 1
    .CargoHealth ds 2
    .HullHealth ds 2
    .Difficulty ds 2
    .TotalMoney ds 2
    .EnemiesKilled ds 2

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

    ; Generation
    .Seed ds 2
    .Sector ds 2
    .System ds 1
    .Location ds 1

    ; Run Info
    .Money ds 2
    .CurrentFuel ds 2
    .CargoType ds 1
    .CargoHealth ds 2
    .HullHealth ds 2
    .Difficulty ds 2
    .TotalMoney ds 2
    .EnemiesKilled ds 2

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

    ; Generation
    .Seed ds 2
    .Sector ds 2
    .System ds 1
    .Location ds 1

    ; Run Info
    .Money ds 2
    .CurrentFuel ds 2
    .CargoType ds 1
    .CargoHealth ds 2
    .HullHealth ds 2
    .Difficulty ds 2
    .TotalMoney ds 2
    .EnemiesKilled ds 2

    ; Upgrades
    .FuelTanks ds 1
    .Generators ds 1
    .Padding ds 1
    .Insurance ds 1
    .HullPlating ds 1
    .OxygenTanks ds 1
    .ReactivePlating ds 1
SaveEnd::

SECTION "Memory     - Memory Functions", ROM0

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

    ld hl, SRAM_Save + 1
    ld b, SRAM_SaveEnd - SRAM_Save - 1
    call Memory_CalculateChecksum

    ld a, [SRAM_Save.Checksum]
    cp c
    jr z, .ValidSave

    ld hl, SRAM_Mirror + 1
    ld b, SRAM_MirrorEnd - SRAM_Mirror - 1
    call Memory_CalculateChecksum
    
    ld a, [SRAM_Mirror.Checksum]
    cp c
    jr z, .ValidMirror

    ; Failed checksum
    ; Bad save

    ld a, CART_SRAM_DISABLE
    ld [rRAMG], a

    ld a, 0
    ld [ValidSave], a

    ret

.ValidMirror
    ld de, SRAM_Mirror
    ld hl, SRAM_Save
    ld bc, SRAM_MirrorEnd - SRAM_Mirror
    call Memory_Copy

.ValidSave
    ld de, SRAM_Save
    ld hl, Save
    ld bc, SRAM_SaveEnd - SRAM_Save
    call Memory_Copy

    ld a, CART_SRAM_DISABLE
    ld [rRAMG], a

    ld a, 1
    ld [ValidSave], a

    ret

Memory_SaveGame::
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