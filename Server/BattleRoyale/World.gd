extends "res://GameBase.gd"
func systemname():
	return "BattleRoyale"
	
var BRPlayer = preload("res://BattleRoyale/BR_Player.tscn")
var BRBullet = preload("res://BattleRoyale/BasicBullet.tscn")
	
var status = {}
var ingame = {}
var bullets = {}


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
	var player_frame = []
	for gg in ingame.values(): player_frame.append(gg.pack())
	var bullet_frame = []
	for gg in bullets.values(): bullet_frame.append(gg.pack())
	for p in players: rpc_unreliable_id(p.playerID,"frameUpdate",player_frame,bullet_frame)

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
	if (ingame.has(player_id)):
		ingame[player_id].unpack(package)

remote func shoot(package):
	var player_id = get_tree().get_rpc_sender_id()
	print("GOING TO TRY CHECKING FOR BULLETS")
	if package['id'] in bullets: return
	for player in players:
		if player.playerID!=player_id: rpc_id(player.playerID,"other_shoot",package)
	print("I AM UNPACKING A BULLET")
	bullets[package['id']] = BRBullet.instance()
	bullets[package['id']].unpack(package)
	bullets[package['id']].connect("strike",self,"_on_strike")
	$World.add_child(bullets[package['id']])

	print(str(player_id)+" is shooting.")



func _on_strike(bullet,object):
	if object==null:
		for player in players: rpc_id(player.playerID,"strike",bullet.pack(),null)
	elif object.get('entity_type')=='bullet':
		for player in players: rpc_id(player.playerID,"strike",bullet.pack(),{'type':'bullet','obj':object.pack()})
		bullets.erase(bullet.id)
		$World.remove_child(object)
		object.queue_free()
	elif object.get('entity_type')=='player':
		object.health -= 0.1
		for player in players: rpc_id(player.playerID,"strike",bullet.pack(),{'type':'player','obj':object.pack()})
		if object.health<=0: _on_die(object)
	bullets.erase(bullet.id)
	$World.remove_child(bullet)
	bullet.queue_free()

func _on_die(player):
	for oplayer in players: rpc_id(oplayer.playerID,"die",player.pack())
	status[player.id] = "DEAD"
	$World.remove_child(ingame[player.id])
	ingame[player.id].queue_free()
	ingame.erase(player.id)
	if ingame.size()==1:
		for remaining_player in ingame:
			crown_winner(remaining_player)
			break

func crown_winner(playerID):
	for oplayer in players: rpc_id(oplayer.playerID,"win",playerID)










