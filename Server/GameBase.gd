extends Node

var players = []

func player_count():
	return players.size()

func add_player(newplayer):
	players.append(newplayer)
	
func remove_player(player_id):
	for i in range(players.size()-1,-1,-1):
		if players[i].playerID==player_id: players.remove(i)

func get_player(player_id):
	for player in players:
		if player.playerID==player_id: return player

remote func addscore(amt):
	var player_id = get_tree().get_rpc_sender_id()
	var player = get_player(player_id)
	player.score += 1
	for p in players: rpc(p.playerID,"setscore",player_id,player.score)
	
remote func reducescore(amt):
	var player_id = get_tree().get_rpc_sender_id()
	var player = get_player(player_id)
	player.score += 1
	for p in players: rpc(p.playerID,"setscore",player_id,player.score)





# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print("minigame has been created.")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
