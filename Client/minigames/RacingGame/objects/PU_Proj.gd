tool
extends "res://objects/rotatedObject.gd"

func _ready():
	set_process(true)

func _process(delta):
	._process(delta)

func unpack(package):
	position = Vector2(package['x'],package['y'])
	rotation = package['r'] + 3.0*PI/2.0
