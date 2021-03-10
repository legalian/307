extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var timer

# Called when the node enters the scene tree for the first time.
func _on_timer_timeout():
	
	
func _ready():
	timer = Timer.new()
	timer.connect("timeout",self,"_on_timer_timeout")
	add_child(timer)
	timer.start(5);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.text = timer.left(1);
