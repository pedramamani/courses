//******************************************************************************
//  MSP430G2x31 Demo - ADC10, Sample A1, AVcc Ref, Set P1.0 if > 0.75*AVcc
//
//  Description: A single sample is made on A1 with reference to AVcc.
//  Software sets ADC10SC to start sample and conversion - ADC10SC
//  automatically cleared at EOC. ADC10 internal oscillator times sample (16x)
//  and conversion. 
//
//                MSP430G2x31
//             -----------------
//         /|\|              XIN|-
//          | |                 |
//          --|RST          XOUT|
//            |                 |           
//            |                 |
//            |                 |
//            |                 |
//            |                 |
// input  >---|P1.1/A1      P1.0|--> red Led onboard BIT0
//            |                 |
//            |             P1.2|--> yellow Led 
//            |             P1.6|--> green Led onboard BIT6
//
//
//  D. Dang
//  Texas Instruments Inc.
//******************************************************************************
#include "msp430.h"

void main(void) {
    WDTCTL = WDTPW + WDTHOLD;  // stop watchdog timer
    ADC10CTL0 = ADC10SHT_2 + ADC10ON;  // turn ADC10 on
    ADC10CTL1 = INCH_1;  // set ADC10 on P1
    ADC10AE0 |= 0x02;  // set ADC10 to change in response to P1.1
    P1DIR |= 0x45;  // set P1.0, P1.2, and P1.6 as output for the three leds

    while (1) {
        ADC10CTL0 |= ENC + ADC10SC;  // start sampling and conversion
        while (ADC10CTL1 & ADC10BUSY);  // wait until ADC10 sampling and conversion is complete

        if (ADC10MEM > 0x26C)  // if input voltage is high
            P1OUT = 0x01;  // set P1.0 (red led) to on, and other P1 pins to off
        else if (ADC10MEM > 0xF8)  // if input voltage is between acceptable levels
            P1OUT = 0x04;  // set P1.2 (yellow led) to on, and other P1 pins to off
        else  // if input voltage is low
            P1OUT = 0x40;  // set P1.6 (green led) to on, and other P1 pins to off

        unsigned i;
        for (i = 0xFFFF; i > 0; i--);  // delay between samplings
    }
}