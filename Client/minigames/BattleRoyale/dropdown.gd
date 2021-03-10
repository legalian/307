extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _spawnRandom():
	var rng = RandomNumberGenerator.new();
	rng.randomize()
	var x = rng.randf_range(-100.0, 100.0)
	var y = rng.randf_range(-100.0, 100.0)
	get_parent().get_parent().server.spawn(x,y)
	get_node("camera").current = false;
	get_parent().get_parent().camera = null;
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("camera").current = true;



func _input(event):
	if(event is InputEventMouse):
		var pos = event.global_position
		var space_state = get_world_2d().direct_space_state
		var collidingWith = space_state.intersect_point(pos);
		if(collidingWith.get_overlapping_bodies().empty()):
			get_parent().get_parent().server.spawn(pos[0], pos[1]);
			get_node("camera").current = false;
			get_parent().get_parent().camera = null;
			
		
		
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
