extends Label

var server
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var id = get_parent().TargetNode.id;
	var carName = id;
	self.text = carName;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var id = get_parent().TargetNode.id;
	var carName = id;
	self.text = carName
