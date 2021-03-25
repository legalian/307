extends StaticBody2D

var cooldown
var rng

enum Powerups {SPEED, PROJ}

var projectile = preload("res://RacingGame/PU_Proj.tscn")

func _ready():
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
	
func use(player):
	cooldown.start()
	$CollisionShape2D.set_deferred("disabled", true)
	visible = false
	
	var cur_powerup = rng.randi_range(0, Powerups.size()-1)
	match cur_powerup:
		Powerups.SPEED:
			player.gain_speed_powerup(5)
		Powerups.PROJ:
			var proj_node = projectile.instance()
			proj_node.name = "Projectile " + str(proj_node.get_instance_id())
			proj_node.position = Vector2(position.x, position.y)
			get_parent().add_child(proj_node) # Add to $World
	
func reset():
	$CollisionShape2D.set_deferred("disabled", false)
	visible = true

