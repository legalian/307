extends "res://minigame.gd"

var spin
var frame = 0
var speed;
onready var wheel = get_node("World/WheelContainer/Wheel");
var player
var world_type = 'map_selection'
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("World/Raccoon");
	get_node("World/Raccoon/Char/Skeleton2D/Hip/Torso/LeftArm/LeftHand/LeftHandPoint/Gun").visible = false;
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	speed = 1 + (spin / 180)
	for i in range(speed) :
		if(spin > 0):
			frame = frame + 1
			if(frame == 360):
				frame = 0;
			wheel.rotation_degrees = frame;
			spin = spin - 1
	


