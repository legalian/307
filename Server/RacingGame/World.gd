extends "res://GameBase.gd"
func systemname():
	return "RacingGame"

var rng = RandomNumberGenerator.new()

var car = preload("res://RacingGame/racingCar.tscn")

var ingame = {}

func add_player(newplayer):
	.add_player(newplayer)
	spawn(newplayer.playerID)


func remove_player(player_id):
	.remove_player(player_id)

func _ready():
	rng.randomize()
	var _timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "_send_rpc_update")
	_timer.set_wait_time(0.02)#50 rpc updates per second
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()
	
func _send_rpc_update():
	var player_frame = []
	for gg in ingame.values():
		player_frame.append(gg.pack())
	for p in players:
		rpc_unreliable_id(p.playerID,"frameUpdate",player_frame)

func spawn(player_id):
	print("spawn called")
	ingame[player_id] = car.instance()
	ingame[player_id].name = "Player_" + str(player_id)
	ingame[player_id].id = player_id
	ingame[player_id].position = Vector2(-1555.4 + rng.randi_range(-100,100),1893.06 + rng.randi_range(-100,100))
	$World.add_child(ingame[player_id])
	
remote func syncUpdate(package):
	var player_id = get_tree().get_rpc_sender_id()
	if (ingame.has(player_id)):
		ingame[player_id].input_vector = package

func _process(delta):
	pass
