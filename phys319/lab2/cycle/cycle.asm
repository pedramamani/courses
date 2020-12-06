#include "msp430g2553.inc"
org 0x0C000

RESET:
mov.w #0x400, sp
mov.w #WDTPW|WDTHOLD,&WDTCTL
mov.b #11110111b, &P1DIR
mov.b #01001001b, &P1OUT
mov.b #00001000b, &P1REN
mov.b #00001000b, &P1IE
mov.w #00001000b, R7
mov.b R7, &P1OUT
EINT
bis.w #CPUOFF,SR

PUSH:
bic.b #00001000b, &P1IFG
add.w #1, R7
and.w #11b, R7

cmp.w #00b, R7
jeq NONE
cmp.w #01b, R7
jeq RED
cmp.w #10b, R7
jeq GREEN
cmp.w #11b, R7
jeq BOTH


NONE:
mov.b #00001000b, &P1OUT
reti

BOTH:
mov.b #01001001b, &P1OUT
reti

RED:
mov.b #00001001b, &P1OUT
reti

GREEN:
mov.b #01001000b, &P1OUT
reti


org 0xffe4
dw PUSH
org 0xfffe
dw RESET
