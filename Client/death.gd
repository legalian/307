extends MarginContainer

func _ready():
	AudioPlayer.pause_music()
	AudioPlayer.play_sfx("res://audio/sfx/scream.ogg")

func _on_LeaveGame_pressed():
	AudioPlayer.play_sfx("res://audio/sfx/click_002.ogg")
	Server.leave_party()
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	AudioPlayer.play_music("res://audio/music/mainmenu" + str(rng.randi_range(1,2)) + ".ogg")
	get_tree().change_scene("res://Main.tscn")
