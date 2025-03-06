INCLUDE "include/hardware.inc"

SECTION "Audio - Sound Functions", ROM0

Audio_SFX_Lazer::
    call Audio_OverrideCh2

    ; Setup square wave, no length limit
    ld   a, %10000000
    ld   [rNR21], a

    ; Max volume, quick decay
    ld   a, %11110000
    ld   [rNR22], a

    ; Start frequency HIGH for high-pitched laser
    ld   a, $20            ; Low numeric value = high pitch
    ld   [rNR23], a
    ld   a, %10000001      ; Upper frequency bits = 1, trigger on
    ld   [rNR24], a

    ld   c, 5              ; Quick 5-frame sweep
Laser_Loop:
    call Int_WaitForVBlank

    ; Slightly lower pitch each frame by increasing frequency
    ld   a, [rNR23]
    add  a, $10            ; Increment slightly for controlled sweep
    ld   [rNR23], a

    jr   nc, .no_overflow
        ; If overflow, increment upper bits carefully
        ld   a, [rNR24]
        inc  a             ; increment frequency high bits
        and  %00000111
        or   %10000000     ; Trigger bit OFF, keep upper freq bits
        ld   [rNR24], a
.no_overflow:

    dec  c
    jr   nz, Laser_Loop

    call Audio_ResetCh2
    ret

SECTION "Audio - Channel Overrides", ROM0

Audio_OverrideCh1::
    ld b, $0
    ld c, $1
    call hUGE_mute_channel
    ret

Audio_OverrideCh2::
    ld b, $1
    ld c, $1
    call hUGE_mute_channel
    ret

Audio_OverrideCh3::
    ld b, $2
    ld c, $1
    call hUGE_mute_channel
    ret

Audio_OverrideCh4::
    ld b, $3
    ld c, $1
    call hUGE_mute_channel
    ret

Audio_ResetCh1::
    ld b, $0
    ld c, $0
    call hUGE_mute_channel
    ret

Audio_ResetCh2::
    ld b, $1
    ld c, $0
    call hUGE_mute_channel
    ret

Audio_ResetCh3::
    ld b, $2
    ld c, $0
    call hUGE_mute_channel
    ret

Audio_ResetCh4::
    ld b, $3
    ld c, $0
    call hUGE_mute_channel
    ret