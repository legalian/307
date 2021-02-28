tool
extends Node2D


var animPlayer = null
var headRef = null

func _ready():
	set_process(true)
	animPlayer = get_node("AnimationTree")
	headRef = find_node("Headref")

func _process(delta):
	var glt = get_global_transform_with_canvas()
	var cpos = headRef.global_position-get_global_mouse_position()
	cpos.x = cpos.x*-1
	var rot = cpos.angle()
	animPlayer.set("parameters/lookX/seek_position", .5+.5*cos(rot))
	animPlayer.set("parameters/lookY/seek_position", .5+.5*sin(rot))
	glt.origin = Vector2(0,0);
	get_node("Char").transform = glt.affine_inverse();

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
