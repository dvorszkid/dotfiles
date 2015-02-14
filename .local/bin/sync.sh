#!/bin/sh

if [ -z "$3" ]; then
	target="Elements#1"
else
	target="$3"
fi

keys=(
	"audio"
	"dokumentumok"
	"backup"
)
srcs=(
	"/home/d347h/Audio"
	"/home/d347h/Dokumentumok"
	"/home/d347h/Backup"
)
dsts=(
	"/run/media/d347h/$target/Audio"
	"/run/media/d347h/$target/Dokumentumok"
	"/run/media/d347h/$target/Backup"
)


function syncdir
{
	dir_src="$1"
	dir_dst="$2"

	if [ ! -d "$dir_src" ]; then
		echo "Source directory does not exist!"
		exit 1;
	fi
	if [ ! -d "$dir_dst" ]; then
		echo "Destination directory does not exist!"
		exit 1;
	fi

	last_sync_prefix="last_sync_"
	date=`date +%Y-%m-%d`
	last_sync_file="$last_sync_prefix$date"

	rm "$dir_src/$last_sync_prefix"*
	rm "$dir_dst/$last_sync_prefix"*

	touch "$dir_src/$last_sync_file"

	rsync -avz --stats --delete --progress "$dir_src/" "$dir_dst/"
}


function syncone
{
	todokey=$1
	i=0
	for key in "${keys[@]}"
	do
		if [ "$todokey" = "$key" ]; then
			echo "---------------------------------------------------------------"
			echo "--- Syncing $key..."
			if [ "$2" = "reverse" ]; then
				src_dir="${dsts[$i]}"
				dst_dir="${srcs[$i]}"
			else
				src_dir="${srcs[$i]}"
				dst_dir="${dsts[$i]}"
			fi
			echo "--- Source: $src_dir"
			echo "--- Destination: $dst_dir"
			syncdir "$src_dir" "$dst_dir"
			return 0
		fi

		i=`expr $i + 1`
	done
	echo "Cannot find key: $todokey"
}

function syncall
{
	for key in "${keys[@]}"
	do
		syncone $key
	done
}



function usage
{
	echo "-= d347h's Sync script =-"
	echo
	echo "Usage: $0 [all|one|reverse]"
	echo "  - reverse is the same as one, just the src and dst dirs are switched"
	echo "  - when using one|reverse, the second parameter can be:"

	i=0
	for key in "${keys[@]}"
	do
		echo "      - $key (src: ${srcs[$i]}, dst: ${dsts[$i]})"
		i=`expr $i + 1`
	done
	
	echo "  - if third parameter is set, that is the target (MyBook#1 for example)."
}


if [ "$1" = "all" ]; then
	syncall
else if [ "$1" = "one" ]; then
	syncone "$2"
else if [ "$1" = "reverse" ]; then
	syncone "$2" reverse
else
	usage
fi fi fi
