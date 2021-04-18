extends "res://GameBase.gd"
func systemname():
	return "ConfusingCaptcha"

var CCPlayer = preload("res://ConfusingCaptcha/CC_Player.tscn")
	
var status = {}
var lives = {}
var ingame = {}
var curRound = 0
var totalRounds = 5;
var roundTime = null;
var maxRoundTime = 30;
var questionIndex = 0;
var total_questions = 7;
var startLives = 3;
var tileCorrespondance = ["R1C1", "R1C2", "R1C3","R2C1", "R2C2", "R2C3", "R3C1", "R3C2", "R3C3"]
var correctTile = tileCorrespondance[0]
var questions = [4,5,6,0,1,2,3]

var arrangement = [0,1,2,3,4,5,6,7,8]

var mapSelect = "nonmap";

const MAPS = ["Grass"]

var map = "Grass"
var world = null
var mapRoll;

var debug_id = 1010101010

func shuffleList(list):
	var shuffledList = [] 
	var indexList = range(list.size())
	for i in range(list.size()):
		var x = randi()%indexList.size()
		shuffledList.append(list[indexList[x]])
		indexList.remove(x)
	return shuffledList;



func _ready():
	randomize()
	world = preload("res://ConfusingCaptcha/World-Grass.tscn").instance()
	assert(world != null)
	add_child(world)
	var _timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "_send_rpc_update")
	_timer.set_wait_time(0.1)#10 rpc updates per second
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()
	if "confusingcaptcha_shim" == OS.get_environment("MULTI_USER_TESTING"):
		spawn_id(0,0,debug_id);

		
	var roundTimer = Timer.new();
	add_child(roundTimer);
	roundTimer.connect("timeout", self, "timeTick");
	roundTimer.set_wait_time(1);
	roundTimer.set_one_shot(false)
	roundTimer.start();
	if(OS.get_environment("CAPTCHAROUTINE") == "randomized"):
		questions = shuffleList(questions)


func timeTick():
	if(roundTime != null):
		roundTime = roundTime - 1;
		if(roundTime == 0):
			processEndedRound();
	else:
		roundTime = maxRoundTime
		startRound()

func nextRound():
	curRound = curRound + 1
	startRound()

func startRound():
	#start timer again, change images, etc. 
	roundTime = maxRoundTime
	randomize()
	questionIndex = questions[curRound]
	arrangement = shuffleList(arrangement)
	for p in players:
		if(p.dummy == 0):
			#rpc_unreliable_id(p.playerID,"frameUpdate",player_frame,bullet_frame,powerup_frame)
			rpc_id(p.playerID,"questionText",questionIndex,arrangement)
			rpc_id(p.playerID, "startNextRound");
			rpc_id(p.playerID, "setLives", lives[p.playerID]);
	for i in range(0, arrangement.size()):
		if arrangement[i] == 0:
			correctTile = tileCorrespondance[i];

func endRound():
	print("Ended Round!")
	for player in ingame.values():
		var ofs = player.position-$World/LowerLeft.position
		var dis = $World/UpperRight.position-$World/LowerLeft.position
		var choice = floor(ofs.x/(dis.x/3))+3*floor(ofs.y/(dis.y/3))
		if arrangement[choice]!=0:
			decreaseHealth(player)
	nextRound()

func decreaseHealth(player):
	print("Decreasing health of " + str(player.id));
	lives[player.id] = lives[player.id] - 1;
	if(lives[player.id] == 0):
		_on_die(player);
		print("Player " + str(player.id) + " dies!");

func processEndedRound():

	for p in players:
		if p.dummy == 0:
			rpc_id(p.playerID, "endRound", correctTile)
	var endRoundTimer = Timer.new();
	endRoundTimer.connect("timeout", self, "endRound")
	endRoundTimer.one_shot = true;
	add_child(endRoundTimer);
	endRoundTimer.start(5.0)
	


func add_player(newplayer):
	.add_player(newplayer)
	status[newplayer.playerID] = "UNSPAWNED"
	print("adding player: ",newplayer)
	spawn_id(0,0, newplayer.playerID);

	#rpc_id(newplayer.playerID, "setMap", map)
	#rpc_id(newplayer.playerID, "setMapRoll", mapRoll)
func remove_player(player_id):
	.remove_player(player_id)
	status.erase(player_id)
	if ingame.has(player_id):
		$World.remove_child(ingame[player_id])
		ingame[player_id].queue_free()
		ingame.erase(player_id)



func _send_rpc_update():
	var player_frame = []
	for gg in ingame.values(): player_frame.append(gg.pack())
	#var bullet_frame = []
	#for gg in bullets.values(): bullet_frame.append(gg.pack())
	#var powerup_frame = []
		
	for p in players:
		if(p.dummy == 0):
			#rpc_unreliable_id(p.playerID,"frameUpdate",player_frame,bullet_frame,powerup_frame)
			rpc_unreliable_id(p.playerID,"frameUpdate", player_frame,maxRoundTime if roundTime==null else roundTime);

func spawn_id(x,y,player_id):
	if (status.has(player_id)):
		if status[player_id] != "UNSPAWNED": return
	status[player_id] = "INGAME"
	
	print("Spawning player!");
	ingame[player_id] = CCPlayer.instance()
	ingame[player_id].id = player_id
	ingame[player_id].position = Vector2(x,y)
	lives[player_id] = startLives;
	
	world.add_child(ingame[player_id])
	
remote func spawn(x,y):
	print("spawn called")
	var player_id = get_tree().get_rpc_sender_id()
	spawn_id(x,y,player_id)
	
remote func syncUpdate(package):
	var player_id = get_tree().get_rpc_sender_id()
	if (ingame.has(player_id)):
		ingame[player_id].unpack(package)

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














