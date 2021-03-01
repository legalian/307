extends Node2D


var animPlayer = null
var headRef = null
var lefthand = null
var righthand = null

func _ready():
	set_process(true)
	animPlayer = get_node("AnimationTree")
	headRef = find_node("Headref")
	lefthand = find_node("LeftArmTarget")
	righthand = find_node("RightArmTarget")


func set_look_pos(gpos):
	var glt = get_global_transform_with_canvas()
	glt.origin = Vector2(0,0)
	get_node("Char").transform = glt.affine_inverse()

	var rot = -get_viewport().canvas_transform.scaled(Vector2(.44,1)).get_rotation()-(gpos-headRef.global_position).angle()
	animPlayer.set("parameters/lookX/seek_position", .5+.5*cos(rot))
	animPlayer.set("parameters/lookY/seek_position", .5+.5*sin(rot))
	
	lefthand.global_position = gpos







