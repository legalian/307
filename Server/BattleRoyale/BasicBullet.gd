extends KinematicBody2D
signal strike

var entity_type = 'bullet'

var id
var rem = 1500
var speed = 500
var simple = true
	
func pack():
	return {
		'simple':simple,
		'id':id,
		'x':position.x,
		'y':position.y,
		'r':rotation,
		'rem':rem
	}

func unpack(package):
	simple = package['simple']
	position = Vector2(package['x'],package['y'])
	rotation = package['r']
	id = package['id']
	
func _physics_process(delta):
	var velocity = Vector2(-speed, 0).rotated(rotation)
	var collision = move_and_collide(velocity * delta)
	if collision:
		print("HIT")
		#velocity = velocity.bounce(collision.normal)
		#rotation = velocity.angle()+PI
		emit_signal("strike",self,collision.collider)
	else:
		rem -= delta*speed
		if rem<0:
			emit_signal("strike",self,null)
	velocity = move_and_slide(velocity)


