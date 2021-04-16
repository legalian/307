extends "res://GameBase.gd"
func systemname():
	return "BattleRoyale"
	
var BRPlayer = preload("res://BattleRoyale/BR_Player.tscn")
var BRBullet = preload("res://BattleRoyale/BasicBullet.tscn")
	
var status = {}
var ingame = {}
var bullets = {}

var mapSelect = "nonmap";

const MAPS = ["Grass", "Desert"]

var map = null
var world = null
var mapRoll;

var debug_id = 1010101010

func add_player(newplayer):
	.add_player(newplayer)
	status[newplayer.playerID] = "UNSPAWNED"
	print("adding player: ",newplayer)
	rpc_id(newplayer.playerID, "setMap", map)
	rpc_id(newplayer.playerID, "setMapRoll", mapRoll)
func remove_player(player_id):
	.remove_player(player_id)
	status.erase(player_id)
	if ingame.has(player_id):
		$World.remove_child(ingame[player_id])
		ingame[player_id].queue_free()
		ingame.erase(player_id)

func _ready():
	var rng = RandomNumberGenerator.new();
	rng.randomize();
	if(OS.has_environment("MAPTEST")):
		mapSelect = OS.get_environment("MAPTEST");
		print("MAPSELECT = " + mapSelect)
	if(mapSelect != "nonmap" && mapSelect != "candy"):
		if(mapSelect == "grassland"):
			map = MAPS[0];
			mapRoll = 630
		else:
			map = MAPS[1];
			mapRoll = 450
	else:
		print("NO MAP SELECTED\n");
		mapRoll = rng.randi_range(360, 3600);
		if(mapRoll % 360  >= 180):
			map = MAPS[0];
		else:
			map = MAPS[1];



	if map == "Grass":
		world = preload("res://BattleRoyale/World-Grass.tscn").instance()
	elif map == "Desert":
		world = preload("res://BattleRoyale/World-Desert.tscn").instance()
	assert(world != null)
	add_child(world)

	var _timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "_send_rpc_update")
	_timer.set_wait_time(0.1)#10 rpc updates per second
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()
	if "battleroyale_shim" == OS.get_environment("MULTI_USER_TESTING"):
		spawn_id(0,0,debug_id);
	
func _send_rpc_update():
	var player_frame = []
	for gg in ingame.values(): player_frame.append(gg.pack())
	var bullet_frame = []
	for gg in bullets.values(): bullet_frame.append(gg.pack())
	var powerup_frame = []
	
	for child in $World.get_children():
		if child.get('entity_type') == 'collectible':
			powerup_frame.append(child.pack())
		
	for p in players:
		if(p.dummy == 0):
			rpc_unreliable_id(p.playerID,"frameUpdate",player_frame,bullet_frame,powerup_frame)


#func _process(delta):
#	return
	for player in players:
		if player.playerID==debug_id: continue
		if (player.playerID != 0 && ingame.has(player.playerID)):
			#print("Calling update radius")
			var circle = get_node("World/Circle")
			if(player.dummy == 0):
				rpc_unreliable_id(player.playerID, "update_radius", circle.radius)
			if (circle.isInCircle(ingame[player.playerID].position)):
				if(player.dummy == 0):
					rpc_id(player.playerID, "update_health_bar", ingame[player.playerID].health)
				print(str(player.playerID) + " Damaged from server")
				ingame[player.playerID].health -= .01
				if (ingame[player.playerID].health <= 0):
					_on_die(ingame[player.playerID])

func spawn_id(x,y,player_id):
	if (status.has(player_id)):
		if status[player_id] != "UNSPAWNED": return
	status[player_id] = "INGAME"
	
	print("Spawning player!");
	ingame[player_id] = BRPlayer.instance()
	ingame[player_id].id = player_id
	ingame[player_id].position = Vector2(x,y)
	
	world.add_child(ingame[player_id])
	
remote func spawn(x,y):
	print("spawn called")
	var player_id = get_tree().get_rpc_sender_id()
	spawn_id(x,y,player_id)
	
remote func syncUpdate(package):
	var player_id = get_tree().get_rpc_sender_id()
	if (ingame.has(player_id)):
		ingame[player_id].unpack(package)

remote func shoot(package):
	var player_id = get_tree().get_rpc_sender_id()
	if !ingame.has(player_id): return
	var playerobj = ingame[player_id]
	playerobj.gunbar -= {1:0,2:5,3:10,4:25}[playerobj.gun]
	if playerobj.gunbar<=0: playerobj.gun = 1
	print("GOING TO TRY CHECKING FOR BULLETS")
	if package['id'] in bullets: return
	for player in players:
		if player.playerID!=player_id && player.dummy == 0 : rpc_id(player.playerID,"other_shoot",package)
	print("I AM UNPACKING A BULLET")
	bullets[package['id']] = BRBullet.instance()
	world.add_child(bullets[package['id']])
	bullets[package['id']].unpack(package)
	bullets[package['id']].connect("strike",self,"_on_strike")

	print(str(player_id)+" is shooting.")


func _on_explode(avatar):
	avatar.health -= 0.201
	rpc_id(avatar.id, "update_health_bar", avatar.health)
	if avatar.health<=0: _on_die(avatar)
	for player in players:
		if player.playerID==debug_id: continue
		rpc_id(player.playerID,"strike",null,{'type':'player','obj':avatar.pack()})

func _on_strike(bullet,object):
	if !bullet.simple:
		var expl = preload("res://BattleRoyale/explosion.tscn").instance()
		expl.connect("explode",self,"_on_explode")
		expl.position = bullet.position
		$World.add_child(expl)
		for player in players:
			if player.playerID!=debug_id:
				rpc_id(player.playerID,"explode",expl.position)
		
	if object==null:
		for player in players:
			if player.playerID!=debug_id: rpc_id(player.playerID,"strike",bullet.pack(),null)
	elif object.get('entity_type')=='bullet':
		for player in players:
			if player.playerID!=debug_id: rpc_id(player.playerID,"strike",bullet.pack(),{'type':'bullet','obj':object.pack()})
		bullets.erase(object.id)
		$World.remove_child(object)
		object.queue_free()
	elif object.get('entity_type')=='player':
		object.health -= 0.101
		for player in players:
			if player.playerID==debug_id: continue
			rpc_id(player.playerID,"strike",bullet.pack(),{'type':'player','obj':object.pack()})
			if (ingame.has(player.playerID)):
				rpc_id(player.playerID, "update_health_bar", ingame[player.playerID].health)
		if object.health<=0: _on_die(object)
		
	bullets.erase(bullet.id)
	$World.remove_child(bullet)
	bullet.queue_free()

func _on_die(player):
	for oplayer in players: 
		if oplayer.playerID == player.id:
			oplayer.score += players.size()-ingame.size()
		if oplayer.playerID==debug_id: continue
		rpc_id(oplayer.playerID,"die",player.pack())
	status[player.id] = "DEAD"
	$World.remove_child(ingame[player.id])
	ingame[player.id].queue_free()
	ingame.erase(player.id)
	if ingame.size()==1:
		for remaining_player in ingame:
			crown_winner(remaining_player)
			break

func crown_winner(playerID):
	for oplayer in players: 
		if oplayer.playerID == playerID:
			oplayer.score += players.size()-ingame.size()
		if oplayer.playerID==debug_id: continue
		rpc_id(oplayer.playerID,"win",playerID)
	syncScores()
	print("WINNER CROWNED! GO TO NEXT MINIGAME")
	get_parent().go_to_next_minigame(playerID)














