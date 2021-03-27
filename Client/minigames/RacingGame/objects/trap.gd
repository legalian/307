extends "res://objects/rotatedObject.gd"


func unpack(package):
	position = Vector2(package['x'],package['y'])

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
