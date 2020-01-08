xrdb ~/.Xresources
xsetroot -solod '#333333'
systemctl --user start xscreensaver
systemctl --user start imwheel
exec i3

