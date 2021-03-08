extends KinematicBody2D

var speed = 200
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
	velocity = Vector2(0, input_vector.y*speed).rotated(rotation)
	move_and_slide(velocity)

