extends "res://minigame.gd"
var path = "res://objects"

var world_type = 'captcha'

var players = {}
var bullets = {}
var powerups = {}

var cameraSet = false;
var startedDrop = false;
var camera = null
var world = null
var server = null
var dropFinished = false;
var curQuestion = -1;
var curArrangement = [0,1,2,3,4,5,6,7,8];

func _ready():
	minigame = "CAPTCHA"
	camera = get_node("minigameselection/Camera2D");
	get_node("minigameselection")._Select_Minigame(1);

func load_map(map):
	print(map," is the selected map")
	world = preload("res://minigames/ConfusingCaptcha/World-Grass.tscn").instance()
	assert(world != null)
	add_child(world)
	world.visible = false;
	set_process(true)
	setArrangement(curQuestion,curArrangement)

func setArrangement(question_number,arrangement):
	if question_number==-1: return
	curQuestion = question_number
	curArrangement = arrangement
	if get_node_or_null('World')==null: return
	var tiles = [
		$World/R1C1,$World/R1C2,$World/R1C3,
		$World/R2C1,$World/R2C2,$World/R2C3,
		$World/R3C1,$World/R3C2,$World/R3C3,
	]
	for x in range(9):
		print(question_number," ",tiles[x].frames.get_animation_names())
		print(x,tiles[x].frames.get_animation_names()[question_number])
		print(arrangement[x])
		#tiles[x].play(tiles[x].frames.get_animation_names()[question_number])
		tiles[x].animation = tiles[x].frames.get_animation_names()[question_number]
		tiles[x].set_frame(arrangement[x])
		#tiles[x].stop()

func _process(delta):
	if world==null: return;
	if(get_node("minigameselection").done == true && cameraSet == false):
		camera = null;
		cameraSet = true;
		world.visible = true;
	if get_node("/root/Server").get_children().size()>0:
		server = get_node("/root/Server").get_children()[0]
	if server==null: 
		print("SERVER NULL\n")
		return
	if(get_node("minigameselection").done == false):
		return;
	if camera==null:
		var player = get_node_or_null("World/Player")
		if player==null: return
		camera = player.get_node("Camera")
		player.get_node("Camera").current = true;
		
		if camera==null: return
	if(world.visible == false):
		world.visible = true;
	#var ctr = camera.global_rotation
	#var xhalf = get_viewport().size.x/2
	#var yhalf = get_viewport().size.y/2
	#var pret = Transform2D(Vector2(1,0),Vector2(0,.44),Vector2(xhalf,yhalf))*Transform2D(-ctr,Vector2(0,0))
	#var post = Transform2D(Vector2(1,0),Vector2(0,1),Vector2(-xhalf,-yhalf))
	#get_viewport().canvas_transform = pret*get_viewport().canvas_transform*post
	#var t = Transform2D()
	#t.x *= 4
	#t.y *= 4
	#get_viewport().canvas_transform = t*get_viewport().canvas_transform
	#rotation = ctr
	#world.rotation = -ctr
