extends "res://scripts/MinigameServers/MinigameBase.gd"

var gameinstance

var world_map = null
var mapRoll = null;

func _ready():
	print("I have been added to a racing game lobby")
	gameinstance = get_tree().get_root().get_node_or_null("/root/WorldContainer")
	if gameinstance!=null && gameinstance.get('world_type')!='demo_derby': gameinstance = null
	var _timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "syncUpdate")
	_timer.set_wait_time(0.02)#50 rpc updates per second
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()
	
	
remote func notifystrike(struckid):
	if gameinstance==null: return
	if gameinstance.gui==null: return
	gameinstance.gui.find_node("Hit").text=str(get_player(struckid).username).to_upper()+" HIT!"
	gameinstance.gui.find_node("HitAnim").play("PlayerHit")

func syncUpdate():
	if gameinstance==null: return
	if players[0].playerID in gameinstance.players:
		var p = gameinstance.players[players[0].playerID]
		rpc_unreliable_id(1,"syncUpdate",{"input": p.input_dict, "progress": p.lap + p.checkpoint})

remote func frameUpdate(s_players, powerups, projectile_frame, trap_frame):
	if gameinstance==null:
		gameinstance = get_tree().get_root().get_node_or_null("/root/WorldContainer")
		if gameinstance!=null && gameinstance.get('world_type')!='racing_game': gameinstance = null
		if gameinstance==null: return
	if gameinstance.world == null: 
		gameinstance.load_map(world_map)
		gameinstance.load_mapRoll(mapRoll);
	for s_player in s_players:
		if s_player['id'] in gameinstance.players:
			gameinstance.players[s_player['id']].unpack(s_player)
		else:
			gameinstance.players[s_player['id']] = preload("res://minigames/RacingGame/objects/racingCar.tscn").instance()
			gameinstance.players[s_player['id']].name = "Player_" + str(s_player['id'])
			gameinstance.get_node("World").add_child(gameinstance.players[s_player['id']])
			gameinstance.players[s_player['id']].unpack(s_player)
	var world = gameinstance.get_node("World")
	for powerup in powerups:
		if world.has_node(powerup["name"]):
			world.get_node(powerup["name"]).unpack(powerup)
		else:
			var p_node = preload("res://minigames/RacingGame/objects/powerup.tscn").instance()
			p_node.position = Vector2(powerup["x"],powerup["y"])
			p_node.name = powerup["name"]
			world.add_child(p_node)
			p_node.unpack(powerup)
	
	for projectile_pkg in projectile_frame:
		if world.has_node(projectile_pkg["name"]):
			world.get_node(projectile_pkg["name"]).unpack(projectile_pkg)
		else:
			var proj_node = preload("res://minigames/RacingGame/objects/PU_Proj.tscn").instance()
			proj_node.name = projectile_pkg["name"]
			proj_node.unpack(projectile_pkg)
			world.add_child(proj_node)
	for trap_pkg in trap_frame:
		if world.has_node(trap_pkg["name"]):
			world.get_node(trap_pkg["name"]).unpack(trap_pkg)
		else:
			var trapNode = preload("res://minigames/RacingGame/objects/trap.tscn").instance()
			trapNode.name = trap_pkg["name"]
			trapNode.unpack(trap_pkg)
			world.add_child(trapNode)
		
	for child in world.get_children():
		if child.name.begins_with("Projectile"):
			var found = false
			for projectile_pkg in projectile_frame:
				if child.name == projectile_pkg["name"]:
					found = true
			if !found:
				world.remove_child(child)
		if child.name.begins_with("Trap"):
			var found = false
			for trap_pkg in trap_frame:
				if child.name == trap_pkg["name"]:
					found = true
			if !found:
				world.remove_child(child)

	

remote func setMap(map):
	world_map = map

remote func setMapRoll(mapRolls):
	mapRoll = mapRolls;

remote func endMatch():
	AudioPlayer.pause_music()
	gameinstance.players[get_tree().get_network_unique_id()].racingscoreboard._open_player_list()
