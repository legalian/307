extends Node2D

var spin
var curSpin
var frame = 0
var speed;
var spinSet = 0;
var spinCount = 0;
var done = false;
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
	if(spin == null): 
		return
	else: 
		if(spinSet == 0):
			curSpin = spin
			spinSet = 1
	spinCount += (50 + (curSpin / 3.6)) * delta
	for i in range(spinCount) :
		if(curSpin > 0 ):
			frame = frame + 1
			if(frame == 360):
				frame = 0;
			wheel.rotation_degrees = frame;
			curSpin = curSpin - 1
			spinCount = spinCount - 1
	if(spinSet == 1 && curSpin <= 0):
		done = true;
		self.get_node("World/Camera2D").current = false;
		self.visible = false;
