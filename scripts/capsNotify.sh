# A caps-lock indicator for xfce4.
# Shows the state of the caps-lock keyboard LED as a notification. I personally bound it to my caps-lock key.

# Wait to read it accurately when caps-lock is pressed.
sleep .2s

if [[ $(xset q | grep -P LED.* -o | grep -P '(?<=[01]{7})[01]' -o) == 1 ]]; then
	notify-send "Caps lock is on"
else
	notify-send "Caps lock is off"
fi
