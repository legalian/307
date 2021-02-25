extends "res://scripts/MinigameServers/MinigameBase.gd"

const Player = preload("res://scripts/MinigameServers/Player.gd")

func _ready():
	print("I have been added to a party creation screen")

remote func add_player(packed):
	players.append(Player.new(packed))

remote func setusername(player_id,name):
	get_player(player_id).username = name

remote func setavatar(player_id,avatar):
	get_player(player_id).avatar = avatar
	
remote func sethat(player_id,hat):
	get_player(player_id).hat = hat
	
remote func shoot():
	print("Shoot called")
