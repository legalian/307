extends KinematicBody2D

const NUM_LAPS = 2

var projectile = preload("res://RacingGame/PU_Proj.tscn")
var trap = preload("res://RacingGame/trap.tscn");

var maxSpeed = 1500
var speed = 0
var acceleration = 25
var rotSpeed = 2
var progress = 0.0
var place = 1
var finish_time = INF
var finished = false
var health = 100

var id
var velocity = Vector2.ZERO
var input_dict = {"rotating":0, "accelerating":0, "usingPowerup":false}

onready var server = get_parent().get_parent() # World.gd

var hasSpeedPowerup = false
var speed_timer = null

var cur_powerup = null

func pack():
	return {
		'id':id,
		'x':position.x,
		'y':position.y,
		'r':rotation,
		'place':place,
		'hasSpeedPowerup':hasSpeedPowerup,
		'powerup':cur_powerup,
		'health':health,
		'visible':visible
	}
	
func _ready():
	set_physics_process(false)
	
	speed_timer = Timer.new()
	add_child(speed_timer)
	speed_timer.connect("timeout", self, "lose_speed_powerup")
	speed_timer.set_one_shot(true)
	visible = true

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
			collision.collider.pickup(self)
			break;
		if (collision.collider.name.begins_with("Trap")) && (collision.collider.owner_id != id):
			stun(4, 500)
			damage(20)
		if (collision.collider.name.begins_with("Trap")) && (collision.collider.owner_id != id):
			stun(4, 500)
			damage(20)
			collision.collider.get_parent().remove_child(collision.collider)
		if collision.collider.name.begins_with("Player"):
			if abs(speed) > abs(collision.collider.speed):
				collision.collider.damage(abs(speed)/100.0)
				speed = -sign(speed)*800
			print("Car collided with another car")

func damage(amount):
	health -= amount
	if (health <= 0):
		#server.remove_player(id) # Remove from interal array
		# We don't want to remove from the array, otherwise
		# unpack() and pack() will not update information.
		# We could fix this in the client by removing all cars
		# and re-adding them so the client always has the 
		# latest info for the entire frame, but 
		# I'm not sure if this will break anything.
		server.die(id) # Commit sudoku
		get_node("CollisionShape2D").disabled = true
		visible = false # Remove from screen
		finished = true # Set this car as "finished"
		#queue_free()

func _process(delta):
	if input_dict["usingPowerup"] and cur_powerup != null:
		match cur_powerup:
			"speed":
				gain_speed_powerup(5)
			"missile":
				var proj_node = projectile.instance()
				proj_node.name = "Projectile " + str(proj_node.get_instance_id())
				#proj_node.position = position + Vector2(0, -100).rotated(rotation)
				#proj_node.rotation = rotation
				proj_node.owner_id = id
				proj_node.rotation = self.rotation - PI/2
				proj_node.position = Vector2(position.x  + 150 * cos(proj_node.rotation), position.y + 150 * sin(proj_node.rotation))
				get_parent().add_child(proj_node) # Add to World
			"trap":
				print("Placing a trap!")
				var trapInstance = trap.instance();
				trapInstance.name = "Trap " + str(trapInstance.get_instance_id())
				trapInstance.position = position;
				trapInstance.owner_id = id;
				get_parent().add_child(trapInstance)
		cur_powerup = null

func interrupt():
	speed = 0
	damage(20)

func stun(duration, speedMax):
	# Somehow stop the car's movements.
	cleanse();
	# Cleanse at start of stun, to prevent multiple effects from causing issues. 
	maxSpeed = speedMax;
	if(speed > maxSpeed): speed = maxSpeed;
	var timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "cleanse")
	timer.set_wait_time(duration)
	timer.set_one_shot(true)
	timer.start()

func cleanse():
	# Restore any changes from stun() back to normal.
	# Should be called from stun's timer hookup.
	maxSpeed = 1500;

func gain_speed_powerup(duration):
	hasSpeedPowerup = true
	
	speed_timer.start(duration)
	
func lose_speed_powerup():
	hasSpeedPowerup = false
