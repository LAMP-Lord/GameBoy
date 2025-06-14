INCLUDE "include/hardware.inc"
INCLUDE "include/transition_macros.inc"

SECTION "State Handler - Variables", WRAM0

CurrentState:: ds 1

SECTION "State Handler - Main", ROM0

StateHandler::
    jp StateHandler