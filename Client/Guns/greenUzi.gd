tool
extends "res://Guns/gun.gd"

var ori
var targ

func _ready():
	firingSound =  preload("res://audio/sfx/smgshot.ogg")
	set_process(true)

func fire(var origpl,var targetpos):
	ori = origpl
	targ = targetpos
	fireSound();
	$PositionFix/Flare.beginfire()
	$Timer.start()

func unfire():
	$PositionFix/Flare.stop()
	$Timer.stop()


func _on_Timer_timeout():
	bulletAt(ori,targ,true)
