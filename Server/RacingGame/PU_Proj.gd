extends KinematicBody2D

var speed = 1500

var velocity


func _ready():
	set_process(true)
	velocity = Vector2(speed, speed) #.rotated(r)

func _physics_process(delta):
	# Somehow get direction from RacingCar.gd
	var coll_obj = move_and_collide(velocity * delta)
	pass

func pack():
	return {
		'x':position.x,
		'y':position.y,
		'r':rotation,
		'name':name
	}
