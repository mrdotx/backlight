#!/bin/sh

# path:       /home/klassiker/.local/share/repos/backlight/backlight.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/backlight
# date:       2020-09-12T09:48:18+0200

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

if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ -z "$2" ] || [ $# -eq 0 ]; then
    printf "%s\n" "$help"
    exit 0
else
    max=$(cat /sys/class/backlight/intel_backlight/max_brightness)
    actual=$(cat /sys/class/backlight/intel_backlight/actual_brightness)

    if [ "$2" -le 100 ] ; then
        percent=$((100 / $2))
    else
        printf "%s\n" "$help"
        exit 0
    fi
    factor=$((max / percent))
    max=$((factor * percent))

    unset value
    case "$1" in
        -inc)
            value=$((actual + factor))
            if [ $value -ge $max ]; then
                value=$max
            fi
            ;;
        -dec)
            value=$((actual - factor))
            if [ $value -le 0 ]; then
                value=0
            fi
            ;;
    esac

    # set brighness
    printf "%s" "$value" > "/sys/class/backlight/intel_backlight/brightness"
fi
