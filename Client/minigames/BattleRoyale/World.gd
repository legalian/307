extends "res://minigame.gd"
var path = "res://objects"

var world_type = 'battle_royale'

var players = {}
var bullets = {}
var powerups = {}

var cameraSet = false;
var startedDrop = false;
var camera = null
var world = null
var server = null
var dropFinished = false;
var theMap = "Grass"

func _ready():
	minigame = "BATTLEROYALE"
	camera = find_node("Camera2D");
	get_node("minigameselection")._Select_Minigame(1);

func load_map(map):
	print(map)
	if map == "Grass":
		world = preload("res://minigames/BattleRoyale/World-Grass.tscn").instance()
		theMap = "Grass"
		
	elif map == "Desert":
		world = preload("res://minigames/BattleRoyale/World-Desert.tscn").instance()
		theMap = "Desert"
	assert(world != null)
	add_child(world)
	world.visible = false;
					
	set_process(true)

func load_mapRoll(mapRoll):
	get_node("mapselection").spin = mapRoll;

func _process(delta):
	if(get_node("minigameselection").done == true && get_node("mapselection").done == false):
		get_node("mapselection").start();
		find_node("Camera2D").current = true;
		get_node("mapselection").visible = true;
		camera = find_node("Camera2D")
	if(get_node("mapselection").done == true && startedDrop == false):
		startedDrop = true;
		get_node("World/dropdown").start();
		camera = get_node("World/dropdown/camera")
		world.visible = true;
	if get_node("/root/Server").get_children().size()>0:
		server = get_node("/root/Server").get_children()[0]
	if server==null: 
		print("SERVER NULL\n")
		return
	if(get_node("mapselection").done == false):
		return;
	if(get_node("minigameselection").done == false):
		return;
	if(get_node("World/dropdown").spawned == false): 
		return;
	for p in players:
		players.get(p).visible = true;
	if camera==null:
		var player = get_node_or_null("World/Player")
		if player==null: return
		camera = player.find_node("Camera")
		if camera==null: return
		if(theMap == "Grass"):
			AudioPlayer.play_music("res://audio/music/unfoldingsecrets.ogg")
		else: 
			AudioPlayer.play_music("res://audio/music/tomorrow.ogg")

	
	var ctr = camera.global_rotation
	var xhalf = get_viewport().size.x/2
	var yhalf = get_viewport().size.y/2
	var pret = Transform2D(Vector2(1,0),Vector2(0,.44),Vector2(xhalf,yhalf))*Transform2D(-ctr,Vector2(0,0))
	var post = Transform2D(Vector2(1,0),Vector2(0,1),Vector2(-xhalf,-yhalf))
	get_viewport().canvas_transform = pret*get_viewport().canvas_transform*post
	rotation = ctr
	world.rotation = -ctr

	
