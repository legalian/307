extends "res://objects/rotatedObject.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var currentGame = get_tree().get_current_scene()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _current_game():
	return currentGame

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
