extends KinematicBody2D

var id

var velocity = Vector2.ZERO
var rotvel = 0
var lookoffset = Vector2.ZERO

var last_position
var dying = false
var server = null

func _ready():
	server = get_node("/root/Server").get_children()[0]

func unpack(package):
	if (last_position == null || position.distance_to(last_position) >= 1):
		position = Vector2(package['x'],package['y'])
		last_position = position
	rotation = package['r']
	velocity = Vector2(package['vx'],package['vy'])
	rotvel = package['vr']
	#we don't let the client set the health- the server knows better
	lookoffset = Vector2(package['lx'],package['ly'])
	id = package['id']

func _process(delta):
	$Body.set_look_pos(get_parent().global_transform.xform(lookoffset+global_position))

func _physics_process(delta):
	velocity = move_and_slide(velocity)
	rotate(rotvel*delta)

func damage():
	print("Damage taken from bullet")
	pass#this is where an animation would go
	
func die():
	dying = true
	get_node("CollisionShape2D").disabled = true#disable collisions and begin dying
	#$Body.die_anim()
	var _timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "finish_dying")
	_timer.set_wait_time(0.05)#normally wait for animation to finish
	_timer.start()

func finish_dying():
	server.gameinstance.players.erase(id)
	get_parent().remove_child(self)
	queue_free()


