/*
 * PHYS319 Lab 3 Interrupt Example in C
 *
 * Written by Ryan Wicks
 * 16 Jan 2012
 *
 * This program is a C version of the assembly program that formed part of 
 * lab 2.
 */

#include <msp430.h>

void main(void) {
    WDTCTL = WDTPW + WDTHOLD;  // stop the watchdog timer
    P1DIR = 0xF7;  // set P1.3 as input, and all other P1 pins as output
    P1OUT = 0x08;  // set P1.3 to on, and all other P1 pins to off
    P1REN = 0x08;  // enable pull-up resistor on P1.3
    P1IE = 0x08;  // enable interrupt on P1.3
    _BIS_SR(LPM4_bits + GIE);  // turn on interrupt and go to low-power mode
}

// port 1 interrupt service routine
void __attribute__ ((interrupt(PORT1_VECTOR))) PORT1_ISR(void) {
    // declare an unsigned integer to signify the state of leds
    // the static identifier is used here so that 'state' is initialized only once
    // this means that 'state' preserves its value between interrupts
    static unsigned int state = 0;
    state = ~state;  // flip the state between interrupts

    if (state)
        P1OUT ^= 0x01;  // flip P1.0 to turn red led on/off
    else
        P1OUT ^= 0x41;  // flip P1.0 and P1.6 to toggle between red and green leds

    P1IFG &= ~0x08;  // clear the interrupt flag on P1
}
