extends YSort


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var camera = null
# Called when the node enters the scene tree for the first time.
func _ready():
	camera = find_node("Camera")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#pass
	#var glob = 
	#glob.origin = Vector2.ZERO
	transform = camera.get_global_transform().affine_inverse()*transform


