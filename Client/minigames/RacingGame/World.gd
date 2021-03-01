extends "res://minigame.gd"
var path = "res://objects"
var objectsPath = "res://minigames/racing/objects"

# Declare member variables here. Examples:
enum Objects {TREE, FENCE, CAR}

var camera = null
var world = null
var object_map = null
# Called when the node enters the scene tree for the first time.
func _ready():
	minigame = "RACINGGAME"
	camera = find_node("Camera")
	world = get_node("World")
	#get_viewport().canvas_transform = get_viewport().canvas_transform.scaled(Vector2(2,1))
	
	var car = preload("res://car.tscn")
	
	object_map = find_node("Objects")
	object_map.visible = false
	var car_positions = object_map.get_used_cells_by_id(Objects.CAR)
	for obj in car_positions:
		var instance = car.instance()
		instance.position = object_map.map_to_world(obj)
		world.add_child(instance)
	var fence = preload("objects/fence.tscn")
	var fence_positions = object_map.get_used_cells_by_id(Objects.FENCE)
	for obj in fence_positions:
		var instance = fence.instance()
		instance.position = object_map.map_to_world(obj)
		world.add_child(instance)
	
	
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#pass
	#var glob = 
	#glob.origin = Vector2.ZERO
	#transform = camera.get_global_transform().affine_inverse()*transform
	var xhalf = get_viewport().size.x/2
	var yhalf = get_viewport().size.y/2
	var pret = Transform2D(Vector2(1,0),Vector2(0,.44),Vector2(xhalf,yhalf))*Transform2D(-camera.rotation,Vector2(0,0))
	var post = Transform2D(Vector2(1,0),Vector2(0,1),Vector2(-xhalf,-yhalf))
	get_viewport().canvas_transform = pret*get_viewport().canvas_transform*post
	rotation = camera.rotation
	world.rotation = -camera.rotation
	
	#get_viewport().canvas_transform = get_viewport().canvas_transform.scaled(Vector2(2,1))
