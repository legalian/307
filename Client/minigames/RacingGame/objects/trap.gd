extends "res://objects/rotatedObject.gd"

func _ready():
	set_process(true)

func _process(delta):
	pass

func unpack(package):
	position = Vector2(package['x'],package['y'])

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

