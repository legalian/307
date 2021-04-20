extends Control

func _ready():
	AudioPlayer.pause_music()

func _on_Button_pressed():
	AudioPlayer.play_sfx("res://audio/sfx/click_002.ogg")
	get_tree().change_scene("Main.tscn")
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	AudioPlayer.play_music("res://audio/music/mainmenu" + str(rng.randi_range(1,2)) + ".ogg")
	get_tree().change_scene("res://Main.tscn")
