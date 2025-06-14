INCLUDE "include/hardware.inc"

SECTION "Interrupts - VBlank Vector", ROM0[$0040]
    jp Int_VBlankInterrupt

; SECTION "Interrupts - Stat Vector", ROM0[$0048]
;     jp Int_StatInterrupt

SECTION "Interrupts - Interrupt Functions", ROM0

Int_InitInterrupts::
    ld a, IEF_VBLANK
    ldh [rIE], a
    xor a
    ldh [rIF], a
    ei

    ; ld a, STATF_LYC
    ; ldh [rSTAT], a

    ; xor a
    ; ldh [rLYC], a

    ret

Int_VBlankInterrupt:
    xor a
    ldh [rIF], a

    reti

; Int_StatInterrupt:
;     xor a
;     ldh [rIF], a

;     reti


Int_WaitForVBlank::
    call hUGE_dosound
    call sMOL_dosound
    
    call Input_Query
    call Input_ProcessActions
    
    halt

    ret