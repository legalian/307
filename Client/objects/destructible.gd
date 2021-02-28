extends "res://objects/object.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var totalHealth = 10
var health

# Called when the node enters the scene tree for the first time.
func _ready():
	health = totalHealth

func _getHit(damage):
	health -= damage
	if (health <= 0) :
		_die()
func _die():
	pass
	

