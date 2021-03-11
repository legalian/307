tool
extends Node2D


func _ready():
	set_process(true)

func _process(delta):
	if !$VisibilityNotifier.is_on_screen(): return
	#set_rotation(get_rotation() + delta * 5)
	var glt = get_global_transform_with_canvas()
	var gltp = atan2(glt[0][1]/.44,glt[0][0])
	$Visible/Sprite.frame = 63-(int(64+64*gltp/(2*PI))%64);
	
	glt.origin = Vector2(0,0);
	var invscale = 1/(glt[0][0]*glt[1][1]-glt[1][0]*glt[0][1])
	glt = glt.scaled(Vector2(invscale,invscale))
	$Visible.transform = glt.affine_inverse();

