INCLUDE "include/hardware.inc"

SECTION "Interrupts  - Variables", HRAM
ActiveBank:: ds 1
FrameCounter:: ds 1

SECTION "Interrupts - VBlank Vector", ROM0[$0040]
    jp Int_VBlankInterrupt

SECTION "Interrupts - Stat Vector", ROM0[$0048]
    jp Int_StatInterrupt

SECTION "Interrupts - Interrupt Functions", ROM0

Int_InitInterrupts::
    ld a, IEF_VBLANK
    ldh [rIE], a
    xor a
    ldh [rIF], a

    reti

Int_VBlankInterrupt:
    xor a
    ldh [rIF], a

    reti

Int_StatInterrupt:
    xor a
    ldh [rIF], a

    reti

SECTION "App        - Functions", ROM0

App_EndOfFrame::
    call sMOL_dosound
    call hUGE_dosound
    
    ld a, [ActiveBank]
    ld [$2000], a

    call Input_Query
    call Actions_ProcessActions

    halt

    ret

App_WaitFrames::
    call App_EndOfFrame
    ld a, [FrameCounter]
    dec a
    ld [FrameCounter], a
    jr nz, App_WaitFrames
    ret