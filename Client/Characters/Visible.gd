extends Node2D


var animPlayer = null
var headRef = null
var lefthand = null
var righthand = null

func _ready():
	#set_Hat("res://Hats/Whitehat.tscn")
	set_process(true)
	animPlayer = get_node("AnimationTree")
	headRef = find_node("Headref")
	lefthand = find_node("LeftArmTarget")
	righthand = find_node("RightArmTarget")

func _process(delta):
	var glt = get_global_transform_with_canvas()
	glt.origin = Vector2(0,0)
	get_node("Char").transform = glt.affine_inverse()

func set_look_pos(gpos):
	#gpos.y/=.44
	var cpos = gpos-headRef.global_position
	#cpos.y*=.44
	var rot = -get_viewport().canvas_transform.scaled(Vector2(.44,1)).get_rotation()-cpos.angle()
	animPlayer.set("parameters/lookX/seek_position", .5+.5*cos(rot))
	animPlayer.set("parameters/lookY/seek_position", .5+.5*sin(rot))
	#gpos.y*=.44
	lefthand.global_position = gpos

func set_Hat(hatPath):
	var headbone = find_node("Head")
	var currentHat = headbone.get_node_or_null("Hat")
	if currentHat!=null:
		headbone.remove_child(currentHat)
		currentHat.queue_free()
	if hatPath != null:
		var newHat = load(hatPath).instance()
		newHat.name = "Hat"
		headbone.add_child(newHat,true)#second parameter is important here- must be true
		newHat.position = Vector2(0,-35)





