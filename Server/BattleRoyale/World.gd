extends "res://GameBase.gd"
func systemname():
	return "BattleRoyale"
	
var BRPlayer = preload("res://BattleRoyale/BR_Player.tscn")
	
var status = {}
var ingame = {}

func add_player(newplayer):
	.add_player(newplayer)
	status[newplayer.playerID] = "UNSPAWNED"
	print("adding player: ",newplayer)
func remove_player(player_id):
	.remove_player(player_id)
	status.erase(player_id)
	if player_id in ingame:
		ingame[player_id].queue_free()
		ingame.erase(player_id)

func _ready():
	var _timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "_send_rpc_update")
	_timer.set_wait_time(0.1)#10 rpc updates per second
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()
	
func _send_rpc_update():
	var tframe = []
	for gg in ingame.values(): tframe.append(gg.pack())
	for p in players: rpc_unreliable_id(p.playerID,"frameUpdate",tframe)

remote func spawn(x,y):
	print("spawn called")
	var player_id = get_tree().get_rpc_sender_id()
	if status[player_id] != "UNSPAWNED": return
	status[player_id] = "INGAME"
	ingame[player_id] = BRPlayer.instance()
	ingame[player_id].id = player_id
	ingame[player_id].position = Vector2(x,y)
	$World.add_child(ingame[player_id])
	
remote func syncUpdate(package):
	var player_id = get_tree().get_rpc_sender_id()
	ingame[player_id].unpack(package)
	
	


remote func shoot():
	var player_id = get_tree().get_rpc_sender_id()
	print(str(player_id)+" is shooting.")




