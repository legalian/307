extends Node2D

var center: Vector2 = Vector2(0, 0)
var color: Color = Color(1, 0, 0, 0.2)
var radius: float = 10000

const zone_line_width = 10000

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func isInCircle(var location: Vector2):
	if (abs(center.distance_to(location) + zone_line_width/2) >= abs(radius)):
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Don't do any drawing on the serverside
	radius = radius - .1
	pass
