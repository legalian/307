extends Node2D

func _physics_process(delta):
	rotate(PI*delta)

func unpack(package):
	visible = package['visible']
