extends "res://scripts/MinigameServers/MinigameBase.gd"

const Player = preload("res://scripts/MinigameServers/Player.gd")

func _ready():
	rpc_id(1,'setusername',players[0].username)
	rpc_id(1,'setavatar',players[0].avatar)
	rpc_id(1,'sethat',players[0].hat)

remote func add_player(packed):
	players.append(Player.new(packed))

remote func setusername(player_id,name):
	get_player(player_id).username = name

remote func setavatar(player_id,avatar):
	get_player(player_id).avatar = avatar

remote func sethat(player_id,hat):
	get_player(player_id).hat = hat
