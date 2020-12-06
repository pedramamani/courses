#include "msp430.h"
#include "display.h"
#include "motors.h"
#include "accel.h"
#include "uart.h"
#include "consts.h"

float accel_hist[A_COUNT];
unsigned int accel_index = 0;
float accel_avg;
float accel_new;
float accel_sum;
float speed;

int main(void) {
   // configure all systems: motors, display, accelerometer, and uart
   motors_config();
   display_config();
   accel_config();
   uart_config();

   // initialize accel value rolling history
   accel_sum = 0;
   for (unsigned int i = 0; i < A_COUNT; i++) {
       accel_hist[i] = accel_read();
       accel_sum += accel_hist[i];
   }
   accel_avg = accel_sum / A_COUNT;

   while (1) {
       accel_new = accel_read();  // take new reading of accel value
       accel_sum += accel_new - accel_hist[accel_index];  // update the sum of recent accel values
       accel_hist[accel_index] = accel_new;  // update the expired accel value with the new one
       accel_index = (accel_index + 1) % A_COUNT;  // update the expired accel value index
       accel_avg = accel_sum / A_COUNT;  // calculate averaged accel value from the sum

       speed = sign(accel_avg) *
               linear_map(abs(accel_avg), M_CTRL_C1, M_CTRL_C2, 0, 1);  // calculate speed from accel value
       uart_send(speed);  // send speed value through UART
       motors_set(speed);  // set motors speed
       display_digit(linear_map(accel_avg, -1, 1, 0, 10));  // show mapped accel value on display
   }
}
