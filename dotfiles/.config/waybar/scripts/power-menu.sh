#!/bin/bash
options="Lock\nLogout\nReboot\nShutdown\nSuspend\nHibernate\nExit"
chosen=$(echo -e "$options" | vicinae dmenu --placeholder "Power Menu" --width 300 --height 400)

case $chosen in
  "Shutdown") systemctl poweroff ;;
  "Reboot") systemctl reboot ;;
  "Logout") niri msg action quit --skip-confirmation ;;
  "Suspend") systemctl suspend ;;
  "Hibernate") systemctl hibernate ;;
  "Lock") swaylock ;;
  "Exit") exit 0 ;;
  *) exit 1 ;;
esac
