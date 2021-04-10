tool
extends "res://Guns/gun.gd"


func _ready():
	firingSound =  preload("res://audio/sfx/handgun.ogg")
	set_process(true)
	
func fire(var origpl,var targetpos):
	$PositionFix/Flare.fire()
	bulletAt(origpl,targetpos,true)
	fireSound();

func unfire():
	pass
