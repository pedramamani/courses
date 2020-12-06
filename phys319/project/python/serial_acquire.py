import serial  # for serial communication
from time import time  # for timing data_assets acquisition

PORT = 'COM5'  # define serial port
X_LABEL = 'Time [s]'
Y_LABEL = 'Accelerometer Reading [a.u.]'
DATA_FILE = 'data_assets.txt'

try:
    ser = serial.Serial(PORT, baudrate=9600, timeout=0.050)  # open serial port, wait up to 50ms for data_assets
except serial.SerialException:
    print("opening serial port %s failed!\npress any key to exit..." % PORT)
    input()
    quit()

data_file = open(DATA_FILE, 'w')  # open a data_assets file for the output
data_file.write("%s\t%s\n" % (X_LABEL, Y_LABEL))
start_time = time()

while True:  # loop forever
    data = ser.read(1)  # look for a one-byte character from serial port

    if len(data) > 0:  # if read a byte
        value = ord(data) / 255 * 2 - 1
        data_file.write("%.2f\t%.3f\n" % (time() - start_time, value))  # write to file
        print("%.3f" % value)  # print the decoded float value
