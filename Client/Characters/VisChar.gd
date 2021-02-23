tool
extends Node2D

export(float) var thresh
export(NodePath) var orient
var left = false
var discrim = null

# Called when the node enters the scene tree for the first time.
func _ready():
	#set_process(true)
	discrim = get_node(orient)
func isFacingLeft():
	return discrim.position.x>=thresh
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	left = 
