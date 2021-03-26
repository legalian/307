extends KinematicBody2D

const NUM_LAPS = 2

var maxSpeed = 1500
var speed = 0
var acceleration = 25
var rotSpeed = 2
var progress = 0.0
var place = 1
var finish_time = INF
var finished = false

var id
var velocity = Vector2.ZERO
var input_dict = {"rotating":0, "accelerating":0, "usingPowerup":false}

var hasSpeedPowerup = false
var cur_powerup = null

func pack():
	return {
		'id':id,
		'x':position.x,
		'y':position.y,
		'r':rotation,
		'place':place,
		'hasSpeedPowerup':hasSpeedPowerup,
		'powerup':cur_powerup
	}
	
func _ready():
	set_physics_process(false)

func _physics_process(delta):
	if progress <  NUM_LAPS + 1:
		if input_dict["accelerating"] == 0:
			speed = move_toward(speed, 0, 10)
		var rot_amount = input_dict["rotating"] * rotSpeed * delta
		if hasSpeedPowerup:
			rot_amount *= 1.5
		rotation += rot_amount
		speed += input_dict["accelerating"]*acceleration
	else:
		if finished == false:
			finish_time = OS.get_ticks_msec()
			finished = true
		speed = move_toward(speed, 0, 50)
	
	speed = clamp(speed, -maxSpeed, maxSpeed)
	velocity = Vector2(0, speed).rotated(rotation)
	if hasSpeedPowerup:
		velocity *= 2
	move_and_slide(velocity)
	
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.name.begins_with("Powerup"):
			collision.collider.use(self)
			break;

func interrupt():
	speed = 0

func stun(duration):
	# Somehow stop the car's movements.
	
	var timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "cleanse")
	timer.set_wait_time(duration)
	timer.set_one_shot(true)
	timer.start()

func cleanse():
	# Restore any changes from stun() back to normal.
	# Should be called from stun's timer hookup.
	pass

func gain_speed_powerup(duration):
	hasSpeedPowerup = true
	
	var timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "lose_speed_powerup")
	timer.set_wait_time(duration)
	timer.set_one_shot(true)
	timer.start()
	
func lose_speed_powerup():
	hasSpeedPowerup = false
