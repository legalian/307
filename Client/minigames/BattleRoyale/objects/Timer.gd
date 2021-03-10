extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.get_child(0).start(5);	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.text = str(self.get_child(0).time_left).left(1);
