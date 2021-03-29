tool
extends "res://Guns/gun.gd"

func fire(var origpl,var targetpos):
	$PositionFix/Flare.fire()
	bulletAt(origpl,targetpos)

func unfire():
	pass
