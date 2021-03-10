extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var car_name = get_parent().get_parent().id
# Called when the node enters the scene tree for the first time.
func _ready():
	self.text = car_name

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
