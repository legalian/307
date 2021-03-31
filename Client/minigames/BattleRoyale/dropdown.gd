extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var spawned = false;
var started = false;

var map
var minx
var miny
var maxx
var maxy

func _spawnRandom():
	if(!spawned) :
		var rng = RandomNumberGenerator.new();
		rng.randomize()
		var x = rng.randf_range(-100.0, 100.0)
		var y = rng.randf_range(-100.0, 100.0)
		get_parent().get_parent().server.spawn(x,y)
		get_node("camera").current = false;
		get_parent().get_parent().camera = null;
		spawned = true;
	
# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false;
	get_node("camera").current = false;

func start():
	self.visible = true;
	
	started = true;
	get_node("camera").current = true;
	map = get_node("../TileMap");
	var topleft = Vector2(-24, -17)
	var bottomright = Vector2(40,40)
	var topleftworld = map.map_to_world(topleft, false);
	var bottomrightworld = map.map_to_world(bottomright, false);
	minx = topleftworld[0]
	miny = topleftworld[1]
	maxx = bottomrightworld[0]
	maxy = bottomrightworld[1]
	get_node("camera/CanvasLayer/Timer").start();




func _input(event):
	if(!spawned && started):
		if(event is InputEventMouseButton):
			var pos = get_parent().get_local_mouse_position()
			var space_state = get_world_2d().direct_space_state
			var collidingWith = space_state.intersect_point(pos);
			if(collidingWith.empty() || collidingWith[0].shape == 0):
				if(pos[0] >= minx && pos[0] <= maxx && pos[1] >= miny && pos[1] <= maxy):
					get_parent().get_parent().server.spawn(pos[0], pos[1]);
					get_node("camera").current = false;
					get_parent().get_parent().camera = null; 
					spawned = true;
			
		
		
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(spawned == true):
		get_parent().get_parent().dropFinished = true;
		
		queue_free()
