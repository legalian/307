extends Node2D

var vehiclePath = "res://Vehicles/"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var vehicle_num = rand_range(0,4);
	var vehicles = ["12x12.tscn","Bike.tscn", "Car.tscn", "Forklift.tscn", "Truck.tscn"];
	var random_vehicle_resource = load(vehiclePath + vehicles[vehicle_num]);	
	var random_vehicle = random_vehicle_resource.instance();
	var root = get_node(".")
	root.add_child(random_vehicle);
	var camera = get_node("Camera2D");
	root.remove_child(camera);
	random_vehicle.add_child(camera);
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

