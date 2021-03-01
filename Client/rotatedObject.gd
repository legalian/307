tool
extends Node2D


func _ready():
	set_process(true)

func _process(delta):
	#set_rotation(get_rotation() + delta * 5)
	var glt = get_global_transform_with_canvas()
	var gltp = atan2(glt[0][1]*.44,glt[0][0])
	get_node("Visible/Sprite").frame = 63-(int(64+64*gltp/(2*PI))%64);
	
	glt.origin = Vector2(0,0);
	var invscale = 1/(glt.get_scale().x*glt.get_scale().y)
	glt = glt.scaled(Vector2(invscale,invscale))
	get_node("Visible").transform = glt.affine_inverse();

