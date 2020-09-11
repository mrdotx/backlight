#!/bin/sh

# path:       /home/klassiker/.local/share/repos/backlight/backlight.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/backlight
# date:       2020-09-11T19:27:20+0200

script=$(basename "$0")
help="$script [-h/--help] -- script to change intel backlight
  Usage:
    $script [-inc/-dec] [percent]

  Settings:
    [-inc]    = increase in percent (0-100%)
    [-dec]    = decrease in percent (0-100%)
    [percent] = how much percent to increase/decrease the brightness

  Examples:
    $script -inc 10
    $script -dec 10"

if [ ! "$(id -u)" = 0 ]; then
   printf "this script needs root privileges to run\n"
   exit 1
fi

option=$1
percent=$2

if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ -z "$2" ] || [ $# -eq 0 ]; then
    printf "%s\n" "$help"
    exit 0
else
    max=$(cat /sys/class/backlight/intel_backlight/max_brightness)
    actual=$(cat /sys/class/backlight/intel_backlight/actual_brightness)

    if [ "$percent" -le 100 ] ; then
        percent=$((100 / percent))
    else
        printf "%s\n" "$help"
        exit 0
    fi
    factor=$((max / percent))
    max=$((factor * percent))

    unset new
    if [ "$option" = "-inc" ]; then
        new=$((actual + factor))
        if [ $new -ge $max ]; then
            new=$max
        fi
    elif [ "$option" = "-dec" ]; then
        new=$((actual - factor))
        if [ $new -le 0 ]; then
            new=0
        fi
    fi

    # set brighness
    printf "%s" "$new" > "/sys/class/backlight/intel_backlight/brightness"
fi
