extends Node

onready var generalserver = get_node("/root/Server")

var MasterVolume
var MusicVolume
var SFXVolume

func _ready():
	MasterVolume = AudioPlayer.get_master_volume()
	MusicVolume = AudioPlayer.get_music_volume() 
	SFXVolume = AudioPlayer.get_sfx_volume() 
	_SetVolumeText()

func _SetVolumeText():
	
	find_node("Master Volume").get_node("SettingValue").bbcode_text  = "[right]" + str(MasterVolume) + "%"
	find_node("Master Volume").get_node("ProgressBar").value = MasterVolume
	find_node("Master Volume").get_node("VolumeSlider").value = MasterVolume
	if AudioPlayer.is_master_muted():
		find_node("Master Volume").get_node("MutedDisplay").show()
		find_node("Master Volume").get_node("VolumeSlider").hide()
	else:
		find_node("Master Volume").get_node("MutedDisplay").hide()
		find_node("Master Volume").get_node("VolumeSlider").show()
		
	find_node("Music Volume").get_node("SettingValue").bbcode_text  = "[right]" + str(MusicVolume) + "%"
	find_node("SFX Volume").get_node("SettingValue").bbcode_text  = "[right]" + str(SFXVolume) + "%"

func _on_BackButton_pressed():
	AudioPlayer.play_sfx("res://audio/sfx/click_002.ogg")
	var _success = get_tree().change_scene("res://Main.tscn")

func _on_MasterVolume_changed(newValue):
	AudioPlayer.play_sfx("res://audio/sfx/click_002.ogg")
	AudioPlayer.set_master_volume(newValue)
	MasterVolume = AudioPlayer.get_master_volume()
	_SetVolumeText()

func _on_MasterVolume_Mute():
	AudioPlayer.play_sfx("res://audio/sfx/click_002.ogg")
	AudioPlayer.set_master_muted(not AudioPlayer.is_master_muted())
	_SetVolumeText()
