extends YSort
var path = "res://objects"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var camera = null
var world = null
# Called when the node enters the scene tree for the first time.
func _ready():
	camera = find_node("Camera")
	world = get_node("World")
	#get_viewport().canvas_transform = get_viewport().canvas_transform.scaled(Vector2(2,1))



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#pass
	#var glob = 
	var ctr = camera.global_rotation
	#glob.origin = Vector2.ZERO
	#transform = camera.get_global_transform().affine_inverse()*transform
	var xhalf = get_viewport().size.x/2
	var yhalf = get_viewport().size.y/2
	var pret = Transform2D(Vector2(1,0),Vector2(0,.44),Vector2(xhalf,yhalf))*Transform2D(-ctr,Vector2(0,0))
	var post = Transform2D(Vector2(1,0),Vector2(0,1),Vector2(-xhalf,-yhalf))
	get_viewport().canvas_transform = pret*get_viewport().canvas_transform*post
	rotation = ctr
	world.rotation = -ctr
	
	#get_viewport().canvas_transform = get_viewport().canvas_transform.scaled(Vector2(2,1))

