import serial  # for serial communication
import numpy as np  # for arrays, numerical processing
import matplotlib.pyplot as plt  # for plotting

PORT = 'COM5'  # define serial port
DATA_COUNT = 100  # number of recent data_assets points to keep
X_LABEL = 'Count [#]'
Y_LABEL = 'Accelerometer Reading [a.u.]'
Y_LIMITS = -1.05, 1.05  # y-axis range
WIN_SIZE = 8, 4  # window size
WIN_TITLE = 'Accelerometer Readings'  # window title

try:
    ser = serial.Serial(PORT, baudrate=9600, timeout=0.050)  # open serial port, wait up to 50ms for data_assets
except serial.SerialException:
    print('opening serial port %s failed!\npress any key to exit...' % PORT)
    input()
    quit()

vals = np.zeros(DATA_COUNT)  # create empty data_assets list
plt.ion()  # interactive plotting on, to allow for updating plot real-time
fig = plt.figure(WIN_TITLE, figsize=WIN_SIZE)
ax = fig.add_subplot()
ax.set_ylim(Y_LIMITS)  # set subplot y axis limits
ax.set_title(WIN_TITLE)  # set subplot title
ax.set_ylabel(Y_LABEL)
ax.set_xlabel(X_LABEL)
lines = ax.plot_raw(vals)

while True:  # loop forever
    data = ser.read(1)  # look for a one-byte character from serial port
    ser.reset_input_buffer()  # discard of all data_assets in input buffer

    if len(data) > 0:  # if read a byte
        vals = np.roll(vals, -1)  # shift the values in list
        vals[DATA_COUNT - 1] = round(ord(data) / 255 * 2 - 1, 3)  # take the decoded float value

        lines.pop(0).remove()
        lines = ax.plot_raw(vals, 'b')  # plot new data_assets

        if plt.waitforbuttonpress(0.001):  # wait between frames for key press
            plt.close()  # close plot window
            ser.close()  # close serial port
            quit()
