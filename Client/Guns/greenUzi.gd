tool
extends "res://Guns/gun.gd"

var ori
var targ

func fire(var origpl,var targetpos):
	ori = origpl
	targ = targetpos
	$PositionFix/Flare.beginfire()
	$Timer.start()

func unfire():
	$PositionFix/Flare.stop()
	$Timer.stop()


func _on_Timer_timeout():
	bulletAt(ori,targ,true)
