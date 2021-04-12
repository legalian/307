extends Label

var time;
var tween

# Server sets the time, not the client. Since unlike racing or battle royale, time is much more important in this game. 

func start():
	tween.start()

func _ready():
	tween = get_node("Tween")
	tween.interpolate_property(self, "modulate:a", 1, 0, 1, Tween.TRANS_QUAD)
	tween.set_repeat(true)

#	timer = Timer.new()
#	add_child(timer)
#	timer.connect("timeout", self, "tick")
#	timer.set_wait_time(1)
#	timer.set_one_shot(false)
	
	


func setTime(times):
	time = times
	if time < 0:
		set_text("Round End!");
	else:
		set_text(str(time)+"!")