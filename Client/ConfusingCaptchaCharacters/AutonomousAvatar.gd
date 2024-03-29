extends KinematicBody2D

var id

var velocity = Vector2.ZERO
var rotvel = 0
var lookoffset = Vector2.ZERO

var last_position
var dying = false
var server = null
#var l_gun = -1
var l_body = 0

func _ready():
	server = get_node("/root/Server").get_children()[0]


func setAvatar(index):
	if index==l_body: return
	add_child($Body.hotswap(index),true)
	l_body = index

func unpack(package):
	if last_position==null:
		setAvatar(get_node("/root/Server").get_player(package['id']).avatar)
		$Body.set_Hat(get_node("/root/Server").get_player(package['id']).hat)
	if (last_position == null || position.distance_to(last_position) >= 1):
		position = Vector2(package['x'],package['y'])
		last_position = position
	#if l_gun!=package['gun']:
	#	$Body.set_Gun(package['gun'])
	#	l_gun = package['gun']
	rotation = package['r']
	velocity = Vector2(package['vx'],package['vy'])
	rotvel = package['vr']
	#we don't let the client set the health- the server knows better
	lookoffset = Vector2(package['lx'],package['ly'])
	id = package['id']
	

func _process(delta):
	$Body.set_walk_vel(velocity)

func _physics_process(delta):
	velocity = move_and_slide(velocity)
	rotate(rotvel*delta)

func damage():
	$Body.ouch()
	
func die():
	dying = true
	velocity = Vector2.ZERO
	get_node("CollisionShape2D").disabled = true#disable collisions and begin dying
	$Body.rip()
	var _timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "finish_dying")
	_timer.set_wait_time(1.5)#normally wait for the animation to finish
	_timer.start()

func finish_dying():
	server.gameinstance.players.erase(id)
	get_parent().remove_child(self)
	queue_free()


