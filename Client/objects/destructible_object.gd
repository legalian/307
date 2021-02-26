extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var healthTotal = 0
export var healthCurrent = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	healthTotal = self.get_parent().get("Health")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _getHit(damage):
	healthTotal -= damage
	if(healthTotal <= 0):
		_destroy()

func _destroy():
	self.get_parent.remove_child(self)
