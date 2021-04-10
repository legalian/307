extends "res://GameBase.gd"
func systemname():
	return "ConfusingCaptcha"
	
var CCPlayer = preload("res://ConfusingCaptcha/CC_Player.tscn")
	
var status = {}
var ingame = {}
var curRound = 1
var totalRounds = 5
var roundTime
var maxRoundTime = 20;

#var bullets = {}
var selected = {}
enum selectedSquares {11,21,31,12,22,32,13,23,33,NONE}
#format is column, row.  21 = 2nd row 1st column. NONE represents not currently being in any column. 

var mapSelect = "nonmap";

const MAPS = ["Grass"]

var map = "Grass"
var world = null
var mapRoll;

var debug_id = 1010101010

func nextRound():
	curRound++
	startRound();

func startRound():
	#start timer again, change images, etc. 
	roundTime = maxRoundTime
func endRound():
	pass;
	#eliminate players who are on wrong selection, end game/crown winner if someone is left. 

func updateSelected(playerID):
	#use position? or something to calculate which square they should be in within this function
	selected[playerID] = selectedSquares.11;

func add_player(newplayer):
	.add_player(newplayer)
	status[newplayer.playerID] = "UNSPAWNED"
	selected[newplayer.playerID] = selectedSquares.NONE
	print("adding player: ",newplayer)
	rpc_id(newplayer.playerID, "setMap", map)
	#rpc_id(newplayer.playerID, "setMapRoll", mapRoll)
func remove_player(player_id):
	.remove_player(player_id)
	status.erase(player_id)
	if ingame.has(player_id):
		$World.remove_child(ingame[player_id])
		ingame[player_id].queue_free()
		ingame.erase(player_id)

func timeTick():
	roundTime--;
	if(roundTime == 0):
		endRound();

func _ready():
	world = preload("res://ConfusingCaptcha/World-Grass.tscn").instance()
	assert(world != null)
	add_child(world)

	var roundTimer = Timer.new();
	add_child(roundTimer);
	roundTimer.connect("timeout", self, "timeTick");
	roundTimer.set_wait_time(1);
	roundTimer.set_one_shot(false)
	roundTimer.start();

	var _timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "_send_rpc_update")
	_timer.set_wait_time(0.1)#10 rpc updates per second
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()
	if "confusingcaptcha_shim" == OS.get_environment("MULTI_USER_TESTING"):
		spawn_id(0,0,debug_id);
	
func _send_rpc_update():
	var player_frame = []
	for gg in ingame.values(): player_frame.append(gg.pack())
	#var bullet_frame = []
	#for gg in bullets.values(): bullet_frame.append(gg.pack())
	#var powerup_frame = []
		
	for p in players:
		if(p.dummy == 0):
			#rpc_unreliable_id(p.playerID,"frameUpdate",player_frame,bullet_frame,powerup_frame)
			rpc_unreliable_id(p.playerID,"frameUpdate",player_frame, roundTime);

func spawn_id(x,y,player_id):
	if (status.has(player_id)):
		if status[player_id] != "UNSPAWNED": return
	status[player_id] = "INGAME"
	
	print("Spawning player!");
	ingame[player_id] = CCPlayer.instance()
	ingame[player_id].id = player_id
	ingame[player_id].position = Vector2(x,y)
	updateSelected(player_id);
	
	world.add_child(ingame[player_id])
	
remote func spawn(x,y):
	print("spawn called")
	var player_id = get_tree().get_rpc_sender_id()
	spawn_id(x,y,player_id)
	
remote func syncUpdate(package):
	var player_id = get_tree().get_rpc_sender_id()
	if (ingame.has(player_id)):
		ingame[player_id].unpack(package)
		updateSelected(player_id);

func _on_die(player):
	for oplayer in players: 
		if oplayer.playerID == player.id:
			oplayer.score += players.size()-ingame.size()
		if oplayer.playerID==debug_id: continue
		rpc_id(oplayer.playerID,"die",player.pack())
	status[player.id] = "DEAD"
	$World.remove_child(ingame[player.id])
	ingame[player.id].queue_free()
	ingame.erase(player.id)
	if ingame.size()==1:
		for remaining_player in ingame:
			crown_winner(remaining_player)
			break

func crown_winner(playerID):
	for oplayer in players: 
		if oplayer.playerID == playerID:
			oplayer.score += players.size()-ingame.size()
		if oplayer.playerID==debug_id: continue
		rpc_id(oplayer.playerID,"win",playerID)
	syncScores()
	print("WINNER CROWNED! GO TO NEXT MINIGAME")
	get_parent().go_to_next_minigame(playerID)














