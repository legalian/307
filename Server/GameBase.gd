extends Node

var players = []

func player_count():
	return players.size()

func add_player(newplayer):
	players.append(newplayer)
	
func remove_player(player_id):
	for i in range(players.size()-1,-1,-1):
		print("-=-=-=-- ",i)
		if players[i].playerID==player_id: players.remove(i)

func get_player(player_id):
	for player in players:
		if player.playerID==player_id: return player
		
func syncScores():
	for p in players:
		if(p.dummy == 0):
			rpc("setscore",p.playerID,p.score)

remote func addscore(amt):
	var player_id = get_tree().get_rpc_sender_id()
	var player = get_player(player_id)
	player.score += 1
	for p in players: 
		if(p.dummy == 0):
			rpc(p.playerID,"setscore",player_id,player.score)
	
remote func reducescore(amt):
	var player_id = get_tree().get_rpc_sender_id()
	var player = get_player(player_id)
	player.score += 1
	for p in players: 
		if(p.dummy == 0):
			rpc(p.playerID,"setscore",player_id,player.score)

func _ready():
	print("minigame has been created.")
