#!/bin/sh

BASEDIR=$(cd "$(dirname "$0")"; pwd)
CONVERT=$BASEDIR/bin/convert.pe
SFDDIR=$BASEDIR/sfd
DESTDIR=$BASEDIR/dest

# Reference:
#   https://github.com/maxtsepkov/bash_colors/blob/master/bash_colors.sh
function clr_escape
{
    local result="$1"
    until [ -z "$2" ]; do
    if ! [ $2 -ge 0 -a $2 -le 47 ] 2>/dev/null; then
        echo "clr_escape: argument \"$2\" is out of range" >&2 && return 1
    fi
        result="\033[${2}m${result}\033[0m"
    shift || break
    done

    echo -ne "$result"
}


# main
mkdir -p $DESTDIR

for i in $(ls $SFDDIR); do
    printf "converting %-20s" $i
    $CONVERT "$SFDDIR/$i" "$DESTDIR/${i%.sfd}.ttf" > $BASEDIR/build.log 2>&1
    if [ $? -eq 0 ]; then
        clr_escape "done" 32
    else
        clr_escape "failed" 31
    fi
    echo
done
