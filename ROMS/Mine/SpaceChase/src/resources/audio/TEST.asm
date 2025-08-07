include "hUGE.inc"

SECTION "M_TEST Song Data", ROMX

M_TEST::
db 7
dw order_cnt
dw order1, order2, order3, order4
dw duty_instruments, wave_instruments, noise_instruments
dw routines
dw waves

order_cnt: db 4
order1: dw P0,P0
order2: dw P1,P1
order3: dw P4,P5
order4: dw P6,P6

P0:
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000

P1:
 dn F_3,1,$C08
 dn G#3,2,$C05
 dn F_4,1,$C08
 dn C_4,2,$C05
 dn F_3,1,$C08
 dn G#3,2,$C05
 dn F_4,1,$C08
 dn C_4,2,$C05
 dn F_3,1,$C08
 dn G#3,2,$C05
 dn F_4,1,$C08
 dn C_4,2,$C05
 dn F_3,1,$C08
 dn G#3,2,$C05
 dn F_4,1,$C08
 dn C_4,2,$C05
 dn F_3,1,$C08
 dn G#3,2,$C05
 dn F_4,1,$C08
 dn C_4,2,$C05
 dn F_3,1,$C08
 dn G#3,2,$C05
 dn F_4,1,$C08
 dn C_4,2,$C05
 dn F_3,1,$C08
 dn G#3,2,$C05
 dn F_4,1,$C08
 dn C_4,2,$C05
 dn F_3,1,$C08
 dn G#3,2,$C05
 dn F_4,1,$C08
 dn C_4,2,$C05
 dn F_3,1,$C08
 dn A#3,2,$C05
 dn F_4,1,$C08
 dn C#4,2,$C05
 dn F_3,1,$C08
 dn A#3,2,$C05
 dn F_4,1,$C08
 dn C#4,2,$C05
 dn F_3,1,$C08
 dn A#3,2,$C05
 dn F_4,1,$C08
 dn C#4,2,$C05
 dn F_3,1,$C08
 dn A#3,2,$C05
 dn F_4,1,$C08
 dn C#4,2,$C05
 dn F_3,1,$C08
 dn A_3,2,$C05
 dn F_4,1,$C08
 dn C_4,2,$C05
 dn F_3,1,$C08
 dn A_3,2,$C05
 dn F_4,1,$C08
 dn C_4,2,$C05
 dn F_3,1,$C08
 dn A_3,2,$C05
 dn F_4,1,$C08
 dn C_4,2,$C05
 dn F_3,1,$C08
 dn A_3,2,$C05
 dn F_4,1,$C08
 dn C_4,2,$C05

P4:
 dn F_6,1,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn C_6,1,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn G#5,1,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn F_6,1,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn C#6,1,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$201
 dn ___,0,$000
 dn ___,0,$201
 dn ___,0,$000
 dn ___,0,$201
 dn ___,0,$000
 dn ___,0,$201
 dn ___,0,$000
 dn ___,0,$102
 dn ___,0,$102
 dn C#6,1,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn F_5,1,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn A#5,1,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn C#6,1,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn C_6,1,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000

P5:
 dn F_5,2,$000
 dn F#5,2,$000
 dn F_5,2,$000
 dn E_5,2,$000
 dn F_5,2,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn C_5,2,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn F_4,7,$000
 dn ___,0,$E00
 dn C_5,7,$000
 dn ___,0,$E00
 dn A#4,7,$000
 dn ___,0,$E00
 dn C_5,7,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn A#4,2,$000
 dn C_5,2,$000
 dn C#5,2,$000
 dn ___,0,$000
 dn C#5,7,$000
 dn ___,0,$E00
 dn C_5,7,$000
 dn ___,0,$E00
 dn C#5,7,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn C_5,2,$000
 dn A#4,2,$000
 dn A_4,2,$000
 dn ___,0,$000
 dn F#4,7,$000
 dn ___,0,$E00
 dn F_4,7,$000
 dn ___,0,$E00
 dn C_4,7,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$B02

P6:
 dn F_5,1,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn F_5,1,$000
 dn F_5,1,$000
 dn A#6,2,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn E_6,3,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn F_5,1,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn A#6,2,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn E_6,3,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn F_5,1,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn F_5,1,$000
 dn F_5,1,$000
 dn A#6,2,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn E_6,3,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn F_5,1,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn A#6,2,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn E_6,3,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000

itNoiseSP1:
 dn ___,0,$000
 dn 51,0,$000
 dn 42,0,$000
 dn 43,0,$000
 dn 42,0,$000
 dn 41,0,$000
 dn 39,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,1,$000

itNoiseSP3:
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,1,$000

duty_instruments:
itSquareinst1:
db 8
db 0
db 240
dw 0
db 128

itSquareinst2:
db 8
db 128
db 240
dw 0
db 128



wave_instruments:
itWaveinst1:
db 0
db 32
db 0
dw 0
db 128

itWaveinst2:
db 0
db 32
db 1
dw 0
db 128

itWaveinst3:
db 0
db 32
db 2
dw 0
db 128

itWaveinst4:
db 0
db 32
db 3
dw 0
db 128

itWaveinst5:
db 0
db 32
db 4
dw 0
db 128

itWaveinst6:
db 0
db 32
db 5
dw 0
db 128

itWaveinst7:
db 0
db 32
db 6
dw 0
db 128



noise_instruments:
itNoiseinst1:
db 241
dw itNoiseSP1
db 165
ds 2

itNoiseinst2:
db 242
dw 0
db 0
ds 2

itNoiseinst3:
db 15
dw itNoiseSP3
db 175
ds 2



routines:
__hUGE_Routine_0:


__end_hUGE_Routine_0:
ret

__hUGE_Routine_1:


__end_hUGE_Routine_1:
ret

__hUGE_Routine_2:

__end_hUGE_Routine_2:
ret

__hUGE_Routine_3:

__end_hUGE_Routine_3:
ret

__hUGE_Routine_4:

__end_hUGE_Routine_4:
ret

__hUGE_Routine_5:

__end_hUGE_Routine_5:
ret

__hUGE_Routine_6:

__end_hUGE_Routine_6:
ret

__hUGE_Routine_7:

__end_hUGE_Routine_7:
ret

__hUGE_Routine_8:

__end_hUGE_Routine_8:
ret

__hUGE_Routine_9:

__end_hUGE_Routine_9:
ret

__hUGE_Routine_10:

__end_hUGE_Routine_10:
ret

__hUGE_Routine_11:

__end_hUGE_Routine_11:
ret

__hUGE_Routine_12:

__end_hUGE_Routine_12:
ret

__hUGE_Routine_13:

__end_hUGE_Routine_13:
ret

__hUGE_Routine_14:

__end_hUGE_Routine_14:
ret

__hUGE_Routine_15:

__end_hUGE_Routine_15:
ret

waves:
wave0: db 1,18,52,69,104,172,205,221,222,238,238,221,221,221,221,117
wave1: db 2,88,221,100,220,142,220,202,152,104,67,17,17,17,101,33
wave2: db 0,0,0,0,0,0,0,0,255,255,255,255,255,255,255,255
wave3: db 0,0,0,0,0,0,0,0,0,0,0,0,255,255,255,255
wave4: db 0,1,18,35,52,69,86,103,120,137,154,171,188,205,222,239
wave5: db 254,220,186,152,118,84,50,16,18,52,86,120,154,188,222,255
wave6: db 122,205,219,117,33,19,104,189,220,151,65,1,71,156,221,184

