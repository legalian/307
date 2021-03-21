extends Node2D

var spin
var frame = 0
var speed;
onready var wheel = get_node("World/Wheel");
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize();
	spin = rng.randi_range(360, 3600)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	speed = 1 + (spin / 180)
	for i in range(speed) :
		if(spin > 0):
			frame = frame + 1
			if(frame == 360):
				frame = 0;
			wheel.frame = frame;
			spin = spin - 1
