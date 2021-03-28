extends Node2D


var animPlayer = null
var headRef = null
var l_handref = null
var r_handref = null
var lefthand = null
var righthand = null
var playback = null
var HatLocation = [null, 
"res://Hats/Tophat.tscn",
"res://Hats/Whitehat.tscn",
"res://Hats/Viking.tscn",
"res://Hats/Paperhat.tscn",
"res://Hats/Headphones.tscn"]
var GunLocation = [null, 
"res://Guns/basicGun.tscn",
"res://Guns/greenUzi.tscn",
"res://Guns/purpleDualGun.tscn"]

func _ready():
	#set_Hat("res://Hats/Whitehat.tscn")
	set_process(true)
	animPlayer = get_node("AnimationTree")
	headRef = find_node("Headref")
	lefthand = find_node("LeftArmTarget")
	righthand = find_node("RightArmTarget")
	playback = animPlayer.get("parameters/StateMachine/playback")
	playback.start('WalkCycle')
	l_handref = find_node("LeftHandPoint")
	r_handref = find_node("RightHandPoint")


func _process(_delta):
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



func set_Hat(hatindex):
	var hatPath = HatLocation[hatindex];
	var currentHat = headRef.get_node_or_null("Hat")
	if currentHat!=null:
		headRef.remove_child(currentHat)
		currentHat.queue_free()
	if hatPath != null:
		var newHat = load(hatPath).instance()
		newHat.name = "Hat"
		headRef.add_child(newHat,true)#second parameter is important here- must be true
		newHat.position = Vector2(40,0)
		newHat.rotation = PI/2

func set_Gun(gunindex):
	var gunPath = GunLocation[gunindex]
	var currentGun = l_handref.get_node_or_null("Gun")
	if currentGun!=null:
		l_handref.remove_child(currentGun)
		currentGun.queue_free()
	if gunPath != null:
		var newGun = load(gunPath).instance()
		newGun.name = "Gun"
		l_handref.add_child(newGun,true)#second parameter is important here- must be true
		newGun.rotation_degrees = -88.4
		newGun.scale = Vector2(1.75,1.75)
		return newGun


func ouch():
	animPlayer.set("parameters/Ouch/active", true)

func rip():
	playback.travel('DeathLeft')
