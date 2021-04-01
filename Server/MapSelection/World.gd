extends "res://GameBase.gd"
func systemname():
	return "MapSelection"

var spin
const MAPS = ["Grass", "Desert"]
var mapSelected


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize();
	spin = rng.randi_range(360, 3600)
	if((spin % 360) < 180): 
		mapSelected = MAPS[0]
	else:
		mapSelected = MAPS[1]
	get_parent().set_map(players[0].playerID, mapSelected);
	var timer = Timer.new();
	timer.connect("timeout", self, "finish")
	timer.set_wait_time(10)
	timer.start()

func finish():
	get_parent().go_to_next_minigame(players[0].playerID);



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	for p in players:
		rpc_unreliable_id(p.playerID, "setSpin", spin);

