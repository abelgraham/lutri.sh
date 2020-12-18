#!/bin/sh

source $HOME/.*profile
CACHE_DIR=${XDG_CACHE_HOME:-"$HOME/.cache"}
CACHE=$CACHE_DIR/lutrish-games.json

cols=$(tput cols)
lines=$(tput lines)

declare -i width && width=cols-20
declare -i height && height=lines-10

wc -c $CACHE |\
 grep $(lutris --list-games --installed --json |\
 jq '.[] | {name: .slug, runner: .runner}' | wc -c) ||\
 lutris --list-games --installed --json |\
 jq '.[] | {name: .slug, runner: .runner}' > $CACHE

dialog_func=${dialog_func=dialog}

game=`$dialog_func --stdout --backtitle "Lutrish" \
 --title "Games" \
 --menu "" \
 $height $width \
 $height $(cat $CACHE | jq '.[]' | tr -d '"')`

[[ -n $game ]] && nohup lutris lutris:rungame/$game > /dev/null &
sleep 1s # I need a delay for st -e. Delete this line if you don't need it!
kill $$ # This is also for my purposes, you might not need it or want it.
