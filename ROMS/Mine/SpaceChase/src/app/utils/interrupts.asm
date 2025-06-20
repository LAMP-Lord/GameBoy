INCLUDE "include/hardware.inc"

SECTION "Interrupts  - VBlank Vector", ROM0[$0040]
    jp Int_VBlankInterrupt

; SECTION "Interrupts  - Stat Vector", ROM0[$0048]
;     jp Int_StatInterrupt

SECTION "Interrupts  - Interrupt Functions", ROM0

Int_InitInterrupts::
    ld a, IEF_VBLANK
    ldh [rIE], a
    xor a
    ldh [rIF], a

    reti

Int_VBlankInterrupt:
    push af
    xor a
    ldh [rIF], a
    pop af
    reti

; Int_StatInterrupt:
;     xor a
;     ldh [rIF], a

;     reti