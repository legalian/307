extends Label

var count = 5
var timer
var tween

func start():
	timer.start()
	
	tween.start()

func _ready():
	tween = get_node("Tween")
	tween.interpolate_property(self, "modulate:a", 1, 0, 1, Tween.TRANS_QUAD)
	tween.set_repeat(true)
	
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "tick")
	timer.set_wait_time(1)
	timer.set_one_shot(false)


func tick():
	count -= 1
	if count == 0:
		set_text("GO!")
	elif count < 0:
		timer.stop()
		set_visible(false)
	else:
		set_text(str(count))
