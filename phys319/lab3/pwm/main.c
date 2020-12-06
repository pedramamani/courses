#include "msp430.h"

void main(void) {
    WDTCTL = WDTPW + WDTHOLD;  // stop watchdog timer

    P1DIR |= BIT2;  // set P1.2 as output
    P1SEL |= BIT2;  // set P1.2 special function to TA0.1

    // period of the signal in units 16 times the CPU period
    // CPU clock speed is 25MHz, so period of 1000 corresponds to about 1560Hz
    unsigned int period = 1000;

    CCR0 = period - 1;  // set pwm period on CCR1
    CCTL1 = OUTMOD_7;  // reset CCR1
    CCR1 = period / 2;  // set pwm duty cycle on CCR1 as half the period, to emulate a sine wave

    TACTL = TASSEL_2 + MC_1;  // set SMCLK to up mode
    _BIS_SR(LPM0_bits);  // enter low-power mode
}

