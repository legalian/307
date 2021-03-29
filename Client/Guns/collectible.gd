tool
extends Node2D

var time = 0

var gunmap = {2:'greenUzi',3:'purpleDualGun'}

func _ready():
	set_process(true)

func _process(delta):
	time = time+delta
	#var glt = get_global_transform_with_canvas()
	#var gltp = glt.get_rotation()#+time*4
	var glt = get_global_transform_with_canvas()
	var gltp = atan2(glt[0][1]/.44,glt[0][0])+time*4
	$Visible/Sprite.frame = 63-(int(round(64+64*gltp/(2*PI)))%64);
	$Visible/Sprite.position.y = -70+40*sin(time*2)
	
	glt.origin = Vector2(0,0);
	var invscale = 1/(glt[0][0]*glt[1][1]-glt[1][0]*glt[0][1])
	glt = glt.scaled(Vector2(invscale,invscale))
	$Visible.transform = glt.affine_inverse();
	

func unpack(packed):
	$Visible/Sprite.animation = gunmap[packed['gun']]
	position = Vector2(packed['x'],packed['y'])

