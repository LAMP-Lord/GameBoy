; SECTION "Math        - Functions", ROM0

; ; Inputs:
; ;   B = radius (r)
; ;   C = angle index (0-7, representing 0°, 45°, 90°, etc.)
; ;   DE = center (cx, cy) (D = cx, E = cy)
; ; Outputs:
; ;   HL = point (x, y) (H = x, L = y)

; generate_circle_point::
;     ; Initialize output
;     ld H, D     ; x = cx
;     ld L, E     ; y = cy

;     ; Use angle index (C) to select one of 8 points
;     ld A, C
;     and 0x07    ; Mask to keep angle index in range 0-7

;     ; Compare angle index and jump to appropriate case
;     cp 0
;     jr z, .angle_0
;     cp 1
;     jr z, .angle_45
;     cp 2
;     jr z, .angle_90
;     cp 3
;     jr z, .angle_135
;     cp 4
;     jr z, .angle_180
;     cp 5
;     jr z, .angle_225
;     cp 6
;     jr z, .angle_270
;     cp 7
;     jr z, .angle_315
;     ret

; .angle_0    ; (r, 0)
;     ld a, h
;     add B    ; x = cx + r
;     ld h, a
;     ret

; .angle_45   ; (r*3/4, r*3/4)
;     ld A, B
;     srl A        ; A = r / 2
;     ld C, A      ; store r/2 in C
;     ld A, B
;     srl A        ; A = r / 2
;     srl A        ; A = r / 4
;     add C        ; A = r/2 + r/4 = 3r/4
;     ld C, A      ; save result
;     ld A, H
;     add C
;     ld H, A
;     ld A, L
;     add C
;     ld L, A
;     ret

; .angle_90   ; (0, r)
;     ld a, l
;     add B    ; y = cy + r
;     ld l, a
;     ret

; .angle_135  ; (-r*3/4, r*3/4)
;     ld A, B
;     srl A
;     ld C, A      ; C = r/2
;     ld A, B
;     srl A
;     srl A
;     add C        ; A = r*3/4
;     ld C, A

;     ld A, H
;     sub C        ; x = cx - r*3/4
;     ld H, A
;     ld A, L
;     add C        ; y = cy + r*3/4
;     ld L, A
;     ret

; .angle_180  ; (-r, 0)
;     ld a, h
;     sub B    ; x = cx - r
;     ld h, a
;     ret

; .angle_225  ; (-r*3/4, -r*3/4)
;     ld A, B
;     srl A
;     ld C, A
;     ld A, B
;     srl A
;     srl A
;     add C
;     ld C, A

;     ld A, H
;     sub C
;     ld H, A
;     ld A, L
;     sub C
;     ld L, A
;     ret

; .angle_270  ; (0, -r)
;     ld a, l
;     sub B    ; y = cy - r
;     ld l, a
;     ret

; .angle_315  ; (r*3/4, -r*3/4)
;     ld A, B
;     srl A
;     ld C, A
;     ld A, B
;     srl A
;     srl A
;     add C
;     ld C, A

;     ld A, H
;     add C
;     ld H, A
;     ld A, L
;     sub C
;     ld L, A
;     ret