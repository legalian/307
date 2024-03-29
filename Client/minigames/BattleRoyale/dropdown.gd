extends Node2D

var spawned = false;
var started = false;
var space_state = null #global variable needed for multithreading

var map
var minx
var miny
var maxx
var maxy
var spawnX = 0;
var spawnY = 0;

func _spawnRandom():
	if(!spawned) :
		#var rng = RandomNumberGenerator.new();
		#rng.randomize()
		#var x = rng.randf_range(-100.0, 100.0)
		#var y = rng.randf_range(-100.0, 100.0)
		var x = 0;
		var y = 0
		#get_parent().get_parent().server.spawn(x,y)
		
		#get_node("camera").current = false;
		#get_parent().get_parent().camera = null;
		#AudioPlayer.play_sfx("res://audio/sfx/spawn.ogg")
		#spawned = true;
	
func _ready():
	self.visible = false;
	get_node("camera").current = false;

func start():
	self.visible = true;
	
	started = true;
	get_node("camera").current = true;
	while(map == null):
		map = get_parent().get_node_or_null("Tilemap")
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
			if space_state == null: return
			var collidingWith = space_state.intersect_point(pos);
			if(collidingWith.empty() || collidingWith[0].shape == 0):
				if(pos[0] >= minx && pos[0] <= maxx && pos[1] >= miny && pos[1] <= maxy):
					spawnX = pos[0]
					spawnY = pos[1]
					#get_parent().get_parent().server.spawn(pos[0], pos[1]);
					#get_node("camera").current = false;
					#get_parent().get_parent().camera = null; 
					#spawned = true;
					#AudioPlayer.play_sfx("res://audio/sfx/spawn.ogg")
			
func _process(_delta):
	if(find_node("Timer").done == true && !spawned):
		get_parent().get_parent().server.spawn(spawnX, spawnY);
		get_node("camera").current = false;
		get_parent().get_parent().camera = null;
		AudioPlayer.play_sfx("res://audio/sfx/spawn.ogg")
		spawned = true;
		
	if(spawned == true):
		get_parent().get_parent().dropFinished = true;
		self.visible = false;
		get_node("camera/CanvasLayer/Timer").visible = false;
	

func _physics_process(delta):
	if space_state == null:
		space_state = get_world_2d().direct_space_state
