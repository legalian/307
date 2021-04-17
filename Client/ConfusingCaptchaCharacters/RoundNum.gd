extends Label

var roundNumber;

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
	
	


func setRound(num):
	if(num >= 0):
		roundNumber = num
	else:
		roundNumber = 0;
	set_text(str(roundNumber))
