extends KinematicBody2D

var entity_type = 'player'

var id
var health = 1.0
var lx=0
var ly=0
var velocity = Vector2.ZERO
var rotvel = 0
var gun = 1
var gunbar = 100

func pack():
	return {
		'id':id,
		'x':position.x,
		'y':position.y,
		'r':rotation,
		'vx':velocity.x,
		'vy':velocity.y,
		'vr':rotvel,
		'h':health,
		'lx':lx,
		'ly':ly,
		'gun':gun,
		'gunbar':gunbar
	}

func unpack(package):
	position = Vector2(package['x'],package['y'])
	rotation = package['r']
	velocity = Vector2(package['vx'],package['vy'])
	rotvel = package['vr']
	#we don't let the client set the health- the server knows better
	lx = package['lx']
	ly = package['ly']

func _physics_process(delta):
	velocity = move_and_slide(velocity)
	rotate(rotvel*delta)






