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

const MAPS = ["Grass", "Desert"]

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


func remove_player(player_id):
	.remove_player(player_id)

func _ready():
	randomize()
	if(OS.has_environment("MAPTEST")):
		mapSelect = OS.get_environment("MAPTEST");
		print("MAPSELECT = " + mapSelect)
	if(mapSelect != "nonmap"):
		if(mapSelect == "grassland"):
			map = MAPS[0];
		else:
			map = MAPS[1];
	else:
		print("NO MAP SELECTED\n");
		map = MAPS[randi() % MAPS.size()]
	if map == "Grass":
		world = preload("res://RacingGame/World-Grass.tscn").instance()
	elif map == "Desert":
		world = preload("res://RacingGame/World-Desert.tscn").instance()
	assert(world != null)
	add_child(world)
	
	for node in world.get_children():
		if node.name.begins_with("Powerup"):
			powerups[node.name] = node

	for x in range(1400, 1800, 200):
		for y in range(1400, 2500, 110):
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

func spawn(player_id):
	print("Spawning player: " + str(player_id))
	
	rpc_id(player_id, "setMap", map)
	
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
		
	if done and !race_finished:
		print("Everyone finished the race!")
		race_finished = true
		
		for p in players:
			p.score += sort_array.size()-ingame[p.playerID].place
			rpc_id(p.playerID, "endMatch")
			
		syncScores()
		
		var end_match = Timer.new()
		add_child(end_match)
		end_match.connect("timeout", get_parent(), "go_to_next_minigame", [players[0].playerID])
		end_match.set_wait_time(3)
		end_match.set_one_shot(true)
		end_match.start()
