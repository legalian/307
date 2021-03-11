extends Label

var count = 5
var timer

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "tick")
	timer.set_wait_time(1)
	timer.set_one_shot(false)
	timer.start()

func tick():
	count -= 1
	if count == 0:
		set_text("GO!")
	elif count < 0:
		timer.stop()
		set_visible(false)
	else:
		set_text(str(count)+"!")
