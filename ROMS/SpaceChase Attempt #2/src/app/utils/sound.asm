INCLUDE "include/hardware.inc"

SECTION "Audio      - Variables", WRAM0

hUGE_Bank:: db

SECTION "Audio      - Sound Functions", ROM0

SoundFX_Lazer::
    call Audio_OverrideCh2
    ret

SECTION "Audio      - Channel Overrides", ROM0

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
    ld a, 100
    ld [hUGE_current_wave], a

    ld b, $2
    ld c, $0
    call hUGE_mute_channel
    ret

Audio_ResetCh4::
    ld b, $3
    ld c, $0
    call hUGE_mute_channel
    ret