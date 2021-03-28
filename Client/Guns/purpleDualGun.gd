tool
extends "res://Guns/gun.gd"


func fire(var origpl,var targetpos):
	$PositionFix/Flare1.fire()
	$PositionFix/Flare2.fire()
	bulletAt(origpl,targetpos)

func unfire():
	pass


