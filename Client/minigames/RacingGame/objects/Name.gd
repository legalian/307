extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var car_name
# Called when the node enters the scene tree for the first time.
func _ready():
	car_name = get_parent().TargetNode.id;
	self.text = str(car_name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
