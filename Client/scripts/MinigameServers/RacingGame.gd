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
	
	# Special case for projectiles; not sure how to remove specific ones from client, so im just
	# removing all and adding them back regardless
	
	for child in world.get_children(): # Remove all projectiles
		if (child.name.begins_with("Projectile")):
			world.remove_child(child)
		if  (child.name.begins_with("Trap")):
			world.remove_child(child)
	
	for projectile_pkg in projectile_frame: # Add them back in
		var proj_node = preload("res://minigames/RacingGame/objects/PU_Proj.tscn").instance()
		proj_node.name = projectile_pkg["name"]
		world.add_child(proj_node)
		proj_node.unpack(projectile_pkg)
	for trap_pkg in trap_frame: # Add them back in
		var trapNode = preload("res://minigames/RacingGame/objects/trap.tscn").instance()
		trapNode.name = trap_pkg["name"]
		world.add_child(trapNode)
		trapNode.unpack(trap_pkg)
	

remote func setMap(map):
	world_map = map

remote func setMapRoll(mapRolls):
	mapRoll = mapRolls;

remote func endMatch():
	AudioPlayer.pause_music()
	gameinstance.players[get_tree().get_network_unique_id()].racingscoreboard._open_player_list()
