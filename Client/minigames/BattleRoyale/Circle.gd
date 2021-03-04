extends Node2D

var center: Vector2 = Vector2(0, 0)
var color: Color = Color(1, 0, 0, 0.2)
var radius: float = 1000

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func isInCircle(var location: Vector2):
	if (abs(center.distance_to(location)) >= abs(radius)):
		#print("Loc:" + str(location))
		#print("Cen: " + str(center))
		#print("Dist: " + str(abs(center.distance_to(location))))
		#print("Rad: " + str(radius))
		return true
	else:
		return false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	draw_circle(center, radius, color)
	radius = radius - .6
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update()
	pass
