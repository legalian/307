tool
extends Node2D

export var sideoffset = 0

var Bullet = preload("res://Guns/BasicRedBullet.tscn")
var server = null
var firingSound = null;

func _ready():
	set_process(true)
	
func fireSound():
	if(firingSound != null):
		AudioPlayer.play_sfx(firingSound)
		
		#audio player fires a sound

func _process(_delta):
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
	$Visible/Sprite.frame = 63-(int(round(64+64*gltp/(2*PI)))%64);
	gltp = int(round(64*gltp/(2*PI)))*(2.0*PI/64.0)
	
	glt.origin = Vector2(0,0);
	var invscale = 1/(glt[0][0]*glt[1][1]-glt[1][0]*glt[0][1])
	glt = glt.scaled(Vector2(invscale,invscale))
	
	var compensator = Transform2D(0,Vector2(sin(gltp)*sideoffset,cos(gltp)*sideoffset*(-0.44)))
	var additional = Transform2D(slr,Vector2(0,0))
	
	$Visible.transform = glt.affine_inverse()*additional*compensator;

	$PositionFix.transform = glt.affine_inverse()*Transform2D(slr,Vector2(0,0))*Transform2D(glt.get_rotation()-slr,Vector2(
		$PositionFix.hookY*sin(gltp),
		$PositionFix.hookY*(-0.44)*cos(gltp)+
		$PositionFix.hookX
	))



func bulletAt(var origpl,var targetpos,var simple,var altangle=0):
	if server==null: server = get_node("/root/Server").get_children()[0]
	var b = Bullet.instance()
	b.simple = simple
	var parent = origpl.get_parent()
	parent.add_child(b)
	#b.transform = parent.global_transform.affine_inverse()*posfix.global_transform*Transform2D(-PI/2,Vector2(0,0))
	b.position = parent.global_transform.xform_inv($PositionFix.global_position)#*posfix.global_transform*Transform2D(-PI/2,Vector2(0,0))
	b.rotation = (b.position-targetpos.global_position).angle()+altangle
	b.position -= Vector2(0,-90/.44).rotated(origpl.rotation+altangle)
	
	#b.start()
	
	randomize()
	var code = int(rand_range(100000, 999999))
	while (code in server.gameinstance.bullets):
		code = int(rand_range(100000, 999999))
	b.id = code
	server.gameinstance.bullets[b.id] = b
	server.shoot(b.pack())




