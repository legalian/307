extends StaticBody2D

var cooldown
var rng

enum Powerups {SPEED}

func _ready():
	cooldown = Timer.new()
	add_child(cooldown)
	cooldown.connect("timeout", self, "reset")
	cooldown.set_wait_time(10)
	cooldown.set_one_shot(true)
	
	rng = RandomNumberGenerator.new()
	rng.randomize()
	
func use(player):
	cooldown.start()
	$CollisionShape2D.set_deferred("disabled", true)
	visible = false
	
	var cur_powerup = rng.randi_range(0, Powerups.size()-1)
	match cur_powerup:
		Powerups.SPEED:
			player.gain_speed_powerup(5)
	
func reset():
	$CollisionShape2D.set_deferred("disabled", false)
	visible = true

