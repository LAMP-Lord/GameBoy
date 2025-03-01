INCLUDE "include/hardware.inc"

SECTION "State Handler", ROM0

NextGameState::
    ; ld a, 1
    ; ld [wVBlankCount], a

    ; call WaitForVBlank
    ; call ClearBackground

    ; Turn off LCD
    ; xor a
    ; ld [rLCDC], a

    ; Reset scrolling
    ld [rSCX], a
    ld [rSCY], a

    ; Set window x and y
    ld [rWY], a
    ld a, 7
    ld [rWX], a ; "Values of 0-6 and 166 are unreliable due to hardware bugs." - hardware.inc

    ; call DisableInterrupts
    ; call ClearAllSprites

    ; Initiate the next state
    ; Gameplay
    ; ld a, [wGameState]
    ; cp 2
    ; call z, InitGameplayState

    ; ; Story
    ; ld a, [wGameState]
    ; cp 1
    ; call z, InitStoryState

    ; Menu
    ld a, [wGameState]
    and a
    call z, InitTitleScreenState

    ; Update the next state
    ; Gameplay
    ; ld a, [wGameState]
    ; cp 2
    ; jp z, UpdateGameplayState

    ; ; Story
    ; cp 1
    ; jp z, UpdateStoryState

    ; Menu
    jp UpdateTitleScreenState



