#include "msp430.h"

// turn all segments off
void display_reset(void) {
   P1OUT &= ~BIT5;
   P2OUT &= ~(BIT0 + BIT1 + BIT2 + BIT3 + BIT4 + BIT5);
}

// configure 7-segment display
void display_config(void) {
   // segment pins as output
   P1DIR |= BIT5;
   P2DIR |= BIT0 + BIT1 + BIT2 + BIT3 + BIT4 + BIT5;
   display_reset();
}

// display a hexadecimal digit
void display_digit(unsigned int digit) {
   display_reset();

   // display hexadecimal digit between 0-F by turning on respective segments
   // default if value is outside range is a dash "-"
   switch (digit) {
       case 0:
           P2OUT |= BIT0 + BIT1 + BIT2 + BIT3 + BIT4 + BIT5;
           break;
       case 1:
           P2OUT |= BIT2 + BIT3;
           break;
       case 2:
           P1OUT |= BIT5;
           P2OUT |= BIT1 + BIT2 + BIT4 + BIT5;
           break;
       case 3:
           P1OUT |= BIT5;
           P2OUT |= BIT1 + BIT2 + BIT3 + BIT4;
           break;
       case 4:
           P1OUT |= BIT5;
           P2OUT |= BIT0 + BIT2 + BIT3;
           break;
       case 5:
           P1OUT |= BIT5;
           P2OUT |= BIT0 + BIT1 + BIT3 + BIT4;
           break;
       case 6:
           P1OUT |= BIT5;
           P2OUT |= BIT0 + BIT1 + BIT3 + BIT4 + BIT5;
           break;
       case 7:
           P2OUT |= BIT1 + BIT2 + BIT3;
           break;
       case 8:
           P1OUT |= BIT5;
           P2OUT |= BIT0 + BIT1 + BIT2 + BIT3 + BIT4 + BIT5;
           break;
       case 9:
           P1OUT |= BIT5;
           P2OUT |= BIT0 + BIT1 + BIT2 + BIT3 + BIT4;
           break;
       case 10:  // A
           P1OUT |= BIT5;
           P2OUT |= BIT0 + BIT1 + BIT2 + BIT3 + BIT5;
           break;
       case 11:  // b
           P1OUT |= BIT5;
           P2OUT |= BIT0 + BIT3 + BIT4 + BIT5;
           break;
       case 12:  // C
           P2OUT |= BIT0 + BIT1 + BIT4 + BIT5;
           break;
       case 13:  // d
           P1OUT |= BIT5;
           P2OUT |= BIT2 + BIT3 + BIT4 + BIT5;
           break;
       case 14:  // E
           P1OUT |= BIT5;
           P2OUT |= BIT0 + BIT1 + BIT4 + BIT5;
           break;
       case 15:  // F
           P1OUT |= BIT5;
           P2OUT |= BIT0 + BIT1 + BIT5;
           break;
       default:  // -
           P1OUT |= BIT5;
   }
}
