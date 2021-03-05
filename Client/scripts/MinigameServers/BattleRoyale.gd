extends "res://scripts/MinigameServers/MinigameBase.gd"

var clientstatus = "UNSPAWNED"
var gameinstance

func _ready():
	print("I have been added to a battle royale lobby")
	gameinstance = get_tree().get_root().get_node_or_null("/root/WorldContainer")
	var _timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "syncUpdate")
	_timer.set_wait_time(0.1)#10 rpc updates per second
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()

func shoot(package):
	print("I am shooting")
	rpc_id(1,"shoot",package)

func spawn():
	print("spawn called")
	rpc_id(1,"spawn",0,0)

func syncUpdate():
	if gameinstance==null: return
	if players[0].playerID in gameinstance.players:
		rpc_unreliable_id(1,"syncUpdate",gameinstance.players[players[0].playerID].pack())

remote func frameUpdate(s_players,s_bullets):
	if gameinstance==null:
		gameinstance = get_tree().get_root().get_node_or_null("/root/WorldContainer")
		if gameinstance==null: return
	var visited = []
	for s_player in s_players:
		visited.append(s_player['id'])
		if s_player['id'] in gameinstance.players:
			gameinstance.players[s_player['id']].unpack(s_player)
		else:
			if s_player['id'] == players[0].playerID:
				gameinstance.players[s_player['id']] = preload("res://BattleRoyaleCharacters/RaccoonPlayer.tscn").instance()
			else:
				gameinstance.players[s_player['id']] = preload("res://BattleRoyaleCharacters/AutonomousAvatar.tscn").instance()
			gameinstance.players[s_player['id']].unpack(s_player)
			gameinstance.get_node("World").add_child(gameinstance.players[s_player['id']])
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
			gameinstance.bullets[s_bullet['id']].unpack(s_bullet)
			gameinstance.get_node("World").add_child(gameinstance.bullets[s_bullet['id']])
	mustremove = []
	for bullet in gameinstance.bullets:
		if !visited.has(bullet): mustremove.append(bullet)
	for bullet in mustremove:
		gameinstance.get_node("World").remove_child(gameinstance.bullets[bullet])
		gameinstance.bullets[bullet].queue_free()
		gameinstance.bullets.erase(bullet)

remote func other_shoot(package):
	if package['id'] in gameinstance.bullets: return
	gameinstance.bullets[package['id']] = preload("res://Guns/BasicRedBullet.tscn").instance()
	gameinstance.bullets[package['id']].unpack(package)
	gameinstance.get_node("World").add_child(gameinstance.bullets[package['id']])

remote func strike(bullet,object):
	print("STRIKING",bullet,object,gameinstance.bullets)
	if bullet['id'] in gameinstance.bullets:
		gameinstance.get_node("World").remove_child(gameinstance.bullets[bullet['id']])
		gameinstance.bullets[bullet['id']].queue_free()
		gameinstance.bullets.erase(bullet['id'])
	if object==null: pass
	elif object['type']=='bullet':
		gameinstance.get_node("World").remove_child(gameinstance.bullets[object['obj']['id']])
		gameinstance.bullets[object['obj']['id']].queue_free()
		gameinstance.bullets.erase(object['obj']['id'])
	elif object['type']=='player':
		gameinstance.players[object['obj']['id']].unpack(object['obj'])
		gameinstance.players[object['obj']['id']].damage()

remote func die(package):
	gameinstance.players[package['id']].unpack(package)
	gameinstance.players[package['id']].die()
	
remote func win(playerID):
	if playerID==players[0].playerID:
		get_tree().change_scene("res://minigames/BattleRoyale/WinScreen.tscn")
	else:
		get_tree().change_scene("res://minigames/BattleRoyale/LoseScreen.tscn")
	
func showlose():
	get_tree().change_scene("res://minigames/BattleRoyale/LoseScreen.tscn")
	
	
	






