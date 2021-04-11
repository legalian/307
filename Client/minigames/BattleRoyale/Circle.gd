extends Node2D

var radius: float = 6000.0
	
func update_radius(var rad: float):
	radius = rad
	$CircleDrawer.material.set_shader_param("radius", radius)

func _process(delta):
	$CircleDrawer.material.set_shader_param("global_transform", get_global_transform())
	
