extends "res://minigame.gd"
var path = "res://objects"

var world_type = 'battle_royale'

var players = {}
var bullets = {}
var powerups = {}

var startedDrop = false;
var camera = null
var world = null
var server = null
var dropFinished = false;

func _ready():
	world = get_node("World")
	minigame = "BATTLEROYALE"
	camera = get_node("mapselection/World/Camera2D");

func load_map(map):
	print(map)
	if map == "Grass":
		world = preload("res://minigames/BattleRoyale/World-Grass.tscn").instance()
	elif map == "Desert":
		world = preload("res://minigames/BattleRoyale/World-Desert.tscn").instance()
	assert(world != null)
	add_child(world)
	world.visible = false;
					
	set_process(true)

func load_mapRoll(mapRoll):
	get_node("mapselection").spin = mapRoll;

func _process(delta):
	if(get_node("mapselection").done == true && startedDrop == false):
		startedDrop = true;
		get_node("World/dropdown").start();
		camera = get_node("World/dropdown/camera")
		world.visible = true;
	if get_node("/root/Server").get_children().size()>0:
		server = get_node("/root/Server").get_children()[0]
	if server==null: return
	if(get_node("mapselection").done == false):
		return;
	if camera==null:
		var player = get_node_or_null("World/Player")
		if player==null: return
		camera = player.find_node("Camera")
		if camera==null: return
	
	var ctr = camera.global_rotation
	var xhalf = get_viewport().size.x/2
	var yhalf = get_viewport().size.y/2
	var pret = Transform2D(Vector2(1,0),Vector2(0,.44),Vector2(xhalf,yhalf))*Transform2D(-ctr,Vector2(0,0))
	var post = Transform2D(Vector2(1,0),Vector2(0,1),Vector2(-xhalf,-yhalf))
	get_viewport().canvas_transform = pret*get_viewport().canvas_transform*post
	rotation = ctr
	world.rotation = -ctr

	
