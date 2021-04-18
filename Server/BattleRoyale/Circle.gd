extends Node2D

var center: Vector2 = Vector2(0, 0)
var color: Color = Color(1, 0, 0, 0.2)
var radius: float = 6000

func isInCircle(var location: Vector2):
	if (abs(center.distance_to(location)) >= abs(radius)):
		return true
	else:
		return false

func _process(delta):
	radius = radius - 40 * delta
