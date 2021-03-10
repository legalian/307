extends Node2D


var animPlayer = null
var headRef = null
var lefthand = null
var righthand = null
var playback = null

func _ready():
	#set_Hat("res://Hats/Whitehat.tscn")
	set_process(true)
	animPlayer = get_node("AnimationTree")
	headRef = find_node("Headref")
	lefthand = find_node("LeftArmTarget")
	righthand = find_node("RightArmTarget")
	playback = animPlayer.get("parameters/StateMachine/playback")
	playback.start('WalkCycle')


func _process(delta):
	var glt = get_global_transform_with_canvas()
	glt.origin = Vector2(0,0)
	get_node("Char").transform = glt.affine_inverse()
	
func set_look_pos(gpos,vel):
	#gpos.y/=.44
	var offsetrot = -get_viewport().canvas_transform.scaled(Vector2(.44,1)).get_rotation()
	vel = vel.rotated(-offsetrot)
	var cpos = gpos-headRef.global_position
	#cpos.y*=.44
	var rot = offsetrot-cpos.angle()
	animPlayer.set("parameters/lookX/seek_position", .5+.5*cos(rot))
	animPlayer.set("parameters/lookY/seek_position", .5+.5*sin(rot))
	animPlayer.set("parameters/StateMachine/WalkCycle/Direction/blend_amount", min(1,max(-1,vel[0])))
	animPlayer.set("parameters/StateMachine/WalkCycle/Speed/scale", vel.length()/60)
	#gpos.y*=.44
	lefthand.global_position = gpos

func set_Hat(hatPath):
	var headbone = find_node("Head")
	var currentHat = headbone.get_node_or_null("Hat")
	if currentHat!=null:
		headbone.remove_child(currentHat)
		currentHat.queue_free()
	if hatPath != null:
		var newHat = load(hatPath).instance()
		newHat.name = "Hat"
		headbone.add_child(newHat,true)#second parameter is important here- must be true
		newHat.position = Vector2(0,-35)

func ouch():
	animPlayer.set("parameters/Ouch/active", true)

func rip():
	playback.travel('DeathLeft')
