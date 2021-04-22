extends KinematicBody2D

var server = null
var id
var input_dict = {"rotating":0, "accelerating":0, "usingPowerup":false}
var hasSpeedPowerup = false
var cur_powerup = null
var checkpoint = 0.0
#var checkpoint = 0.95
var num_checkpoints = 20
var checkpoint_div = 1/float(num_checkpoints) # originally 1
var progress = 0.0
var lap = 1
#var lap = 2
var place = 1
var health = 100

var playCollisionSFX = true
var collisionTimer

var path
var path_length
var gui
var scoreboard
var powerup_icon

var particles
var car_material

func _ready():
	server = get_node("/root/Server").get_children()[0]
	gui = find_node("GUI")
	scoreboard = gui.find_node("scoreboard")
	powerup_icon = gui.find_node("PowerupIcon")
	particles = $Particles2D
	car_material = find_node("Sprite").get_material()
	
	collisionTimer = Timer.new()
	add_child(collisionTimer)
	collisionTimer.connect("timeout", self, "set", ["playCollisionSFX", true])
	collisionTimer.set_wait_time(1)
	collisionTimer.set_one_shot(true)

func unpack(package):
	position = Vector2(package['x'],package['y'])
	rotation = package['r']
	id = package['id']
	place = package['place']
	hasSpeedPowerup = package['hasSpeedPowerup']
	if cur_powerup != package['powerup'] and powerup_icon != null:
		cur_powerup = package['powerup']
		powerup_icon.changePowerup(cur_powerup)
		if package['powerup'] != null:
			AudioPlayer.play_sfx("res://audio/sfx/powerup.ogg")
	health = package['health']
	get_node("Camera/CanvasLayer/GUI/HealthBar").set_value(health)
	
	visible = package['visible']
	if (!visible):
		get_node("CollisionShape2D").disabled = true

func _process(delta):
	input_dict = {"rotating":0, "accelerating":0, "usingPowerup":false}

	if Input.is_action_pressed("move_right"):input_dict["rotating"] += 1
	if Input.is_action_pressed("move_left"):input_dict["rotating"] -= 1
	if Input.is_action_pressed("move_down"):input_dict["accelerating"] += 1
	if Input.is_action_pressed("move_up"):input_dict["accelerating"] -= 1
	if Input.is_action_pressed("use_powerup"):input_dict["usingPowerup"] = true
	
	
	particles.emitting = hasSpeedPowerup
	car_material.set_shader_param("hasSpeedPowerup", hasSpeedPowerup)
	
func _physics_process(delta):
	if id != Server.selfplayer.playerID: return
	var col = move_and_collide(Vector2.ZERO, true, true, true)
	if col == null: return
	if col.collider.name.begins_with("Player"):
		playCollideSFX()

func playCollideSFX():
	if playCollisionSFX:
		AudioPlayer.play_sfx("res://audio/sfx/carcrash.ogg")
		playCollisionSFX = false
		collisionTimer.start()
