extends "res://minigame.gd"
var path = "res://objects"
var objectsPath = "res://minigames/racing/objects"

var world_type = 'racing_game'

enum Object_ids {TREE, FENCE, CAR, FENCE2, FLAG, STARTLINE, CACTUS}

var camera = null
var world = null
var server = null
var players = {}

var player
var gui
var object_map = null
var object_scenes = {}
var setCamera = false;

func _ready():	
	minigame = "RACINGGAME"
	
	object_scenes[Object_ids.FENCE] = preload("res://minigames/RacingGame/objects/fence.tscn")
	object_scenes[Object_ids.CAR] = preload("res://minigames/RacingGame/objects/racingCar.tscn")
	object_scenes[Object_ids.TREE] = preload("res://objects/tree1.tscn")
	object_scenes[Object_ids.FLAG] = preload("res://minigames/RacingGame/objects/flag.tscn")
	object_scenes[Object_ids.CACTUS] = preload("res://objects/cactus_tall.tscn")
	camera = find_node("Camera2D");
	get_node("minigameselection")._Select_Minigame(0);
	set_process(false)
	


func load_mapRoll(mapRoll):
	get_node("mapselection").spin = mapRoll;

func load_map(map):
	if map == "Grass":
		world = preload("res://minigames/RacingGame/World-Grass.tscn").instance()
	elif map == "Desert":
		world = preload("res://minigames/RacingGame/World-Desert.tscn").instance()
	elif map == "Candy":
		world = preload("res://minigames/RacingGame/World-Candy.tscn").instance();
	assert(world != null)
	add_child(world)
	world.visible = false;
	
	object_map = world.get_node("Objects")
	object_map.visible = false
	
	for id in Object_ids.values():
		if object_scenes.has(id):
			var positions = object_map.get_used_cells_by_id(id)
			for obj in positions:
				var instance = object_scenes[id].instance()
				instance.position = object_map.map_to_world(obj)
				world.add_child(instance)
				if id == Object_ids.FENCE:
					var transposed = object_map.is_cell_transposed(obj[0], obj[1])
					var flipx = object_map.is_cell_x_flipped(obj[0], obj[1])
					var flipy = object_map.is_cell_y_flipped(obj[0], obj[1])
					if transposed:
						if flipx:
							instance.rotate(PI/2.0)
						elif flipy:
							instance.rotate(3.0*PI/2.0)
							instance.translate(Vector2(object_map.cell_size.x, 0))
					else:
						if flipx and flipy:
							instance.rotate(PI)
						else:
							instance.translate(Vector2(0,object_map.cell_size.y))
					
	set_process(true)

func _process(delta):
	if(get_node("minigameselection").done == true && get_node("mapselection").done == false):
		get_node("mapselection").start();
		find_node("Camera2D").current = true;
		get_node("mapselection").visible = true;
		camera = find_node("Camera2D")
	if(get_node("mapselection").done == true && setCamera == false):
		setCamera = true;
		world.visible = true;
		camera = null;
	if get_node("/root/Server").get_children().size()>0:
		server = get_node("/root/Server").get_children()[0]
	if(get_node("mapselection").done == false):
		return;
	if server==null: return
	if camera==null:
		player = get_node_or_null("World/Player_" + str(get_tree().get_network_unique_id()))
		if player==null: return
		camera = player.find_node("Camera")
		camera.current = true
		AudioPlayer.play_music("res://audio/music/racing.ogg")
		if camera==null: return
	
	if gui==null && player != null:
		
		gui = player.find_node("GUI")
		gui.visible = true
		gui.get_node("Countdown").start();
	#print("Progress="+str(player.progress)+", Checkpoint="+str(player.checkpoint)+", Lap="+str(player.lap))
	
	var ctr = camera.global_rotation
	var xhalf = get_viewport().size.x/2
	var yhalf = get_viewport().size.y/2
	var pret = Transform2D(Vector2(1,0),Vector2(0,.44),Vector2(xhalf,yhalf))*Transform2D(-ctr,Vector2(0,0))
	var post = Transform2D(Vector2(1,0),Vector2(0,1),Vector2(-xhalf,-yhalf))
	get_viewport().canvas_transform = pret*get_viewport().canvas_transform.scaled(Vector2(0.7,0.7))*post
	rotation = ctr
	world.rotation = -ctr

