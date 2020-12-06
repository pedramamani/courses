/*
 * PHYS319 Lab3 Timing example in C
 *
 * Written by Ryan Wicks
 * 16 January 2012
 *
 * This program is a C version of the assembly program that formed part of lab 2.
 * This is not the best way to implement timing, or to organize your code. 
 * It is simply one way.
 *
 * This will almost certainly not give exactly the same timing as the assembly
 * program from lab 2, and the output assembly will also be very different, even
 * though the task is similar.
 */

#include <msp430.h>

void main(void) {
    // declare the two variables as before
    volatile unsigned int count1;
    volatile unsigned int count2;
    // notice the label volatile. What happens if you remove this label?
    WDTCTL = WDTPW + WDTHOLD;     //Stop WDT
    P1DIR = 0x41;            //Set P1 output direction
    P1OUT = 0x01;            //Set the output

    while (1) {  // continuous looping
        // now inside the continuous loop
        count2 = 2;  // to increase blinking interval by a factor of two
        while (count2 != 0) {  // decrement until 'count2' is zero
            count2--;
            count1 = 60000;
            while (count1 != 0)  // decrement until 'count1' is zero
                count1--;
        }
        P1OUT = P1OUT ^ 0x41;    //bitwise xor the output with 0x41
    }
}
