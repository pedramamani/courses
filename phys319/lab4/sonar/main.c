#include  "msp430.h"
#include "config.h"
#include "consts.h"

volatile unsigned int mode = M_NONE;
volatile unsigned int dur_echo;  // Echo duration
unsigned int tx_byte;  // Measured distance to communication through UART

int main(void) {
    config_clock();
    config_pins();
    config_uart();
    __enable_interrupt();

    // Main application loop
    while (1) {
        // TRIGGER
        mode = M_TRIG;  // Set to trigger mode
        P1OUT |= P_TRIG;  // Set trigger pin to high
        TACTL |= TACLR;  // Reset timer
        TACCR1 = T_TRIG * F_CLK;  // Compare for interrupt
        TACCTL1 = CCIE;  // Set to compare mode and enable interrupts
        while (mode != M_NONE);  // Wait until timer finishes

        // WAIT FOR ECHO TO GO HIGH
        mode = M_ECHO_S;
        P1IES &= ~P_ECHO;  // Interrupt on low to high transition
        P1IE = P_ECHO;  // Enable echo pin interrupt
        while (mode != M_NONE);  // Wait for echo signal start

        // WAIT FOR ECHO TO GO LOW
        mode = M_ECHO_E;
        P1IES |= P_ECHO;  // Interrupt on high to low transition
        P1IE = P_ECHO;  // Enable echo pin interrupt
        while (mode != M_NONE);  // Wait for echo signal end

        // CALCULATE AND SEND DISTANCE
        tx_byte = (unsigned char) (dur_echo / 2.0 / F_CLK * S_SOUND * 100.0);  // Calculate distance in cm
        while (!(IFG2 & UCA0TXIFG));  // Wait for TX buffer to be ready for new data
        UCA0TXBUF = tx_byte;

        // WAIT SOMETIME BEFORE NEXT MEASUREMENT
        mode = M_WAIT;  // Set to wait mode
        TACTL |= TACLR;  // Reset timer
        TACCR1 = T_WAIT * F_CLK;  // Compare for interrupt
        TACCTL1 = CCIE;  // Set to compare mode and enable interrupts
        while (mode != M_NONE);
    }

    return 0;
}


#if defined(__TI_COMPILER_VERSION__)
#pragma vector=TIMER0_A1_VECTOR
__interrupt void ta1_isr (void)
#else

void __attribute__ ((interrupt(TIMER0_A1_VECTOR))) ta1_isr(void)
#endif
{
    TACCTL1 &= ~CCIFG;  // Clear interrupt flag
    if (mode == M_TRIG) {
        P1OUT &= ~P_TRIG;  // Set trigger pin to low
        TACCTL1 &= ~CCIE;  // Disable interrupts
    }
    TACCTL1 &= ~CCIE;  // Disable interrupts
    mode = M_NONE;
}


#if defined(__TI_COMPILER_VERSION__)
#pragma vector=PORT1_VECTOR
__interrupt void port1_isr(void)
#else

void __attribute__ ((interrupt(PORT1_VECTOR))) port1_isr(void)
#endif
{
    P1IFG = 0;  // Clear interrupt flag
    if (mode == M_ECHO_S)
        TACTL |= TACLR;  // Reset timer
    else if (mode == M_ECHO_E)
        dur_echo = TAR;
    P1IE &= ~P_ECHO;  // Disable interrupts
    mode = M_NONE;
}