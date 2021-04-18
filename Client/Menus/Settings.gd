extends Node

var MasterVolume
var MusicVolume
var SFXVolume

func _ready():
	MasterVolume = AudioPlayer.get_master_volume()
	MusicVolume = AudioPlayer.get_music_volume()
	SFXVolume = AudioPlayer.get_sfx_volume()
	_SetVolumeText()

func _SetVolumeText():
	if AudioPlayer.is_master_muted():
		find_node("Master Volume").find_node("VolumeSlider").editable = false
		find_node("Master Volume").find_node("MuteButton").text = "Unmute"
		find_node("Master Volume").find_node("ProgressBar").value = 0
		find_node("Master Volume").find_node("VolumeSlider").value = 0
	else:
		find_node("Master Volume").find_node("MuteButton").text = "Mute"
		find_node("Master Volume").find_node("VolumeSlider").editable = true
		find_node("Master Volume").find_node("ProgressBar").value = MasterVolume
		find_node("Master Volume").find_node("VolumeSlider").value = MasterVolume
	
	
	if AudioPlayer.is_music_muted() or AudioPlayer.is_master_muted():
		find_node("Music Volume").find_node("MuteButton").text = "Unmute"
		find_node("Music Volume").find_node("VolumeSlider").editable = false
		find_node("Music Volume").find_node("ProgressBar").value = 0
		find_node("Music Volume").find_node("VolumeSlider").value = 0
	else:
		find_node("Music Volume").find_node("MuteButton").text = "Mute"
		find_node("Music Volume").find_node("VolumeSlider").editable = true
		find_node("Music Volume").find_node("ProgressBar").value = MusicVolume
		find_node("Music Volume").find_node("VolumeSlider").value = MusicVolume
	


	if AudioPlayer.is_sfx_muted() or AudioPlayer.is_master_muted():
		find_node("SFX Volume").find_node("MuteButton").text = "Unmute"
		find_node("SFX Volume").find_node("VolumeSlider").editable = false
		find_node("SFX Volume").find_node("ProgressBar").value = 0
		find_node("SFX Volume").find_node("VolumeSlider").value = 0
	else:
		find_node("SFX Volume").find_node("MuteButton").text = "Mute"
		find_node("SFX Volume").find_node("VolumeSlider").editable = true
		find_node("SFX Volume").find_node("ProgressBar").value = SFXVolume
		find_node("SFX Volume").find_node("VolumeSlider").value = SFXVolume

func _on_BackButton_pressed():
	AudioPlayer.play_sfx("res://audio/sfx/click_002.ogg")
	Config.save_config()
	var _success = get_tree().change_scene("res://Main.tscn")

func _on_MasterVolume_changed(newValue):
	AudioPlayer.play_sfx("res://audio/sfx/click_002.ogg")
	AudioPlayer.set_master_volume(newValue)
	if (!AudioPlayer.is_master_muted()):
		MasterVolume = newValue
	_SetVolumeText()

func _on_MasterVolume_Mute():
	AudioPlayer.play_sfx("res://audio/sfx/click_002.ogg")
	if (AudioPlayer.is_master_muted()):
		# Unmute
		AudioPlayer.set_master_muted(false)
	else:
		# Mute
		MasterVolume = AudioPlayer.get_master_volume()
		AudioPlayer.set_master_muted(true)
	
	if (AudioPlayer.is_music_muted()):
		# Unmute
		AudioPlayer.set_music_muted(false)
	else:
		# Mute
		MusicVolume = AudioPlayer.get_music_volume()
		AudioPlayer.set_music_muted(true)
	
	if (AudioPlayer.is_sfx_muted()):
		# Unmute
		AudioPlayer.set_sfx_muted(false)
	else:
		# Mute
		SFXVolume = AudioPlayer.get_sfx_volume()
		AudioPlayer.set_sfx_muted(true)
	
	_SetVolumeText()

func _on_MusicVolume_changed(newValue):
	AudioPlayer.play_sfx("res://audio/sfx/click_002.ogg")
	AudioPlayer.set_music_volume(newValue)
	if (!AudioPlayer.is_music_muted()):
		MusicVolume = newValue
	_SetVolumeText()

func _on_MusicVolume_Mute():
	AudioPlayer.play_sfx("res://audio/sfx/click_002.ogg")
	if (AudioPlayer.is_music_muted()):
		# Unmute
		AudioPlayer.set_music_muted(false)
	else:
		# Mute
		MusicVolume = AudioPlayer.get_music_volume()
		AudioPlayer.set_music_muted(true)
	_SetVolumeText()

func _on_SFXVolume_changed(newValue):
	AudioPlayer.play_sfx("res://audio/sfx/click_002.ogg")
	AudioPlayer.set_sfx_volume(newValue)
	if (!AudioPlayer.is_sfx_muted()):
		SFXVolume = newValue
	_SetVolumeText()

func _on_SFXVolume_Mute():
	AudioPlayer.play_sfx("res://audio/sfx/click_002.ogg")
	if (AudioPlayer.is_sfx_muted()):
		# Unmute
		AudioPlayer.set_sfx_muted(false)
	else:
		# Mute
		SFXVolume = AudioPlayer.get_sfx_volume()
		AudioPlayer.set_sfx_muted(true)
	_SetVolumeText()
