extends Node2D

var center: Vector2 = Vector2(0, 0)
var color: Color = Color(1, 0, 0, 0.2)
var radius: float = 3000

const zone_line_width = 1000

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

#Taken from https://docs.godotengine.org/en/stable/tutorials/2d/custom_drawing_in_2d.html
func draw_circle_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 256
	var points_arc = PoolVector2Array()

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color, zone_line_width)


func _draw():
	draw_circle_arc(center, radius, 0, 365, color)
	radius = radius - .6
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (radius >= 0):
		update()
	pass
