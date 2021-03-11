extends "res://scripts/MinigameServers/MinigameBase.gd"

var gameinstance

func _ready():
	print("I have been added to a racing game lobby")
	gameinstance = get_tree().get_root().get_node_or_null("/root/WorldContainer")
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

remote func frameUpdate(s_players):
	if gameinstance==null:
		gameinstance = get_tree().get_root().get_node_or_null("/root/WorldContainer")
		if gameinstance==null: return
	for s_player in s_players:
		if s_player['id'] in gameinstance.players:
			gameinstance.players[s_player['id']].unpack(s_player)
		else:
			gameinstance.players[s_player['id']] = preload("res://minigames/RacingGame/objects/racingCar.tscn").instance()
			gameinstance.players[s_player['id']].name = "Player_" + str(s_player['id'])
			gameinstance.players[s_player['id']].unpack(s_player)
			gameinstance.get_node("World").add_child(gameinstance.players[s_player['id']])
			#var nameNode = preload("res://minigames/RacingGame/objects/name.tscn").instance()
			#removed name node for now
			#nameNode.TargetNode = gameinstance.players[s_player['id']];
			#gameinstance.get_node("World").add_child(nameNode)

