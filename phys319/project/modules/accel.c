#include "msp430.h"
#include "consts.h"

// configure accelerometer and peripherals
void accel_config(void) {
   // I tried external reference voltages as mentioned, but the error on keeping voltage constant was too high
   ADC10AE0 |= P_ACCEL;  // analog input on accelerometer pin
   ADC10CTL0 =
           ADC10SHT_3 + ADC10ON + SREF_1 + REFON + ADC10SR;  // turn ADC10 on with internal 1.5 reference and 50 k*sa/s
   ADC10CTL1 = INCH_0;  // ADC10 to convert channel 0 input corresponding to the accelerometer pin
}

// analog read of accelerometer sensor along z axis
// return value is between -1 and 1 corresponding to the calibrated low and high limits
float accel_read(void) {
   ADC10CTL0 |= ENC + ADC10SC;  // start ADC10 sampling and conversion
   while (ADC10CTL1 & ADC10BUSY);  // wait until sampling and conversion is complete
   return linear_map(ADC10MEM, A_OFFSET - A_HRANGE, A_OFFSET + A_HRANGE, -1, 1);  // return mapped sensor reading
}
