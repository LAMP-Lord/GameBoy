; UI Macros

MACRO WAIT_FRAMES
    ld a, \1
    ld [FrameCounter], a
    call App_WaitFrames
ENDM