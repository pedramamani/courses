#include "msp430.h"
#include "consts.h"

void uart_config(void) {
   P1SEL |= P_RXD + P_TXD;  // configure receive and transmit UART pins
   P1SEL2 |= P_RXD + P_TXD;
   UCA0CTL1 |= UCSSEL_2;  // use SMCLK clock
   UCA0BR0 = 131;  // set baud rate to 9600 with 16MHz clock (15.3.13)
   UCA0BR1 = 6;  // UCA0BR = 1667 = 6 * 256 + 131
   UCA0MCTL = UCBRS_6;  // modulation UCBRSx = 6
   UCA0CTL1 &= ~UCSWRST;  // initialize USCI state machine
}

// send data through UART
// data is between -1 and 1, but is mapped to an integer here and decoded on the receiving side
void uart_send(float data) {
   unsigned char tx_byte = round_(linear_map(data, -1, 1, 0, 255));  // map to an unsigned integer between 0 and 255 (one byte)
   while (!(IFG2 & UCA0TXIFG));  // wait for TX buffer to be ready for new data
   UCA0TXBUF = tx_byte;
}
