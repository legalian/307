acceptableTests=('party' 'lobby' 'quickplay' 'podium' 'battleroyale' 'racing' 'demoderby' 'confusingcaptcha' 'battleroyale_shim' 'racing_shim' 'demoderby_shim' 'podium_shim' 'confusingcaptcha_shim')
associatedCount=('4'     '4'     '4'         '4'      '2'            '2'      '2'         '2'									'1'                 '1'           '1'              '1'          '1')

powerups=('speed' 'missile' 'trap', 'nonpowerups')
maps=('desert' 'grassland' 'nonmap')

MAPTEST="nonmap"
POWERUPTEST="nonpowerups"

DESIREDSCREEN=1

print_usage () {
	echo "Usage: Multi_user_testing.sh test [desiredmap] [desiredpowerup] [desiredscreen]"
	echo "test must be one of:"
	echo "	${acceptableTests[*]}"
	echo "desiredmap must be one of:"
	echo "	${maps[*]}"
	echo "desiredpowerup must be one of:"
	echo "	${powerups[*]}"
	exit 1
}

if [[ $# == 0 ]]; then
	echo "Not enough arguments"
	print_usage
fi
if [[ $# -ge 2 ]]; then
	MAPTEST=$2
fi
if [[ $# -ge 3 ]]; then
	POWERUPTEST=$3
fi
if [[ $# == 4 ]]; then
	DESIREDSCREEN=$4
fi
if ! printf '%s\n' "${acceptableTests[@]}" | grep -q "^$1$"; then
	echo "Invalid test"
	print_usage
fi
if ! printf '%s\n' "${maps[@]}" | grep -q "^$MAPTEST$"; then
	echo "Invalid map"
	print_usage
fi
if ! printf '%s\n' "${powerups[@]}" | grep -q "^$POWERUPTEST$"; then
	echo "Invalid powerup"
	print_usage
fi

if [[ -f /Applications/Godot.app/Contents/MacOS/Godot ]]
then
	gdpath="/Applications/Godot.app/Contents/MacOS/Godot"
else
	gdpath="godot"
fi


cd Server
MULTI_USER_TESTING=$1 DESIREDSCREEN="$DESIREDSCREEN" POWERUPTEST=$POWERUPTEST MAPTEST=$MAPTEST $gdpath &
cd ..
sleep 2
for i in "${!acceptableTests[@]}"; do
   if [[ "${acceptableTests[$i]}" = "$1" ]]; then
       END="${associatedCount[i]}";
   fi
done
cd Client
for ((i=1;i<=END;i++)); do
    MULTI_USER_TESTING=$1 ACTIVECORNER=$i DESIREDSCREEN="$DESIREDSCREEN" $gdpath -t &
done
