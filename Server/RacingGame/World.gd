extends "res://GameBase.gd"
func systemname():
	return "RacingGame"

var car = preload("res://RacingGame/racingCar.tscn")

var spawn_positions = []

var started = false
var race_finished = false

var ingame = {}
var powerups = {}

var mapSelect = "nonmap";

var round_limit = 120; # 120s will forcibly end the round

var force_finish = false;
var mapRoll;

const MAPS = ["Grass", "Desert", "Candy"]

var map = null
var world = null

func sort_places(a, b):
	if is_equal_approx(a[1], b[1]):
		if a[2] < b[2]:
			return true
	elif a[1] > b[1]:
		return true
	else:
		return false

func add_player(newplayer):
	.add_player(newplayer)
	spawn(newplayer.playerID)

func notifystrike(fireplayer,struckplayer):
	rpc_id(fireplayer,"notifystrike",struckplayer)

func remove_player(player_id):
	.remove_player(player_id)

func _ready():
	randomize()
	var rng = RandomNumberGenerator.new();
	rng.randomize();
	if(OS.has_environment("MAPTEST")):
		mapSelect = OS.get_environment("MAPTEST");
		print("MAPSELECT = " + mapSelect)
	if(mapSelect != "nonmap"):
		if(mapSelect == "grassland"):
			mapRoll = 420
			map = MAPS[0];
		elif(mapSelect == "desert"):
			mapRoll = 660
			map = MAPS[1];
		elif(mapSelect == "candy"):
			mapRoll = 540
			map = MAPS[2]
	else:
		print("NO MAP SELECTED\n");
		mapRoll = rng.randi_range(360, 3600);
		if(mapRoll % 360  <= 120):
			map = MAPS[0]
		elif(mapRoll %360 <= 240):
			map = MAPS[2];
		else:
			map = MAPS[1]

	if map == "Grass":
		world = preload("res://RacingGame/World-Grass.tscn").instance()
	elif map == "Desert":
		world = preload("res://RacingGame/World-Desert.tscn").instance()
	else:
		world = preload("res://RacingGame/World-Candy.tscn").instance()
	assert(world != null)
	add_child(world)
	
	for node in world.get_children():
		if node.name.begins_with("Powerup"):
			powerups[node.name] = node

	if (map != "Candy"):
		for x in range(1400, 1800, 200):
			for y in range(1400, 2500, 110):
				spawn_positions.append(Vector2(x,y))
	elif (map == "Candy"):
		for x in range(9728, 10496, 200):
			for y in range(256, 856, 110):
				spawn_positions.append(Vector2(x,y))
	
	spawn_positions.shuffle()
	
	var _timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "_send_rpc_update")
	_timer.set_wait_time(0.02)#50 rpc updates per second
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()
	
	var _countdown = Timer.new()
	add_child(_countdown)
	_countdown.connect("timeout", self, "_countdown_end")
	_countdown.set_wait_time(8.5)
	_countdown.set_one_shot(true)
	_countdown.start()
	
	var _round_limit = Timer.new()
	add_child(_round_limit)
	_round_limit.connect("timeout", self, "_finish_game")
	_round_limit.set_wait_time(round_limit)
	_round_limit.set_one_shot(false)
	#_round_limit.start()

func _finish_game():
	print("force_finish set to true")
	force_finish = true

func _countdown_end():
	started = true
	for ig in ingame.values():
		ig.set_physics_process(true)
	
func _send_rpc_update():
	var player_frame = []
	var powerup_frame = []
	for gg in ingame.values():
		player_frame.append(gg.pack())
	for pp in powerups.values():
		powerup_frame.append(pp.pack())
	
	var projectile_frame = []
	var trap_frame = [];
	for node in $World.get_children():
		if (node.name.begins_with("Projectile")):
			projectile_frame.append(node.pack())
		if(node.name.begins_with("Trap")):
			trap_frame.append(node.pack());
			
	
	
	for p in players:
		if(p.dummy == 0):
			rpc_unreliable_id(p.playerID,"frameUpdate",
							  player_frame,
							  powerup_frame,
							  projectile_frame,
							  trap_frame)


func _process(delta):
	var sort_array = []
	var done = true
	if ingame.size() == 0: return
	for ig in ingame.values():
		if ig.finished == false:
			done = false
		sort_array.append([ig.id, ig.progress, ig.finish_time])
	sort_array.sort_custom(self, "sort_places")
	for n in range(sort_array.size()):
		ingame[sort_array[n][0]].place = n + 1
		
	if ((done && !race_finished) || (force_finish)):
		print("Everyone finished the race!")
		race_finished = true
		
		for p in players:
			p.score += sort_array.size()-ingame[p.playerID].place
			rpc_id(p.playerID, "endMatch")
			
		syncScores()
		
		var end_match = Timer.new()
		add_child(end_match)
		end_match.connect("timeout", get_parent(), "go_to_next_minigame", [players[0].playerID])
		end_match.set_wait_time(5)
		end_match.set_one_shot(true)
		end_match.start()


func spawn(player_id):
	print("Spawning player: " + str(player_id))
	
	rpc_id(player_id, "setMap", map)
	rpc_id(player_id, "setMapRoll", mapRoll)
	
	ingame[player_id] = car.instance()
	ingame[player_id].name = "Player_" + str(player_id)
	ingame[player_id].id = player_id
	ingame[player_id].position = spawn_positions.pop_front()
	ingame[player_id].rotation = 3*PI/2
	world.add_child(ingame[player_id])
	
remote func syncUpdate(package):
	var player_id = get_tree().get_rpc_sender_id()
	if (ingame.has(player_id)):
		ingame[player_id].input_dict = package["input"]
		ingame[player_id].progress = package["progress"]

