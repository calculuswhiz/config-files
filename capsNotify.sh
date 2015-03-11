sleep .2s

if [[ $(xset q | grep -P LED.* -o | grep -P '(?<=[01]{7})[01]' -o) == 1 ]]; then
	notify-send "Caps lock is on"
else
	notify-send "Caps lock is off"
fi
