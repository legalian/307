

acceptableTests=('party' 'lobby' 'quickplay' 'podium' 'battleroyale' 'racing' 'demoderby' 'battleroyale_shim' 'racing_shim' 'demoderby_shim')
associatedCount=('4'     '4'     '4'         '4'      '3'            '3'      '3'         '1'                 '1'           '1'             )

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
if [[ $# == 2 ]]; then
	DESIREDSCREEN=$2
fi

cd Server
MULTI_USER_TESTING=$1 DESIREDSCREEN="$DESIREDSCREEN" /Applications/Godot.app/Contents/MacOS/Godot -t &
cd ..
sleep 2
for i in "${!acceptableTests[@]}"; do
   if [[ "${acceptableTests[$i]}" = "$1" ]]; then
       END="${associatedCount[i]}";
   fi
done
cd Client
for ((i=1;i<=END;i++)); do
    MULTI_USER_TESTING=$1 ACTIVECORNER=$i DESIREDSCREEN="$DESIREDSCREEN" /Applications/Godot.app/Contents/MacOS/Godot -t &
done
