extends "res://minigame.gd"
var path = "res://objects"

var world_type = 'battle_royale'

var players = {}
var bullets = {}
var powerups = {}

var camera = null
var world = null
var server = null

func _ready():
	world = get_node("World")
	minigame = "BATTLEROYALE"
	camera = get_node("World/dropdown/camera");

	
	
func _process(delta):
	if get_node("/root/Server").get_children().size()>0:
		server = get_node("/root/Server").get_children()[0]
	if server==null: return
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

	
