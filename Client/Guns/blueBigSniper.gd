tool
extends "res://Guns/gun.gd"

func _ready():
	firingSound = "res://audio/sfx/gun/rocket.ogg"
	set_process(true)

func fire(var origpl,var targetpos):
	$PositionFix/Flare.fire()
	bulletAt(origpl,targetpos,false)
	fireSound();

func unfire():
	pass
