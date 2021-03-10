tool
extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	var glt = get_global_transform_with_canvas()
	glt.origin = Vector2(0,0)
	#var rot = glt.get_rotation()
	var rot = atan2(glt[0][1]/.44,glt[0][0])
	get_node("Visible").transform = glt.affine_inverse()*Transform2D(Vector2(cos(rot),.44*sin(rot)),Vector2(0,1),Vector2(0,0))
	

