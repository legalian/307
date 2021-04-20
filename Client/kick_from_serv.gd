extends Control

func _ready():
	pass

func _on_Button_pressed():
	AudioPlayer.play_sfx("res://audio/sfx/click_002.ogg")
	get_tree().change_scene("Main.tscn")
