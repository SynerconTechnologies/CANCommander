#!/bin/sh -e
# Enable Ethernet LEDs on the Forensic Link Adapter Boards (rev 9F)
# to match the state of the Ethernet plug.
# run this script in the background on startup.

while true; do
if [ $(cat /sys/class/net/eth0/carrier) -eq 1 ]; then
 #Turn on the LED
 sh -c "echo 0 > /sys/class/gpio/gpio76/value"
else
 #Turn off the LED
 sh -c "echo 1 > /sys/class/gpio/gpio76/value"
fi

if cat /sys/class/net/eth0/operstate | grep -q "up"; then
 #Turn on the LED
 sh -c "echo 0 > /sys/class/gpio/gpio77/value"
else
 #Turn off the LED
 sh -c "echo 1 > /sys/class/gpio/gpio77/value"
fi


sleep .25
done
