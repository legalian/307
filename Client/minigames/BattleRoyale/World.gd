extends YSort
var path = "res://objects"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var camera = null
# Called when the node enters the scene tree for the first time.
func _ready():
	var tree = load(path + "tree")	
	var tree1 = tree.instance()
	var root = get_node(".")
	root.add_child(tree1);
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#pass
	#var glob = 
	#glob.origin = Vector2.ZERO
	transform = camera.get_global_transform().affine_inverse()*transform


