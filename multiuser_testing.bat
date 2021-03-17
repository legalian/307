@echo off
echo This script can take a while, please wait...

echo Finding Godot.exe
pushd \
for /f "tokens=*" %%i in ('dir /b /s Godot_v3.2.3-stable_win64.exe') do set GODOT_PATH=%%i
popd

echo Starting Server instance
cd Server
START "SERVER" "%GODOT_PATH%"
cd ..

echo Waiting 5s for Server to finish launching
timeout /t 5 /nobreak

echo Starting Client instances
cd Client
START "CLIENT 1 - TOP LEFT" "%GODOT_PATH%" -MULTI_USER_TESTING=TRUE -DESIREDSCREEN=1 -ACTIVECORNER=1
START "CLIENT 2 - TOP RIGHT" "%GODOT_PATH%" -MULTI_USER_TESTING=TRUE -DESIREDSCREEN=1 -ACTIVECORNER=2
START "CLIENT 3 - BOT LEFT" "%GODOT_PATH%" -MULTI_USER_TESTING=TRUE -DESIREDSCREEN=1 -ACTIVECORNER=3
START "CLIENT 4 - BOT RIGHT" "%GODOT_PATH%" -MULTI_USER_TESTING=TRUE -DESIREDSCREEN=1 -ACTIVECORNER=4
