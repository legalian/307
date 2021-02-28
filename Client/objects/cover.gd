extends "res://objects/destructible.gd"

func _die():
	get_parent().remove_child(self)
