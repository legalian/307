extends KinematicBody2D

func _ready():
	set_process(true)

func _process(delta):
	pass

func unpack(package):
	position = Vector2(package['x'],package['y'])
	rotation = package['r']
