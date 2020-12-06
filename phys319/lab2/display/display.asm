.include "msp430g2553.inc"

  org 0xC000
start:
  mov.w #WDTPW|WDTHOLD, &WDTCTL
  mov.b #11110111b, &P1DIR
  mov.w #0x01, r8

  ;defs #DDDDxAASb
  mov.b #10000001b, &P1OUT
  mov.b #10000000b, &P1OUT
  mov.b #10000001b, &P1OUT
  
  mov.b #00000011b, &P1OUT
  mov.b #00000010b, &P1OUT
  mov.b #00000011b, &P1OUT

  mov.b #00000101b, &P1OUT
  mov.b #00000100b, &P1OUT
  mov.b #00000101b, &P1OUT

  mov.b #00110111b, &P1OUT
  mov.b #00110110b, &P1OUT
  mov.b #00110111b, &P1OUT

  bis.w #CPUOFF, SR

org 0xfffe
  dw start             ; set reset vector to 'init' label
