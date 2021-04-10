extends KinematicBody2D

var speed = 300
var friction = 0.2
var acceleration = 0.3
var velocity = Vector2.ZERO

var rotspeed = 10
var rotfriction = 0.2
var rotacceleration = 0.1
var rotvel = 0
var lookoffset = Vector2.ZERO

var server = null
var gun = null
var l_gun = -1;
var l_body = 0
var dying = false
var setted = false


func setAvatar(index):
	if index==l_body: return
	add_child($Body.hotswap(index),true)
	l_body = index

func _ready():
	input_pickable = true
	set_process_unhandled_input(true)
	server = get_node("/root/Server").get_children()[0]
	gun = $Body.find_node("Gun")
	
	

func pack():
	return {
		'x':position.x,
		'y':position.y,
		'r':rotation,
		'vx':velocity.x,
		'vy':velocity.y,
		'vr':rotvel,
		'lx':lookoffset.x,
		'ly':lookoffset.y
	}

func unpack(package):
	if(!setted):
		position = Vector2(package['x'],package['y'])
		setted = true;
		setAvatar(get_node("/root/Server").get_player(package['id']).avatar)
		$Body.set_Hat(get_node("/root/Server").get_player(package['id']).hat)
	if l_gun!=package['gun']:
		gun = $Body.set_Gun(package['gun'])
		l_gun = package['gun']
	$HUD/PowerBar.visible = package['gun']!=1
	$HUD/PowerBar.value = package['gunbar']
	#rotation = package['r']
	pass#will need up set position or rotation if it's too far away
	
	#velocity = Vector2(package['vx'],package['vy'])
	#rotvel = package['vr']

func _process(delta):
	lookoffset = get_parent().global_transform.xform_inv(get_global_mouse_position()) - global_position
	#$Target.global_position = get_global_mouse_position()
	$Body.set_look_pos(get_global_mouse_position(),velocity)
	
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

	input_velocity = (input_velocity.normalized() * speed).rotated(rotation)
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
	rotate(rotvel*delta)
	
func _unhandled_input(event):
	if dying: return
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			if gun!=null: gun.fire(self,$Target)
		if !event.pressed and event.button_index == BUTTON_LEFT:
			if gun!=null: gun.unfire()

	

func damage():
	$Body.ouch()
	
func die():
	dying = true
	speed=0
	get_node("CollisionShape2D").disabled = true#disable collisions and begin dying
	$Body.rip()
	var _timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "finish_dying")
	_timer.set_wait_time(1.5)#normally wait for the animation to finish
	_timer.start()

func finish_dying():
	server.showlose()





