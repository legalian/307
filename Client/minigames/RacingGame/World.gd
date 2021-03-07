extends "res://minigame.gd"
var path = "res://objects"
var objectsPath = "res://minigames/racing/objects"

# Declare member variables here. Examples:
enum Object_ids {TREE, FENCE, CAR, FENCE2, FLAG}

var camera = null
var world = null
#var playerInfo = players[0];
var player
var object_map = null
var object_scenes = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	minigame = "RACINGGAME"
	world = get_node("World")
	player = find_node("Player")
	camera = player.get_node("Camera")
	camera.current = true
	#get_viewport().canvas_transform = get_viewport().canvas_transform.scaled(Vector2(2,1))
	
	object_scenes[Object_ids.FENCE] = preload("res://minigames/RacingGame/objects/fence.tscn")
	object_scenes[Object_ids.CAR] = preload("res://minigames/RacingGame/objects/racingCar.tscn")
	object_scenes[Object_ids.TREE] = preload("res://objects/tree1.tscn")
	object_scenes[Object_ids.FLAG] = preload("res://minigames/RacingGame/objects/flag.tscn")
	object_map = find_node("Objects")
	object_map.visible = false
	
	for id in Object_ids.values():
		if object_scenes.has(id):
			var positions = object_map.get_used_cells_by_id(id)
			if(id == 1):
				for obj in positions:
					var fences = object_scenes[Object_ids.FENCE].instance()
					fences.position = object_map.map_to_world(obj)
					if(object_map.is_cell_transposed(obj[0], obj[1])):
						fences.rotate(PI / 2)
					world.add_child(fences)
					

			else:	
				for obj in positions:
					var instance = object_scenes[id].instance()
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
