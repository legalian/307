extends "res://scripts/MinigameServers/MinigameBase.gd"

var gameinstance

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	gameinstance = get_tree().get_root().get_node_or_null("/root/WorldContainer")
	if gameinstance!=null && gameinstance.get('world_type')!='map_selection': gameinstance = null


remote func setSpin(spins):
	if gameinstance == null: return;
	gameinstance.spin = spins;
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
