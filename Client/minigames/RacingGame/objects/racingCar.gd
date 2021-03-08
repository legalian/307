extends KinematicBody2D

var server = null
var id
var input_vector = Vector2.ZERO

func _ready():
	server = get_node("/root/Server").get_children()[0]

func unpack(package):
	position = Vector2(package['x'],package['y'])
	rotation = package['r']
	id = package['id']

func _process(delta):
	input_vector = Vector2.ZERO

	if Input.is_action_pressed("move_right"):input_vector.x += 1
	if Input.is_action_pressed("move_left"):input_vector.x -= 1
	if Input.is_action_pressed("move_down"):input_vector.y += 1
	if Input.is_action_pressed("move_up"):input_vector.y -= 1
