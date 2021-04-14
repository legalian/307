tool
extends Node2D

var pathdir = 0

func _ready():
	set_process(true)
	$Arrow/AnimationPlayer.play("Flash")

func _process(delta):
	var targpos = Vector2(0,-300)
	var diff = pathdir-global_rotation
	var desiredrotation = atan2(sin(diff)/.44,cos(diff))
	while diff>PI:diff-=2*PI
	while diff<-PI:diff+=2*PI
	$Arrow.visible = (diff<-1.0472 or diff>1.0472)
	
	
	var glt = get_global_transform()
	glt.origin = Vector2(0,0);
	var invscale = 1/(glt[0][0]*glt[1][1]-glt[1][0]*glt[0][1])
	glt = glt.scaled(Vector2(invscale,invscale))
	#glt.affine_inverse()*\
	$Arrow.transform = \
	Transform2D(0,targpos)*\
	Transform2D(Vector2(1,0),Vector2(0,.44),Vector2(0,0))*\
	Transform2D(desiredrotation,Vector2(0,0))
	
