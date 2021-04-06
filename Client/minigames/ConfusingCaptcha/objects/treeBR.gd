extends "res://objects/destructible.gd"


func _die():
	self.set_rotation_degrees(90)
	yield(get_tree().create_timer(5.0), "timeout")
	get_parent().remove_child(self)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
