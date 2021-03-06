extends "res://minigames/PartyScreen/World.gd"


func _ready():
	pass # Replace with function body.

func _on_Button_pressed():
	# Cancel matchmaking on server side
	generalserver.cancel_matchmaking()
	# Kick player back to beginning
	get_tree().change_scene("res://minigames/PartyScreen/World.tscn")
	# Still need to cancel server-side matchmaking.
	pass # Replace with function body.
