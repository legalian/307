


acceptableTests=('party' 'lobby' 'quickplay' 'podium' 'battleroyale' 'racing' 'demoderby' 'confusingcaptcha' 'battleroyale_shim' 'racing_shim' 'demoderby_shim' 'podium_shim' 'confusingcaptcha_shim')
associatedCount=('4'     '4'     '4'         '4'      '2'            '2'      '2'         '2'                '1'                 '1'           '1'              '1',           '1')

powerups=('speed' 'missile' 'trap', 'nonpowerups')
maps=('desert' 'grassland' 'nonmap')

MAPTEST="nonmap"
POWERUPTEST="nonpowerups"

DESIREDSCREEN=1
if [[ $# == 0 ]]; then
	echo "Not enough arguments"
	echo "Usage: Multi_user_testing.sh test [desiredscreen]"
	echo "test must be one of:"
	echo "${acceptableTests[*]}"
	exit 1
fi
if ! printf '%s\n' "${acceptableTests[@]}" | grep -q "^$1$"; then
	echo "Invalid test"
	echo "Usage: Multi_user_testing.sh test [desiredscreen]"
	echo "test must be one of:"
	echo "${acceptableTests[*]}"
	exit 1
fi
if [[ $# == 4 ]]; then
	DESIREDSCREEN=$4
fi

cd Server
if [[ $# -ge 2 ]]; then
	MAPTEST=$2;
	echo $MAPTEST;
fi
if [[ $# -ge 3 ]]; then
	POWERUPTEST=$3;
	echo $POWERUPTEST
fi

MULTI_USER_TESTING=$1 DESIREDSCREEN="$DESIREDSCREEN" MAPTEST=$MAPTEST POWERUPTEST=$POWERUPTEST godot &
cd ..
sleep 2
for i in "${!acceptableTests[@]}"; do
   if [[ "${acceptableTests[$i]}" = "$1" ]]; then
       END="${associatedCount[i]}";
   fi
done
cd Client
for ((i=1;i<=END;i++)); do
    MULTI_USER_TESTING=$1 ACTIVECORNER=$i DESIREDSCREEN="$DESIREDSCREEN" godot -t &
done
