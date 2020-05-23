#!/bin/sh

CACHE_DIR=${XDG_CACHE_HOME:-"$HOME/.cache"}
CACHE=$CACHE_DIR/lutrish-games.json

cols=$(tput lines)
lines=$(tput cols)

declare -i width && width=lines-20
declare -i height && height=cols-10

wc -c $CACHE | grep $(lutris --list-games --installed --json | jq '.[] | {name: .slug, runner: .runner}' | wc -c) || lutris --list-games --installed --json | jq '.[] | {name: .slug, runner: .runner}' > $CACHE 

dialog_func = ${dialog_func=dialog}

game=`$dialog_func --stdout --backtitle "Lutrish" \
 --title "Games" \
 --menu "" \
 $height $width \
 $height $(cat $CACHE | jq '.[]' | tr -d '"')`

[[ -n $game ]] && lutris lutris:rungame/$game
 
