extends "res://scripts/MinigameServers/MinigameBase.gd"

var gameinstance

var world_map = null

func _ready():
	print("I have been added to a demo derby lobby")
	gameinstance = get_tree().get_root().get_node_or_null("/root/WorldContainer")
	if gameinstance!=null && gameinstance.get('world_type')!='demo_derby': gameinstance = null
	var _timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "syncUpdate")
	_timer.set_wait_time(0.02)#50 rpc updates per second
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()

func syncUpdate():
	if gameinstance==null: return
	if players[0].playerID in gameinstance.players:
		var p = gameinstance.players[players[0].playerID]
		rpc_unreliable_id(1,"syncUpdate",{"input": p.input_vector, "progress": p.lap + p.checkpoint})

remote func frameUpdate(s_players, powerups):
	if gameinstance==null:
		gameinstance = get_tree().get_root().get_node_or_null("/root/WorldContainer")
		if gameinstance!=null && gameinstance.get('world_type')!='demo_derby': gameinstance = null
		if gameinstance==null: return
	if gameinstance.world == null: 
		gameinstance.load_map(world_map)
	for s_player in s_players:
		if s_player['id'] in gameinstance.players:
			gameinstance.players[s_player['id']].unpack(s_player)
		else:
			gameinstance.players[s_player['id']] = preload("res://minigames/DemoDerby/objects/racingCar.tscn").instance()
			gameinstance.players[s_player['id']].name = "Player_" + str(s_player['id'])
			gameinstance.players[s_player['id']].unpack(s_player)
			gameinstance.get_node("World").add_child(gameinstance.players[s_player['id']])
	var world = gameinstance.get_node("World")
	for powerup in powerups:
		if world.has_node(powerup["name"]):
			world.get_node(powerup["name"]).unpack(powerup)
		else:
			var p_node = preload("res://minigames/DemoDerby/objects/powerup.tscn").instance()
			p_node.position = Vector2(powerup["x"],powerup["y"])
			p_node.name = powerup["name"]
			p_node.unpack(powerup)
			world.add_child(p_node)

remote func setMap(map):
	world_map = map

remote func endMatch():
	gameinstance.players[get_tree().get_network_unique_id()].scoreboard._open_player_list()
