#include  "msp430.h"
#include "consts.h"

void config_clock(void) {
    WDTCTL = WDTPW + WDTHOLD;  // Disable watchdog timer
    BCSCTL1 = CALBC1_8MHZ;  // Configure clock for 8MHz frequency
    DCOCTL = CALDCO_8MHZ;
    BCSCTL2 = 0;  // Select SMCLK source as DCO with divider 1
    TACTL = TASSEL_2 | MC_2;  // Source Timer A from SMCLK with divider 1 in continuous mode
}

void config_pins(void) {
    P1DIR = P_TRIG;  // Set trigger and led pins as output and echo as input
    P1REN = P_ECHO;  // Enable resistor on echo pin
    P1OUT = 0;  // Set trigger to low and pull-down echo
    P1IE = 0;  // Disable port 1 interrupts
}

void config_uart(void) {
    P1SEL = P_RXD | P_TXD;
    P1SEL2 = P_RXD | P_TXD;
    UCA0CTL1 |= UCSSEL_2;  // Use SMCLK clock
    UCA0BR0 = 65;  // Set baud rate to 9600 with 8MHz clock (15.3.13)
    UCA0BR1 = 3;  // UCA0BR = 833 = 3 * 256 + 65
    UCA0MCTL = UCBRS1;  // Modulation UCBRSx = 2
    UCA0CTL1 &= ~UCSWRST;  // Initialize USCI state machine
}