extends "res://scripts/MinigameServers/MinigameBase.gd"

func _ready():
	print("I have been added to a battle royale lobby")

func shoot():
	print("I am shooting")
	rpc_id(1,"shoot")

func player_disconnected(player_id):
	print("a peer has disconnected.")
	pass

