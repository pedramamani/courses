#include "msp430.h"

void main(void) {
    WDTCTL = WDTPW + WDTHOLD;  // stop watchdog timer
    ADC10CTL0 = ADC10SHT_2 + ADC10ON;  // turn ADC10 on
    ADC10CTL1 = INCH_1;  // set ADC10 on P1
    ADC10AE0 |= 0x02;  // set ADC10 to change in response to P1.1
    P1DIR |= 0x04;  // set P1.3 as output for the led
    P1SEL |= 0x04;  // set P1.3 special function to TA0.1

    unsigned float lum = 0;  // indicates the intensity of LED in arbitrary units
    unsigned int period = 10000;  // period of the signal in units 16 times the CPU period

    while (1) {
        ADC10CTL0 |= ENC + ADC10SC;  // start sampling and conversion
        while (ADC10CTL1 & ADC10BUSY);  // wait until ADC10 sampling and conversion is complete

        lum = ADC10MEM / 1024.0;  // set as a value between 0 and 1 based on ADC10 value
        CCR0 = period - 1;  // set pwm period on CCR1
        CCTL1 = OUTMOD_7;  // reset CCR1
        CCR1 = (int) lum * period;  // set pwm duty cycle

        TACTL = TASSEL_2 + MC_1;  // set SMCLK to up mode
        _BIS_SR(LPM0_bits);  // enter low-power mode

        unsigned i;
        for (i = 0xFFFF; i > 0; i--);  // delay between samplings
    }
}
