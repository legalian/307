extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var timer

# Called when the node enters the scene tree for the first time.
func _on_timer_timeout():
	get_parent().get_parent().current = false;
	get_parent().get_parent().get_parent()._spawnRandom();
	
func _ready():
	self.visible = false;
	timer = Timer.new()
	timer.one_shot = true;
	timer.connect("timeout",self,"_on_timer_timeout")
	add_child(timer)

func start():
	self.visible = true;
	timer.start(5);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.text = str(timer.time_left).left(1);
