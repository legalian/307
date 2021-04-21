extends Node

var matchmaking_label
var loadRight

func _ready():
	
	matchmaking_label = get_node("PanelContainer/CenterContainer/VBoxContainer/Label")
	matchmaking_label.visible_characters = 11
	
	loadRight = true
	var _timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "loadingAnim")
	_timer.set_wait_time(0.1)
	_timer.set_one_shot(false)
	_timer.start()


func loadingAnim():
	if (loadRight):
		if (matchmaking_label.visible_characters == matchmaking_label.text.length()):
			loadRight = false
			return
		matchmaking_label.visible_characters += 1
	else:
		if (matchmaking_label.visible_characters == 11):
			loadRight = true
			return
		matchmaking_label.visible_characters -= 1
	

func _on_Button_pressed():
	AudioPlayer.play_sfx("res://audio/sfx/click_002.ogg")
	# Cancel matchmaking on server side
	Server.cancel_matchmaking()
	# Kick player back to beginning
	
	print("CANCEL MATCHMAKING")
	
	if Server.get_child_count() > 0:
		get_tree().change_scene("res://minigames/PartyScreen/World.tscn")
	else:
		Server.leave_party()
		get_tree().change_scene("res://Main.tscn")
