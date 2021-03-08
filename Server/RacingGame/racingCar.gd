extends KinematicBody2D

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
	velocity = input_vector
	velocity = move_and_slide(velocity)



