extends KinematicBody2D

var server = null
var id
var input_vector = Vector2.ZERO
var checkpoint = 0.0
#var checkpoint = 0.95
var num_checkpoints = 20
var checkpoint_div = 1/float(num_checkpoints) # originally 1
var progress = 0.0
var lap = 1
#var lap = 2
var place = 1

var path
var path_length
var gui
var laps_label
var place_label
var scoreboard

func _ready():
	server = get_node("/root/Server").get_children()[0]
	path = get_parent().get_node("TrackPath")
	path_length = path.curve.get_baked_length()
	gui = find_node("GUI")
	laps_label = gui.find_node("laps")
	place_label = gui.find_node("place")
	scoreboard = gui.find_node("scoreboard")

func unpack(package):
	position = Vector2(package['x'],package['y'])
	rotation = package['r']
	id = package['id']
	place = package['place']

func _process(delta):
	input_vector = Vector2.ZERO

	if Input.is_action_pressed("move_right"):input_vector.x += 1
	if Input.is_action_pressed("move_left"):input_vector.x -= 1
	if Input.is_action_pressed("move_down"):input_vector.y += 1
	if Input.is_action_pressed("move_up"):input_vector.y -= 1
	
	progress = path.curve.get_closest_offset(position)/path_length
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
		
	
