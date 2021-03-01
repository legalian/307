tool
extends Node2D

export var sideoffset = 0

func _ready():
	set_process(true)

func _process(delta):
	var glt = get_global_transform_with_canvas()
	#var mobo = global_rotation
	#var gltp = atan2(glt[0][1]/.44,glt[0][0])
	var mobo = global_rotation+get_viewport().canvas_transform.scaled(Vector2(.44,1)).get_rotation()
	if mobo>PI: mobo-=2*PI
	if mobo<-PI: mobo+=2*PI
	var rang = 1.5
	var gltp = max(-rang,min(rang,mobo))
	var diffapply = atan2(sin(gltp)*.44,cos(gltp))-gltp
	mobo += diffapply
	gltp += diffapply
	var slr = mobo-gltp#atan2(.44*sin(mobo)-cos(mobo)*.44*tan(gltp),cos(mobo))
	
	gltp = gltp+PI
	get_node("Visible/Sprite").frame = 63-(int(64+64*gltp/(2*PI))%64);
	
	glt.origin = Vector2(0,0);
	var invscale = 1/(glt.get_scale().x*glt.get_scale().y)
	glt = glt.scaled(Vector2(invscale,invscale))
	
	var compensator = Transform2D(0,Vector2(sin(gltp)*sideoffset,cos(gltp)*sideoffset*(-0.44)))
	var additional = Transform2D(slr,Vector2(0,0))
	
	get_node("Visible").transform = glt.affine_inverse()*additional*compensator;










