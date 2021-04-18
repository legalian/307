extends MarginContainer

func _on_LeaveGame_pressed():
	AudioPlayer.play_sfx("res://audio/sfx/click_002.ogg")
	Server.leave_party()
