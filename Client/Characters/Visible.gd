extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)

func _process(delta):
	#set_rotation(get_rotation() + delta * 5)
	var glt = get_global_transform_with_canvas()
	glt.origin = Vector2(0,0);
	get_node("Char").transform = glt.affine_inverse();


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
