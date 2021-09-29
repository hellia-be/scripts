#!/bin/bash

. $HOME/.config/dmenu/.dmenurc

if [ -z "$TERMINAL_CMD" ]; then
	TERMINAL_CMD="terminator -e"
fi

dmenu_cmd="dmenu $DMENU_OPTIONS"
max_recent=199

cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/dmenu-recent"
recent_cache="$cache_dir"
rest_cache="$cache_dir/all"
known_types=" background terminal terminal_hold "

config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/dmenu-recent"
mkdir -p "$cache_dir"
mkdir -p "$config_dir"
touch "$recent_cache"

GREP_OPTIONS='--color=never'

IFS=:
if stest -dqr -n "$rest_cache" $PATH 2>/dev/null; then
	stest -flx $PATH | sort -u | grep -vf "$recent_cache" > "$rest_cache"
fi

IFS=" "
cmd=$(cat "$recent_cache" "$rest_cache" | $dmenu_cmd -p run: "$@") || exit

if ! grep -qx "$cmd" "$recent_cache" &> /dev/null; then
	grep -vx "$cmd" "$rest_cache" > "$rest_cache.$$"
	if -s "$rest_cache.$$"; then
		mv "$rest_cache.$$" "$rest_cache"
	else
		rm "$rest_cache.$$"
	fi
fi

if [[ ! $cmd == *[[]* ]]; then
	echo "$cmd" > "$recent_cache.$$"
	grep -vx "$cmd" "$recent_cache" | head -n "$max_recent" >> "$recent_cache.$$"
	mv "$recent_cache.$$" "$recent_cache"
fi

word0=${cmd%% *}
match="^$word0$"

get_type () {
	while type=$(echo $known_types | xargs -n1 | $dmenu_cmd -p Type:); do
		[[ $known_types =~ " $type " ]] || continue
		echo "$word0" >> "$config_dir/$type"
		break
	done
	echo $type
}

if ! type=$(grep -lx "$match" -R "$config_dir"); then
	type=$(get_type)
else
	type=${type##*/}
	if ! [[ $known_types =~ " $type " ]]; then
		rm "$config_dir/$type"
		type=$(get_type)
	fi
fi

[[ "$type" = "background" ]] && exec $cmd
[[ "$type" = "terminal" ]] && exec $TERMINAL_CMD "$cmd"
[[ "$type" = "terminal_hold" ]] && exec $TERMINAL_CMD sh -c "$cmd && echo Press Enter to kill me... && read line"
