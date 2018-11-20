# Input method:
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus
ibus-daemon -drx

xrandr --newmode "2880x1620_60.00"  396.25  2880 3096 3408 3936  1620 1623 1628 1679 -hsync +vsync
xrandr --addmode eDP-1 2880x1620_60.00
xrandr -s 2880x1620

amixer sset Master unmute
xset b off

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
        for f in /etc/X11/xinit/xinitrc.d/*.sh; do
                [ -x "$f" ] && . "$f"
        done
        unset f
fi

session=${1:-xfce}

case $session in
    i3|i3wm           ) xset r rate 225 30; exec i3;;
    xfce|xfce4        ) xset r rate 225 30; exec startxfce4;;
    gnome             ) xset r rate 225 30; exec gnome-session;;
    kde	              ) xset r rate 225 30; exec startkde;;
    # No known session, try to run it as command
    *) exec $1;;
esac
