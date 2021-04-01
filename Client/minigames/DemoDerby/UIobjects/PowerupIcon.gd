extends TextureRect
	
func changePowerup(powerup):
	match powerup:
		"speed":
			texture = load("res://Sprites/Powerups/energy.png")
		"missile":
			texture = load("res://Sprites/Powerups/missile.png")
		"trap":
			texture = load("res://Sprites/Powerups/trap.png")
		_:
			texture = null
