extends "res://minigames/PartyScreen/World.gd"


func _ready():
	pass # Replace with function body.

func _on_Button_pressed():
	# This currently does nothing. I would send it back to the original party screen
	# but that risks two matchmake() calls. I'm taking it out until serverside
	# matchmaking cancellation can be figured out.
	
	# Warning: trying to do rpc_id(cancellation_flag) will not work while the
	# server is in a loop. Having the loop check for the cancellation flag
	# will not update it either.
	
	# Kick player back to beginning
	#get_tree().change_scene("res://minigames/PartyScreen/World.tscn")
	# Still need to cancel server-side matchmaking.
	pass # Replace with function body.
