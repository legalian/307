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

var VehicleStyles = ["Sedan","Van","Truck","Race","Taxi","Ambulance","Hatchback","Police","Tractor","Garbage","Future","Firetruck"]

var path
var path_length
var gui
var laps_label
var place_label
var scoreboard
var powerup_icon

var particles
var car_material

func _ready():
	server = get_node("/root/Server").get_children()[0]
	path = get_parent().get_node("TrackPath")
	path_length = path.curve.get_baked_length()
	gui = find_node("GUI")
	laps_label = gui.find_node("laps")
	place_label = gui.find_node("place")
	scoreboard = gui.find_node("scoreboard")
	powerup_icon = gui.find_node("PowerupIcon")
	particles = $Particles2D
	car_material = find_node("Sprite").get_material()
	

func unpack(package):
	position = Vector2(package['x'],package['y'])
	rotation = package['r']
	id = package['id']
	place = package['place']
	hasSpeedPowerup = package['hasSpeedPowerup']
	if cur_powerup != package['powerup'] and powerup_icon != null:
		cur_powerup = package['powerup']
		powerup_icon.changePowerup(cur_powerup)
	if get_node_or_null("/root/Server") != null:
		if get_node("/root/Server").get_player(package['id']) != null:
			var VehicleSelected = get_node("/root/Server").get_player(package['id']).vehicle
			find_node("Sprite").animation = VehicleStyles[VehicleSelected]

func _process(delta):
	input_dict = {"rotating":0, "accelerating":0, "usingPowerup":false}

	if Input.is_action_pressed("move_right"):input_dict["rotating"] += 1
	if Input.is_action_pressed("move_left"):input_dict["rotating"] -= 1
	if Input.is_action_pressed("move_down"):input_dict["accelerating"] += 1
	if Input.is_action_pressed("move_up"):input_dict["accelerating"] -= 1
	if Input.is_action_pressed("use_powerup"):input_dict["usingPowerup"] = true
	
	var dist = path.curve.get_closest_offset(position)
	progress = dist/path_length
	
	$Arrowbase.visible = server.players[0].playerID == id
	$Arrowbase.pathdir = (path.curve.interpolate_baked(dist+6)-path.curve.interpolate_baked(dist-6)).angle()+PI/2
	
	var potential_checkpoint = progress - fmod(progress, checkpoint_div)
	if is_equal_approx(potential_checkpoint, checkpoint + checkpoint_div):
		checkpoint = potential_checkpoint
	elif is_equal_approx(potential_checkpoint, checkpoint + 2*checkpoint_div):
		checkpoint = potential_checkpoint
	elif is_equal_approx(potential_checkpoint, 0.0) and is_equal_approx(checkpoint, (1 - checkpoint_div)):
		checkpoint = 0.0
		lap += 1
	
	laps_label.currentLap = int(clamp(lap, 1, 2))
	place_label.rank = place
	
	particles.emitting = hasSpeedPowerup
	car_material.set_shader_param("hasSpeedPowerup", hasSpeedPowerup)
	
