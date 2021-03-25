extends Node2D

var velocity;

func _physics_process(delta):
	pass

func pack():
	return {
		'x':position.x,
		'y':position.y,
		'r':rotation,
		'name':name
	}
