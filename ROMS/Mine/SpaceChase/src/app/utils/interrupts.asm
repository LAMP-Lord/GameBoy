INCLUDE "hardware.inc"

SECTION "Interrupts  - VBlank Vector", ROM0[$0040]
    jp Int_VBlankInterrupt

SECTION "Interrupts  - Interrupt Functions", ROM0

Int_InitInterrupts::
    ld a, IEF_VBLANK
    ldh [rIE], a

    xor a
    ldh [rIF], a

    reti

Int_VBlankInterrupt:
    push af

    ldh a, [rIF]
    res 0, a
    ldh [rIF], a

    pop af
    reti