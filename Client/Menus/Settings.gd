extends Node

onready var generalserver = get_node("/root/Server")

var MasterVolume
var MusicVolume
var SFXVolume

func _ready():
	MasterVolume = generalserver.selfplayer.volume[0]
	MusicVolume = generalserver.selfplayer.volume[1]
	SFXVolume = generalserver.selfplayer.volume[2]
	_SetVolumeText()

func _SetVolumeText():
	find_node("Master Volume").get_node("SettingValue").bbcode_text  = "[right]" + str(MasterVolume) + "%"
	find_node("Music Volume").get_node("SettingValue").bbcode_text  = "[right]" + str(MusicVolume) + "%"
	find_node("SFX Volume").get_node("SettingValue").bbcode_text  = "[right]" + str(SFXVolume) + "%"

func _on_BackButton_pressed():
	AudioPlayer.play_sfx("res://audio/sfx/click_002.ogg")
	var _success = get_tree().change_scene("res://Main.tscn")


func _on_MasterRandomize_pressed():
	AudioPlayer.play_sfx("res://audio/sfx/click_002.ogg")
	var newValue = randomNumber()
	generalserver.selfplayer.volume[0] = newValue
	MasterVolume = generalserver.selfplayer.volume[0]
	_SetVolumeText()

func randomNumber():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var randomValueNum = rng.randi_range(0, 100)
	return randomValueNum
