extends MarginContainer

func _on_LeaveGame_pressed():
	AudioPlayer.play_sfx("res://audio/sfx/click_022.ogg")
	Server.leave_party()
	pass # Replace with function body.
