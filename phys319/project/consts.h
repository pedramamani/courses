#ifndef CONSTS
#define CONSTS

// MATH FUNCTION FUNCTIONS AND MACROS
#define abs(x)      (((x) < 0) ? -(x) : (x))
#define sign(x)      (((x) < 0) ? -1 : 1)
#define max(a, b)   (((a) > (b)) ? (a) : (b))
#define min(a, b)   (((a) < (b)) ? (a) : (b))

int round_(float value);

float linear_map(float value, float lower_i, float upper_i, float lower_f, float upper_f);

// PIN ASSIGNMENTS
#define P_ACCEL     BIT0
#define P_RXD       BIT1
#define P_TXD       BIT2
#define P_FORWARD   BIT3
#define P_BACK      BIT4
#define P_PWM       BIT6

// FREQUENCY SETTINGS
#define F_SMCLK     16E6  // SMCLK frequency
#define F_PWM       5000  // PWM frequency

// MOTORS CALIBRATION
#define M_OFFSET    0.58
#define M_CTRL_C1   0.12  // control function constant 1, speed is 0 up to this value of accel
#define M_CTRL_C2   0.70  // control function constant 2, speed is 1 past this value of accel

// ACCELEROMETER CALIBRATION
// ADC10 value of A_OFFSET + A_HRANGE corresponds to returned reading of 1
// ADC10 value of A_OFFSET - A_HRANGE corresponds to returned reading of -1
#define A_OFFSET    875  // nominal accelerometer reading
#define A_HRANGE    140  // accelerometer reading half-range
#define A_COUNT     10  // number of recent accel readings to average

#endif
