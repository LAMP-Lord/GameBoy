INCLUDE "include/hardware.inc"
INCLUDE "include/charmap.inc"
INCLUDE "include/input_macros.inc"

SECTION "State Handler Variables", WRAM0

CurrentState:: ds 1

SECTION "State Handler", ROM0

ChangeState::
    ; Clean up
    ld sp, $FFFE

    ; Clear the OAM
    ld d, 0
    ld hl, _OAMRAM
    ld bc, 160
    call Memory_Fill

    ; Load new state
    ld a, [CurrentState]

    cp "T"
    jp nz, .titleskip
    ; Title Screen
    ld a, 1
    ld [ActiveBank], a
    ld [$2000], a
    jp TitleScreen_EntryPoint
.titleskip

    cp "M"
    jp nz, .mapskip
    ; Starmap
    ld a, 2
    ld [ActiveBank], a
    ld [$2000], a
    jp Starmap_EntryPoint
.mapskip

    cp "I"
    jp nz, .introskip
    ; Intro Sequence
    ld a, 1
    ld [ActiveBank], a
    ld [$2000], a
    jp Intro_EntryPoint
.introskip

    cp "C"
    jp nz, .chaseskip
    ; Chase
    ld a, 1
    ld [ActiveBank], a
    ld [$2000], a
    ; jp Chase_EntryPoint
.chaseskip

    jr ChangeState