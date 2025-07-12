#!/bin/bash
xrandr --output Virtual-1 --mode 1920x1080
nitrogen --set-zoom-fill ~/Downloads/be9458ba9ca2afbc2da8ace43861685ac9c7.png
dunst &
slstatus &
#exec dwmblocks &
exec dwm
