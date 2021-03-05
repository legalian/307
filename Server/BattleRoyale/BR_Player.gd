extends RigidBody2D

var id
var health = 1.0
var lx=0
var ly=0
	
func pack():
	return {
		'id':id,
		'x':position.x,
		'y':position.y,
		'r':rotation,
		'vx':linear_velocity.x,
		'vy':linear_velocity.y,
		'vr':angular_velocity,
		'h':health,
		'lx':lx,
		'ly':ly
	}

func unpack(package):
	position = Vector2(package['x'],package['y'])
	rotation = package['r']
	linear_velocity = Vector2(package['vx'],package['vy'])
	angular_velocity = package['vr']
	#we don't let the client set the health- the server knows better
	lx = package['lx']
	ly = package['ly']


