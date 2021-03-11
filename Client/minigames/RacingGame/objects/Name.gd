extends Label

var server = get_node("/root/Server").get_children()[0]
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var id = get_parent().TargetNode.id;
	var carName = server.get_player(id).username;
	self.text = carName;

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
