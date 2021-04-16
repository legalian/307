extends Label

var time;

# Server sets the time, not the client. Since unlike racing or battle royale, time is much more important in this game. 

func start():
	pass
	
func _ready():
	pass
#	timer = Timer.new()
#	add_child(timer)
#	timer.connect("timeout", self, "tick")
#	timer.set_wait_time(1)
#	timer.set_one_shot(false)
	
	


func setTime(times):
	if(times >= 0):
		time = times
	else:
		time = 0;
	set_text(str(time)+"!")
