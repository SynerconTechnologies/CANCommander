# CANCommander
Scripts and Code to uses the Beaglebone Black as a dual CAN channel tool

The operating system build for the  CANCommander is documented at  https://github.com/Heavy-Vehicle-Networking-At-U-Tulsa/can-man-in-the-middle/blob/master/README.md

## Using the CANCommander
### Logging in
For Windows users, PuTTy and WinSCP are tools that enable SSH connections to the CANCommander.

There are two ways of connecting to the CANCommander using SSH:
  1. USB using RNDIS using the IP address of 192.168.7.2
  2. Ethernet connection with an IP address assigned by the DHCP server.

The default credentials are as follows: 

user: `debian` 

password: `temppwd`.

The USB connection requires the Microsoft USB RNDIS network driver to be applied to the connection. For additional details and instructions, see these instructions:  http://www.synercontechnologies.com/wp-content/uploads/2018/06/FLA-RNDIS-Driver-on-Windows-10.pdf

For direct Ethernet connections, it is recommended to log into the FLA with USB first and determine the Ethernet IP address by running `ifconfig`.  For example: 
```
debian@beaglebone:~/CANCommander$ ifconfig
can0: flags=193<UP,RUNNING,NOARP>  mtu 16
        unspec 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00  txqueuelen 10  (UNSPEC)
        RX packets 1425031  bytes 11400248 (10.8 MiB)
        RX errors 4  dropped 0  overruns 0  frame 4
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
        device interrupt 35

can1: flags=193<UP,RUNNING,NOARP>  mtu 16
        unspec 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00  txqueuelen 10  (UNSPEC)
        RX packets 1139349  bytes 9114787 (8.6 MiB)
        RX errors 4  dropped 0  overruns 0  frame 4
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
        device interrupt 36

eth0: flags=-28605<UP,BROADCAST,RUNNING,MULTICAST,DYNAMIC>  mtu 1500
        inet 192.168.1.28  netmask 255.255.255.0  broadcast 192.168.1.255
        inet6 fe80::3ad2:69ff:fe76:f0f  prefixlen 64  scopeid 0x20<link>
        ether 38:d2:69:76:0f:0f  txqueuelen 1000  (Ethernet)
        RX packets 73332  bytes 5793262 (5.5 MiB)
        RX errors 0  dropped 6354  overruns 0  frame 0
        TX packets 2339  bytes 159757 (156.0 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
        device interrupt 46

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 2384  bytes 161968 (158.1 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 2384  bytes 161968 (158.1 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

usb0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.7.2  netmask 255.255.255.252  broadcast 192.168.7.3
        inet6 fe80::3ad2:69ff:fe76:f11  prefixlen 64  scopeid 0x20<link>
        ether 38:d2:69:76:0f:11  txqueuelen 1000  (Ethernet)
        RX packets 16338  bytes 5109534 (4.8 MiB)
        RX errors 0  dropped 9  overruns 0  frame 0
        TX packets 14199  bytes 6337300 (6.0 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

usb1: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        inet 192.168.6.2  netmask 255.255.255.252  broadcast 192.168.6.3
        ether 38:d2:69:76:0f:14  txqueuelen 1000  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

```
This shows the IP address of `192.168.1.28`  on the LAN connection. The DHCP server can be set to reserve that address so the CANCommander has the same address each time. 

### Using CAN
The CANCommander comes with the can-utils installed.  https://github.com/linux-can/can-utils
A quick scan of the CAN bus with candump is shown below:
```
debian@beaglebone:~/CANCommander$ candump any
  can1  18FDC100   [8]  FF FE FF FF FF FF FF FF
  can1  18FD9F00   [8]  FF FF FF FF FF FF 00 CF
  can1  18FDAF00   [8]  1E 22 1E 22 FF FF FF FF
  can1  18FDB000   [8]  1E 22 FF FF FF FF FF FF
  can1  18FDB100   [8]  1E 22 FF FF FF FF FF FF
  can1  18FDB200   [8]  1E 22 1E 22 00 00 FF FF
  can0  08FF0001   [8]  00 00 00 00 00 00 00 00
```
These applications use the SocketCAN implementation built into the Linux Kernel. See https://github.com/torvalds/linux/blob/master/Documentation/networking/can.rst
for details.

## Using the RP1210 Device
The CAN Commander has a built in RP1210 compliant vehicle diagnostics adapter called the eDPA. The eDPA requires Windows drivers for the DPA4 Plus to be installed in order to work. These drivers can be downloaded from the DG Technologies website:  https://www.dgtech.com/downloads/.  You will have to submit your e-mail address to get a link for the download. 

The eDPA is connected to the USB port on the CAN Commander through a USB hub. This means both the eDPA and the BeagleBone are available with the USB connection. The eDPA is not available through the Ethernet port. 

DG Tech has two tools for the RP1210 device: 1) the Adapter Validation Tool and 2) DG Diagnostics. The Adapter Validation Tool helps troubleshoot driver and connectivity issues for any RP1210 diagnostics adapter. The DG Diagnositics program is a fully functional standards compliant (J1939 and J1587) diagnostics program for the DPA family of products. 

To enable the connection of the eDPA to the vehicle network, the internal CANCommander relays need to be activated to route the CAN traffic to the eDPA. This is done by pulling a GPIO pin high to drive the solenoid responsible for closing the relay. 

```
sudo nano /etc/rc.local
```
Make sure the file has these lines:
```
#!/bin/sh -e

#Ethernet LED 1
if [ ! -e /sys/class/gpio/gpio76/value ]
then
  sh -c "echo 76 > /sys/class/gpio/export"
fi
sh -c "echo out > /sys/class/gpio/gpio76/direction"
#Turn on the LED
sh -c "echo 0 > /sys/class/gpio/gpio76/value"
#Turn off the LED
sh -c "echo 1 > /sys/class/gpio/gpio76/value"

#Ethernet LED 2
if [ ! -e /sys/class/gpio/gpio77/value ]
then
  sh -c "echo 77 > /sys/class/gpio/export"
fi
sh -c "echo out > /sys/class/gpio/gpio77/direction"
#Turn on the LED
sh -c "echo 0 > /sys/class/gpio/gpio77/value"
#Turn off the LED
sh -c "echo 1 > /sys/class/gpio/gpio77/value"

# Buffer enable (Necessary for all Relays)
if [ ! -e /sys/class/gpio/gpio117/value ]
then
  sh -c "echo 117 > /sys/class/gpio/export"
fi
sh -c "echo out > /sys/class/gpio/gpio117/direction"
sh -c "echo 1 > /sys/class/gpio/gpio117/value"

#CAN Bypass Relay (Used to connect the eDPA to the Vehicle J1939)
if [ ! -e /sys/class/gpio/gpio74/value ]
then
  sh -c "echo 74 > /sys/class/gpio/export"
fi
sh -c "echo out > /sys/class/gpio/gpio74/direction"
sh -c "echo 1 > /sys/class/gpio/gpio74/value"

#J1708 Bypass Relay
if [ ! -e /sys/class/gpio/gpio75/value ]
then
  sh -c "echo 75 > /sys/class/gpio/export"
fi
sh -c "echo out > /sys/class/gpio/gpio75/direction"
sh -c "echo 1 > /sys/class/gpio/gpio75/value"

#Dual CAN switch
if [ ! -e /sys/class/gpio/gpio70/value ]
then
  sh -c "echo 70 > /sys/class/gpio/export"
fi
sh -c "echo out > /sys/class/gpio/gpio70/direction"
sh -c "echo 1 > /sys/class/gpio/gpio70/value"

ethled.sh

exit 0
```
Once this file is built, the GPIO pins are enabled after booting and the eDPA can be used as diagnostics software.

### Blinking the Ethernet LEDs
Install `inotify-tools`
```
sudo apt-get install inotify-tools
```

The  `ethled.sh`  script in this repository turns on the Ethernet Port LEDs according to the `/sys/class/net` states. The internal LEDs on the BeagleBone are not visible from the outside. It is executed at startup through the rc.local script. To ensure the script is able to run, the following commands need to be executed:
```
cd ~/CANCommander
chmod 755 ethled.sh
sudo cp ethled.sh /usr/local/bin/
```
### Other LEDs (Power and Info)
The LEDs  on the vehicle interface side are not programmed to mean anything. They are connected to a supplemental microprocessor designed to run a screen on the Forensic Link Adapter. Without the screen and the buttons, the additional microprocessor is not needed and it will light the LEDs arbitrarily during boot. Typically the LEDs will settle on red.

## CAN Forwarding
A script called `bridgeCANs.sh` uses the bridge features of can-utils.  If an error  `bridge write: No buffer space available` occurs, then  it is likely one of the CAN channels is not valid.



