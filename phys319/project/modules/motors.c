#include "msp430.h"
#include "consts.h"

signed int motors_dir;  // 1 if motors are rotating forward, -1 if backward

// configure motors and peripherals
void motors_config(void) {
   P1DIR |= P_PWM + P_FORWARD + P_BACK;  // direction control and pwm pins as output
   P1SEL |= P_PWM;  // pwm pin special function from timer A

   WDTCTL = WDTPW + WDTHOLD;  // disable watchdog timer
   BCSCTL1 = CALBC1_16MHZ;  // configure system clock at 16MHz frequency
   DCOCTL = CALDCO_16MHZ;
   BCSCTL2 = 0;  // source SMCLK from DCO

   TACTL = TASSEL_2 | MC_1;  // source timer A from SMCLK in up mode
   TACCTL1 = CCIE | OUTMOD_7;  // timer A to reset/set mode
   TACCR0 = F_SMCLK / F_PWM;  // set pwm period
   TACCR1 = 0;  // set pwm duty cycle to 0 to stop motors

   // default motors rotation direction as forward
   P1OUT |= P_FORWARD;
   P1OUT &= ~P_BACK;
   motors_dir = 1;
}

// set motors to turn at given speed/direction in arbitrary units
// speed is between -1 and 1, with positive numbers corresponding to forward rotation
void motors_set(float speed) {
   if (speed * motors_dir < 0) {  // toggle motor direction if needed
       P1OUT ^= P_FORWARD;
       P1OUT ^= P_BACK;
       motors_dir = -motors_dir;
   }
   // set pwm duty cycle based on speed
   TACCR1 = (speed == 0) ? 0 : linear_map(abs(speed), 0, 1, M_OFFSET * F_SMCLK / F_PWM, F_SMCLK / F_PWM);
}
