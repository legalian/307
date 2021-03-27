extends StaticBody2D

var cooldown
var rng
var powerupSelected = null


enum Powerups {SPEED, PROJ, TRAP}

var projectile = preload("res://RacingGame/PU_Proj.tscn")
var trap = preload("res://RacingGame/trap.tscn")

func _ready():
	var powerupEnv = "nonpowerups"
	if(OS.has_environment("POWERUPTEST"):
		powerupEnv = OS.get_environment("POWERUPTEST")
	if(powerupEnv != "nonpowerups"):
		powerupSelected = powerupEnv;
	cooldown = Timer.new()
	add_child(cooldown)
	cooldown.connect("timeout", self, "reset")
	cooldown.set_wait_time(10)
	cooldown.set_one_shot(true)
	
	rng = RandomNumberGenerator.new()
	rng.randomize()
	
func pack():
	return {
		'x':position.x,
		'y':position.y,
		'visible':visible,
		'name':name
	}

func pickup(player):
	cooldown.start()
	$CollisionShape2D.set_deferred("disabled", true)
	visible = false
	var cur_powerup;
	if(powerupSelected != null);
		cur_powerup = rng.randi_range(0, Powerups.size()-1)
	else:
		if(powerupSelected == "speed"):
			cur_powerup = Powerups.SPEED
		else if(powerupSelected == "missile"):
			cur_powerup = Powerups.PROJ;
		else:
			cur_powerup = Powerups.TRAP
	match cur_powerup:
		Powerups.SPEED:
			player.cur_powerup = "speed"
		Powerups.PROJ:
			player.cur_powerup = "missile"
		Powerups.TRAP:
			player.cur_powerup = "trap";
	
func reset():
	$CollisionShape2D.set_deferred("disabled", false)
	visible = true

