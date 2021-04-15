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
		find_node("Music Volume").get_node("MuteButton").hide()
		find_node("SFX Volume").get_node("MuteButton").hide()
	else:
		find_node("Master Volume").get_node("MutedDisplay").hide()
		find_node("Master Volume").get_node("VolumeSlider").show()
		find_node("Music Volume").get_node("MuteButton").show()
		find_node("SFX Volume").get_node("MuteButton").show()
		
	find_node("Music Volume").get_node("SettingValue").bbcode_text  = "[right]" + str(MusicVolume) + "%"
	find_node("Music Volume").get_node("ProgressBar").value = MusicVolume
	find_node("Music Volume").get_node("VolumeSlider").value = MusicVolume
	if AudioPlayer.is_music_muted() or AudioPlayer.is_master_muted():
		find_node("Music Volume").get_node("MutedDisplay").show()
		find_node("Music Volume").get_node("VolumeSlider").hide()
	else:
		find_node("Music Volume").get_node("MutedDisplay").hide()
		find_node("Music Volume").get_node("VolumeSlider").show()
	
	find_node("SFX Volume").get_node("SettingValue").bbcode_text  = "[right]" + str(SFXVolume) + "%"
	find_node("SFX Volume").get_node("ProgressBar").value = SFXVolume
	find_node("SFX Volume").get_node("VolumeSlider").value = SFXVolume
	if AudioPlayer.is_sfx_muted() or AudioPlayer.is_master_muted():
		find_node("SFX Volume").get_node("MutedDisplay").show()
		find_node("SFX Volume").get_node("VolumeSlider").hide()
	else:
		find_node("SFX Volume").get_node("MutedDisplay").hide()
		find_node("SFX Volume").get_node("VolumeSlider").show()

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

func _on_MusicVolume_changed(newValue):
	AudioPlayer.play_sfx("res://audio/sfx/click_002.ogg")
	AudioPlayer.set_music_volume(newValue)
	MusicVolume = AudioPlayer.get_music_volume()
	_SetVolumeText()

func _on_MusicVolume_Mute():
	AudioPlayer.play_sfx("res://audio/sfx/click_002.ogg")
	AudioPlayer.set_music_muted(not AudioPlayer.is_music_muted())
	_SetVolumeText()

func _on_SFXVolume_changed(newValue):
	AudioPlayer.play_sfx("res://audio/sfx/click_002.ogg")
	AudioPlayer.set_sfx_volume(newValue)
	SFXVolume = AudioPlayer.get_sfx_volume()
	_SetVolumeText()

func _on_SFXVolume_Mute():
	AudioPlayer.play_sfx("res://audio/sfx/click_002.ogg")
	AudioPlayer.set_sfx_muted(not AudioPlayer.is_sfx_muted())
	_SetVolumeText()
