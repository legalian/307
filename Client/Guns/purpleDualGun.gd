tool
extends "res://Guns/gun.gd"

func _ready():
	firingSound =  preload("res://audio/sfx/shotgun.ogg")
	set_process(true)


func fire(var origpl,var targetpos):
	$PositionFix/Flare1.fire()
	$PositionFix/Flare2.fire()
	bulletAt(origpl,targetpos,true)
	bulletAt(origpl,targetpos,true,.2)
	bulletAt(origpl,targetpos,true,-.2)
	fireSound();

func unfire():
	pass


