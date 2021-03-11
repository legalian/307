extends "res://GameBase.gd"
func systemname():
	return "RacingGame"

var rng = RandomNumberGenerator.new()

var car = preload("res://RacingGame/racingCar.tscn")

var spawn_positions = []

var started = false

var ingame = {}

class PlaceSorter:
	static func sort_places(a, b):
		if a[1] > b[1]:
			return true
		return false

func add_player(newplayer):
	.add_player(newplayer)
	spawn(newplayer.playerID)


func remove_player(player_id):
	.remove_player(player_id)

func _ready():
	rng.randomize()
	
	for x in range(1400, 1800, 200):
		for y in range(1400, 2500, 110):
			spawn_positions.append(Vector2(x,y))
	
	randomize()
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
	_countdown.set_wait_time(7)
	_countdown.set_one_shot(true)
	_countdown.start()
	
func _countdown_end():
	started = true
	for ig in ingame.values():
		ig.set_physics_process(true)
	
func _send_rpc_update():
	var player_frame = []
	for gg in ingame.values():
		player_frame.append(gg.pack())
	for p in players:
		rpc_unreliable_id(p.playerID,"frameUpdate",player_frame)

func spawn(player_id):
	print("Spawning player: " + str(player_id))
	ingame[player_id] = car.instance()
	ingame[player_id].name = "Player_" + str(player_id)
	ingame[player_id].id = player_id
	ingame[player_id].position = spawn_positions.pop_front()
	ingame[player_id].rotation = 3*PI/2
	$World.add_child(ingame[player_id])
	
remote func syncUpdate(package):
	var player_id = get_tree().get_rpc_sender_id()
	if (ingame.has(player_id)):
		ingame[player_id].input_vector = package["input"]
		ingame[player_id].progress = package["progress"]

func _process(delta):
	var sort_array = []
	for ig in ingame.values():
		sort_array.append([ig.id, ig.progress])
	sort_array.sort_custom(PlaceSorter, "sort_places")
	for n in range(sort_array.size()):
		ingame[sort_array[n][0]].place = n + 1
