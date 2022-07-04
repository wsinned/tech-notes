# arch-installation

Boot from installation media into root account

Select keymap

````loadkeys uk````

Test keyboard

Double check you are in EFI mode

````ls /sys/firmware/efi/efivars````

## Connect to Wifi
````
iwctl
> device list
> station wlan0 scan
> station wlan0 get-networks
> station wlan0 connect VodafoneConnect56623681
> password:########
> exit
ping -c5 google.com
````
