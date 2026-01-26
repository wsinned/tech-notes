#!/bin/bash
options="a. Lock\nb. Logout\nc. Reboot\nd. Shutdown\ne. Suspend\nf. Hibernate\nExit"
chosen=$(echo -e "$options" | wofi --dmenu --prompt "Power Menu" --width 300 --height 234)

case $chosen in
  "d. Shutdown") systemctl poweroff ;;
  "c. Reboot") systemctl reboot ;;
  "b. Logout") niri msg action quit --skip-confirmation ;;
  "e. Suspend") systemctl suspend ;;
  "f. Hibernate") systemctl hibernate ;;
  "a. Lock") swaylock ;;
  "Exit") exit 0 ;;
  *) exit 1 ;;
esac

