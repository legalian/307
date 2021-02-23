extends Node

var player_ids = []

func player_count():
	return player_ids.size()

func remove_player(player_id):
	player_ids.erase(player_id)
	print("player has been removed from lobby.")
	
func add_player(player_id):
	player_ids.append(player_id)
	print("player has been added to lobby.")

func is_accepting_players():
	return true#stub


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print("lobby has been created.")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
