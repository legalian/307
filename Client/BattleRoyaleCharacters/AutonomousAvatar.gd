extends KinematicBody2D


var velocity = Vector2.ZERO
var rotvel = 0
var lookoffset = Vector2.ZERO

func _ready():
	pass # Replace with function body.

func unpack(package):
	position = Vector2(package['x'],package['y'])
	rotation = package['r']
	velocity = Vector2(package['vx'],package['vy'])
	rotvel = package['vr']
	#we don't let the client set the health- the server knows better
	lookoffset = Vector2(package['lx'],package['ly'])

func _process(delta):
	$Body.set_look_pos(get_parent().global_transform.xform(lookoffset+global_position))

func _physics_process(delta):
	velocity = move_and_slide(velocity)
	rotate(rotvel*delta)

