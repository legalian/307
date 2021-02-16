extends KinematicBody2D

var speed = 300
var friction = 0.2
var acceleration = 0.3
var velocity = Vector2.ZERO

var rotspeed = 10
var rotfriction = 0.2
var rotacceleration = 0.1
var rotvel = 0

var remotenode = null

func _ready():
	set_process(true)

func _process(delta):
	#set_rotation(get_rotation() + delta * 5)
	var glt = get_global_transform_with_canvas()
	glt.origin = Vector2(0,0);
	get_node("Visible").transform = glt.affine_inverse();

func _physics_process(delta):
	var input_velocity = Vector2.ZERO
	# Check input for "desired" velocity
	if Input.is_action_pressed("move_right"):input_velocity.x += 1
	if Input.is_action_pressed("move_left"):input_velocity.x -= 1
	if Input.is_action_pressed("move_down"):input_velocity.y += 1
	if Input.is_action_pressed("move_up"):input_velocity.y -= 1
		
	var input_rotvel = 0
	if Input.is_action_pressed("rotate_left"):input_rotvel -= 1
	if Input.is_action_pressed("rotate_right"):input_rotvel += 1
		
	input_velocity = (input_velocity.normalized() * speed)#.rotated(-get_node("Camera").rotation)
	input_rotvel = input_rotvel * rotspeed
	

	# If there's input, accelerate to the input velocity
	if input_velocity.length() > 0:
		velocity = velocity.linear_interpolate(input_velocity, acceleration)
	else:
		# If there's no input, slow down to (0, 0)
		velocity = velocity.linear_interpolate(Vector2.ZERO, friction)
	velocity = move_and_slide(velocity)
	
	if input_rotvel!=0:
		rotvel = rotvel*(1-rotacceleration) + rotacceleration*input_rotvel
	else:
		rotvel = rotvel*(1-rotfriction) + rotfriction*0
	
	get_node("Camera").rotate(rotvel*delta)
	

	
	
