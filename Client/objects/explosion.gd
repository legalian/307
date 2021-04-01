extends Node2D


func _ready():
	$AnimationPlayer.play("explode")

func end():
	get_parent().remove_child(self)
	queue_free()
