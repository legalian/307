extends "res://objects/destructible.gd"

func _die():
	self.set_rotation_degrees(90)
	yield(get_tree().create_timer(5.0), "timeout")
	get_parent().remove_child(self)
