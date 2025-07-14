INCLUDE "hardware.inc"
INCLUDE "charmap.inc"
INCLUDE "macros/input_macros.inc"

SECTION "State Handler Variables", WRAM0

CurrentState:: ds 1

SECTION "State Handler", ROM0

ChangeState::
    ; Shutoff UI
    ld a, LCDCF_OFF
    ldh [rLCDC], a

    ; Clean up
    ld sp, $FFFE
    call App_Reset

    ; Load new state
    ld a, [CurrentState]

    cp "T"
    jr nz, .titleskip
    ; Title Screen
    ld a, BANK(TitleScreen_EntryPoint)
    ldh [ActiveBank], a
    ldh [BankCache], a
    ld [$2000], a
    jp TitleScreen_EntryPoint
.titleskip

    cp "M"
    jr nz, .mapskip
    ; Starmap
    ld a, BANK(Starmap_EntryPoint)
    ldh [ActiveBank], a
    ldh [BankCache], a
    ld [$2000], a
    jp Starmap_EntryPoint
.mapskip

    cp "I"
    jr nz, .introskip
    ; Intro Sequence
    ld a, BANK(Intro_EntryPoint)
    ldh [ActiveBank], a
    ldh [BankCache], a
    ld [$2000], a
    jp Intro_EntryPoint
.introskip

    cp "C"
    jr nz, .chaseskip
    ; Chase
    ; ld a, BANK(Chase_EntryPoint)
    ldh [ActiveBank], a
    ldh [BankCache], a
    ld [$2000], a
    ; jp Chase_EntryPoint
.chaseskip

    jr ChangeState