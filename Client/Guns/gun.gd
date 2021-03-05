tool
extends Node2D

export var sideoffset = 0

var Bullet = preload("res://Guns/BasicRedBullet.tscn")
var sprite
var viscontainer
var posfix
var flare
var server

func _ready():
	set_process(true)
	sprite = get_node("Visible/Sprite")
	viscontainer = get_node("Visible")
	posfix = get_node("PositionFix")
	flare = get_node("PositionFix/Flare")
	server = get_node("/root/Server").get_children()[0]

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

func fire(var origpl,var targetpos):
	var b = Bullet.instance()
	var parent = origpl.get_parent()
	#b.transform = parent.global_transform.affine_inverse()*posfix.global_transform*Transform2D(-PI/2,Vector2(0,0))
	b.position = parent.global_transform.xform_inv(posfix.global_position)#*posfix.global_transform*Transform2D(-PI/2,Vector2(0,0))
	b.rotation = (b.position-targetpos).angle()
	b.position -= Vector2(0,-90/.44).rotated(origpl.rotation)
	
	parent.add_child(b)
	#b.start()
	flare.fire()
	
	randomize()
	var code = int(rand_range(100000, 999999))
	while (code in server.gameinstance.bullets):
		code = int(rand_range(100000, 999999))
	b.id = code
	server.gameinstance.bullets[b.id] = b
		
	return b
	
	
	








