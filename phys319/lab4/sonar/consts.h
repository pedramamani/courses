#include  "msp430.h"

// Pin assignments
#define P_RXD       BIT1
#define P_TXD       BIT2
#define P_TRIG      BIT3
#define P_ECHO      BIT4

// Timing constants
#define F_CLK       8E6  // Configured clock frequency
#define T_TRIG      10E-6  // Trigger signal duration
#define T_WAIT      8E-3  // Time to wait between measurements
#define S_SOUND     342  // Calibrated to 2% accuracy for distances under a meter

// Modes
#define M_NONE      0
#define M_TRIG      1
#define M_ECHO_S    2
#define M_ECHO_E    3
#define M_WAIT      4