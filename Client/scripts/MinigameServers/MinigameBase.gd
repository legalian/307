extends Node

var callback

var players#a reference to a parent property by the same name

func _ready():#this is called in cascasde so no worries about overriding
	players = get_node("..").players
	print("I have been added to a generic lobby")

func get_player(player_id):
	for player in players:
		if player.playerID==player_id: return player

func player_disconnected(player_id):
	pass

remote func setscore(player_id,score):
	get_player(player_id).score = score

remote func drop_player(player_id):
	player_disconnected(player_id)
	for i in range(players.size()-1,-1,-1):
		if players[i].playerID==player_id: players.remove(i)




