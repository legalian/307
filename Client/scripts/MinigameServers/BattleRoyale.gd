extends "res://scripts/MinigameServers/MinigameBase.gd"

var clientstatus = "UNSPAWNED"
var gameinstance

func _ready():
	print("I have been added to a battle royale lobby")
	gameinstance = get_tree().get_root().get_node_or_null("/root/WorldContainer")
	

func shoot():
	print("I am shooting")
	rpc_id(1,"shoot")

func spawn():
	print("spawn called")
	rpc_id(1,"spawn",0,0)

func syncUpdate(package):
	rpc_unreliable_id(1,"syncUpdate",package)
	
	

remote func frameUpdate(s_players):
	if gameinstance==null:
		gameinstance = get_tree().get_root().get_node_or_null("/root/WorldContainer")
		if gameinstance==null: return
	for s_player in s_players:
		if s_player['id'] in gameinstance.players:
			gameinstance.players[s_player['id']].unpack(s_player)
		else:
			if s_player['id'] == players[0].playerID:
				gameinstance.players[s_player['id']] = preload("res://BattleRoyaleCharacters/RaccoonPlayer.tscn").instance()
			else:
				gameinstance.players[s_player['id']] = preload("res://BattleRoyaleCharacters/AutonomousAvatar.tscn").instance()
			gameinstance.players[s_player['id']].unpack(s_player)
			gameinstance.get_node("World").add_child(gameinstance.players[s_player['id']])
	
	#print("frame updated")

#func _process(delta):
	

