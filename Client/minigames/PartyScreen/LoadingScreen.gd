extends Node2D

var generalserver
var specificserver

func _ready():
	generalserver = get_node("/root/Server")
	specificserver = generalserver.get_children()[0]

func _on_Button_pressed():
	# Cancel matchmaking on server side
	generalserver.cancel_matchmaking()
	# Kick player back to beginning
	get_tree().change_scene("res://minigames/PartyScreen/World.tscn")
	# Still need to cancel server-side matchmaking.
	pass # Replace with function body.
