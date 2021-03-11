extends KinematicBody2D

const NUM_LAPS = 3

var maxSpeed = 1500
var speed = 0
var acceleration = 25
var rotSpeed = 0.05
var progress = 0.0
var place = 1

var id
var velocity = Vector2.ZERO
var input_vector = Vector2.ZERO
	
func pack():
	return {
		'id':id,
		'x':position.x,
		'y':position.y,
		'r':rotation,
		'place':place
	}

func _physics_process(delta):
	if progress <  NUM_LAPS + 1:
		if input_vector.y == 0:
			speed = move_toward(speed, 0, 10)
		rotation += input_vector.x * rotSpeed
		speed += input_vector.y*acceleration
	else:
		speed = move_toward(speed, 0, 50)
	
	speed = clamp(speed, -maxSpeed, maxSpeed)
	velocity = Vector2(0, speed).rotated(rotation)
	move_and_slide(velocity)

