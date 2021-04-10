extends Node

var spin
var curSpin
var frame = 0
var speed;
var spinSet = 0;
var spinCount = 0;
var done = false;
onready var wheel = find_node("Wheel");
var player
var world_type = 'map_selection'
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	self.visible = false;


func start():
	set_process(true)
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
			wheel.rect_rotation = frame;
			curSpin = curSpin - 1
			spinCount = spinCount - 1
	if(spinSet == 1 && curSpin <= 0):
		done = true;
		self.find_node("Camera2D").current = false;
		self.visible = false;
