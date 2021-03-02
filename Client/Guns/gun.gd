tool
extends Node2D

export var sideoffset = 0

var sprite
var viscontainer
var posfix
var flare

func _ready():
	set_process(true)
	sprite = get_node("Visible/Sprite")
	viscontainer = get_node("Visible")
	posfix = get_node("PositionFix")
	flare = get_node("PositionFix/Flare")

func _process(delta):
	var glt = get_global_transform_with_canvas()
	var mobo = glt.get_rotation()
	if mobo>PI: mobo-=2*PI
	if mobo<-PI: mobo+=2*PI
	var rang = 1.5
	var gltp = max(-rang,min(rang,mobo))
	var diffapply = atan2(sin(gltp)*.44,cos(gltp))-gltp
	mobo += diffapply
	gltp += diffapply
	var slr = mobo-gltp
	
	gltp = gltp+PI
	sprite.frame = 63-(int(round(64+64*gltp/(2*PI)))%64);
	gltp = int(round(64*gltp/(2*PI)))*(2.0*PI/64.0)
	
	glt.origin = Vector2(0,0);
	var invscale = 1/(glt[0][0]*glt[1][1]-glt[1][0]*glt[0][1])
	glt = glt.scaled(Vector2(invscale,invscale))
	
	var compensator = Transform2D(0,Vector2(sin(gltp)*sideoffset,cos(gltp)*sideoffset*(-0.44)))
	var additional = Transform2D(slr,Vector2(0,0))
	
	viscontainer.transform = glt.affine_inverse()*additional*compensator;

	posfix.transform = glt.affine_inverse()*Transform2D(slr,Vector2(0,0))*Transform2D(glt.get_rotation()-slr,Vector2(
		posfix.hookY*sin(gltp),
		posfix.hookY*(-0.44)*cos(gltp)+
		posfix.hookX
	))

func fire():
	flare.fire()







