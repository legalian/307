extends "res://minigame.gd"

var world_type = 'demo_derby'

enum Object_ids {TREE, FENCE, CAR, FENCE2} # Removed FLAG

var camera = null
var world = null
var server = null
var players = {}

var player
var gui
var object_map = "Grass"
var object_scenes = {}

func _ready():
	minigame = "DEMODERBY"
	world = get_node("World" + object_map);
	object_scenes[Object_ids.FENCE] = preload("res://minigames/DemoDerby/assets/entities/fence.tscn")
	object_scenes[Object_ids.CAR] = preload("res://minigames/DemoDerby/assets/entities/racingCar.tscn")
	object_scenes[Object_ids.TREE] = preload("res://objects/tree1.tscn")
	#object_scenes[Object_ids.FLAG] = preload("res://minigames/RacingGame/objects/flag.tscn")
	object_map = find_node("Objects")
	object_map.visible = false
	
	for id in Object_ids.values():
		if object_scenes.has(id):
			var positions = object_map.get_used_cells_by_id(id)
			if(id == 1):
				for obj in positions:
					var fences = object_scenes[Object_ids.FENCE].instance()
					fences.position = object_map.map_to_world(obj)
					if(object_map.is_cell_transposed(obj[0], obj[1])) :	
						fences.rotate(PI / 2)
					world.add_child(fences)
					

			else:	
				for obj in positions:
					var instance = object_scenes[id].instance()
					instance.position = object_map.map_to_world(obj)
					world.add_child(instance)


func _process(delta):
	if get_node("/root/Server").get_children().size()>0:
		server = get_node("/root/Server").get_children()[0]
	if server==null: return
	if camera==null:
		player = get_node_or_null("World/Player_" + str(get_tree().get_network_unique_id()))
		if player==null: return
		camera = player.find_node("Camera")
		camera.current = true
		if camera==null: return
	
	if gui==null:
		gui = player.find_node("GUI")
		gui.visible = true
	#print("Progress="+str(player.progress)+", Checkpoint="+str(player.checkpoint)+", Lap="+str(player.lap))
	
	var ctr = camera.global_rotation
	var xhalf = get_viewport().size.x/2
	var yhalf = get_viewport().size.y/2
	var pret = Transform2D(Vector2(1,0),Vector2(0,.44),Vector2(xhalf,yhalf))*Transform2D(-ctr,Vector2(0,0))
	var post = Transform2D(Vector2(1,0),Vector2(0,1),Vector2(-xhalf,-yhalf))
	get_viewport().canvas_transform = pret*get_viewport().canvas_transform.scaled(Vector2(0.7,0.7))*post
	rotation = ctr
	world.rotation = -ctr
