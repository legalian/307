extends Node

var player_ids = []

func player_count():
	return player_ids.length()

func remove_player(player_id):
	player_ids.append(player_id)
	
func add_player(player_id):
	player_ids.remove(player_id)

func is_accepting_players():
	return true#stub
	
	
	

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
