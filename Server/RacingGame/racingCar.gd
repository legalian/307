extends KinematicBody2D

var maxSpeed = 500
var speed = 0
var acceleration = 25
var rotSpeed = 0.1

var id
var velocity = Vector2.ZERO
var input_vector = Vector2.ZERO
	
func pack():
	return {
		'id':id,
		'x':position.x,
		'y':position.y,
		'r':rotation,
	}

func _physics_process(delta):
	rotation += input_vector.x * rotSpeed
	if input_vector.y == 0:
		speed = move_toward(speed, 0, 10)
	speed += input_vector.y*acceleration
	speed = clamp(speed, -maxSpeed, maxSpeed)
	velocity = Vector2(0, speed).rotated(rotation)
	move_and_slide(velocity)

