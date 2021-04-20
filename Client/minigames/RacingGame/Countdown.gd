extends Label

var count = 5
var timer

func start():
	timer.start()
	
	$Tween.start()

func _ready():
	$Tween.interpolate_property(self, "modulate:a", 1, 0, 1, Tween.TRANS_QUAD)
	$Tween.set_repeat(true)
	
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "tick")
	timer.set_wait_time(1)
	timer.set_one_shot(false)


func tick():
	count -= 1
	if count == 0:
		AudioPlayer.play_sfx("res://audio/sfx/countdown_go.ogg")
		set_text("GO!")
	elif count < 0:
		timer.stop()
		set_visible(false)
	elif count > 0 and count < 4:
		AudioPlayer.play_sfx("res://audio/sfx/countdown_beep.ogg")
	else:
		set_text(str(count))
