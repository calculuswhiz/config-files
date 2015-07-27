export GTK_IM_MODULE='uim'
export QT_IM_MODULE='uim'
uim-xim &
export XMODIFIERS='@im=uim'

export EDITOR='emacs -nw'
export PATH=${PATH}:/opt/android-sdk/tools/:/opt/android-sdk/tools/
export HISTCONTROL=erasedups
export PATH=${PATH}:/sbin

if [ -d /etc/X11/xinit/xinitrc.d ]; then
        for f in /etc/X11/xinit/xinitrc.d/*; do
                [ -x "$f" ] && . "$f"
        done
        unset f
fi

session=${1:-xfce}

case $session in
    i3|i3wm           ) xset r rate 225 30; exec i3;;
    xfce|xfce4        ) xset r rate 225 30; exec startxfce4;;
    gnome|gnome-session ) xset r rate 225 30; exec gnome-session;;
    # No known session, try to run it as command
    *) exec $1;;
esac
