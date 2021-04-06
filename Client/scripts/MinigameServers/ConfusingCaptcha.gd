extends "res://scripts/MinigameServers/MinigameBase.gd"

var clientstatus = "UNSPAWNED"
var gameinstance

var world_map = null;
var mapRoll = null;

func _ready():
	gameinstance = get_tree().get_root().get_node_or_null("/root/WorldContainer")
	if gameinstance!=null && gameinstance.get('world_type')!='battle_royale': gameinstance = null
	var _timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "syncUpdate")
	_timer.set_wait_time(0.1)#10 rpc updates per second
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()

func shoot(package):
	rpc_id(1,"shoot",package)

func spawn(x, y):
	rpc_id(1,"spawn",x,y)

func syncUpdate():
	if gameinstance==null: return
	if players[0].playerID in gameinstance.players:
		rpc_unreliable_id(1,"syncUpdate",gameinstance.players[players[0].playerID].pack())

remote func frameUpdate(s_players,s_bullets,s_powerups):
	if gameinstance==null:
		gameinstance = get_tree().get_root().get_node_or_null("/root/WorldContainer")
		if gameinstance!=null && gameinstance.get('world_type')!='battle_royale': gameinstance = null
		if gameinstance==null: return
	var visited = []
	if gameinstance.world == null:
		gameinstance.load_map(world_map)
		gameinstance.load_mapRoll(mapRoll);
	for s_player in s_players:
		visited.append(s_player['id'])
		if s_player['id'] in gameinstance.players:
			gameinstance.players[s_player['id']].unpack(s_player)
		else:
			if s_player['id'] == players[0].playerID:
				gameinstance.players[s_player['id']] = preload("res://ConfusingCaptchaCharacters/RaccoonPlayer.tscn").instance()
			else:
				gameinstance.players[s_player['id']] = preload("res://ConfusingCaptchaCharacters/AutonomousAvatar.tscn").instance()
			gameinstance.get_node("World").add_child(gameinstance.players[s_player['id']])
			gameinstance.players[s_player['id']].unpack(s_player)
	var mustremove = []
	for player in gameinstance.players:
		if gameinstance.players[player].dying: continue
		if !visited.has(player): mustremove.append(player)
	for player in mustremove:
		gameinstance.get_node("World").remove_child(gameinstance.players[player])
		gameinstance.players[player].queue_free()
		gameinstance.players.erase(player)
		
		
	visited = []
	for s_bullet in s_bullets:
		visited.append(s_bullet['id'])
		if s_bullet['id'] in gameinstance.bullets:
			gameinstance.bullets[s_bullet['id']].unpack(s_bullet)
		else:
			gameinstance.bullets[s_bullet['id']] = preload("res://Guns/BasicRedBullet.tscn").instance()
			gameinstance.get_node("World").add_child(gameinstance.bullets[s_bullet['id']])
			gameinstance.bullets[s_bullet['id']].unpack(s_bullet)
	mustremove = []
	for bullet in gameinstance.bullets:
		if !visited.has(bullet): mustremove.append(bullet)
	for bullet in mustremove:
		gameinstance.get_node("World").remove_child(gameinstance.bullets[bullet])
		gameinstance.bullets[bullet].queue_free()
		gameinstance.bullets.erase(bullet)
	
	visited = []
	for s_powerup in s_powerups:
		visited.append(s_powerup['id'])
		if s_powerup['id'] in gameinstance.powerups:
			gameinstance.powerups[s_powerup['id']].unpack(s_powerup)
		else:
			gameinstance.powerups[s_powerup['id']] = preload("res://Guns/Collectible.tscn").instance()
			gameinstance.get_node("World").add_child(gameinstance.powerups[s_powerup['id']])
			gameinstance.powerups[s_powerup['id']].unpack(s_powerup)
	mustremove = []
	for powerup in gameinstance.powerups:
		if !visited.has(powerup): mustremove.append(powerup)
	for powerup in mustremove:
		gameinstance.get_node("World").remove_child(gameinstance.powerups[powerup])
		gameinstance.powerups[powerup].queue_free()
		gameinstance.powerups.erase(powerup)


remote func other_shoot(package):
	if gameinstance == null: return
	if package['id'] in gameinstance.bullets: return
	gameinstance.bullets[package['id']] = preload("res://Guns/BasicRedBullet.tscn").instance()
	gameinstance.get_node("World").add_child(gameinstance.bullets[package['id']])
	gameinstance.bullets[package['id']].unpack(package)


remote func strike(bullet,object):
	if gameinstance == null: return
	if bullet!=null and bullet['id'] in gameinstance.bullets:
		gameinstance.get_node("World").remove_child(gameinstance.bullets[bullet['id']])
		gameinstance.bullets[bullet['id']].queue_free()
		gameinstance.bullets.erase(bullet['id'])
	if object==null: pass
	elif object['type']=='bullet':
		if gameinstance.bullets.has(object['obj']['id']):
			gameinstance.get_node("World").remove_child(gameinstance.bullets[object['obj']['id']])
			gameinstance.bullets[object['obj']['id']].queue_free()
			gameinstance.bullets.erase(object['obj']['id'])
	elif object['type']=='player':
		gameinstance.players[object['obj']['id']].unpack(object['obj'])
		gameinstance.players[object['obj']['id']].damage()

remote func explode(location):
	print("exploding")
	var inst = preload("res://objects/explosion.tscn").instance()
	inst.position = location
	gameinstance.get_node("World").add_child(inst)
	

remote func die(package):
	if gameinstance == null: return
	gameinstance.players[package['id']].unpack(package)
	gameinstance.players[package['id']].die()
	
remote func win(playerID):
	if playerID==players[0].playerID:
		get_tree().change_scene("res://minigames/ConfusingCaptcha/WinScreen.tscn")
	else:
		get_tree().change_scene("res://minigames/ConfusingCaptcha/LoseScreen.tscn")

remote func update_radius(var rad: float):
	if gameinstance == null: return
	gameinstance.get_node("World/Circle").update_radius(rad)
	
	
remote func update_health_bar(var health: float):
	if gameinstance == null: return
	gameinstance.get_node("World/Player").get_node("HUD/HealthBar").set_value(health*100)
	
remote func setMap(map):
	world_map = map

remote func setMapRoll(mapRolls):
	mapRoll = mapRolls

func showlose():
	get_tree().change_scene("res://minigames/ConfusingCaptcha/LoseScreen.tscn")
	
	






