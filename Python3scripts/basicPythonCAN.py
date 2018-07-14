#!/bin/env python3
import can

bus = can.interface.Bus(bustype='socketcan', channel='can1', bitrate=250000)
try:
    while True:
        message = bus.recv()
        candata_string = " ".join(["{:02X}".format(b) for b in message.data])
        print("{:08X} {}".format(message.arbitration_id, candata_string))
except KeyboardInterrupt:
    bus.shutdown()
    print("Finished.")