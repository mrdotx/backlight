#!/bin/sh

# path:       /home/klassiker/.local/share/repos/backlight/backlight.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/backlight
# date:       2020-09-12T15:43:02+0200

script=$(basename "$0")
help="$script [-h/--help] -- script to change intel backlight
  Usage:
    $script [-inc/-dec] [percent]

  Settings:
    [-inc]    = increase in percent (0-100)
    [-dec]    = decrease in percent (0-100)
    [percent] = how much percent to increase/decrease the brightness

  Examples:
    $script -inc 10
    $script -dec 10"

permissions() {
    if [ ! "$(id -u)" = 0 ]; then
       printf "this option needs root privileges to run\n"
       exit 1
    fi
}

brightness() {
    if [ "$1" -le 100 ]; then
        max=$(cat /sys/class/backlight/intel_backlight/max_brightness)
        actual=$(cat /sys/class/backlight/intel_backlight/actual_brightness)

        percent=$((100 / $1))
        factor=$((max / percent))
        max=$((factor * percent))
    else
        printf "%s\n" "$help"
        exit 1
    fi
}

case "$1" in
    -h | --help)
        printf "%s\n" "$help"
        exit 0
        ;;
    -inc)
        permissions
        brightness "$2"
        value=$((actual + factor))
        if [ $value -ge $max ]; then
            value=$max
        fi
        ;;
    -dec)
        permission
        brightness "$2"
        value=$((actual - factor))
        if [ $value -le 0 ]; then
            value=0
        fi
        ;;
    *)
        printf "%s\n" "$help"
        exit 1
        ;;
esac

# set brighness
printf "%s" "$value" > "/sys/class/backlight/intel_backlight/brightness"
