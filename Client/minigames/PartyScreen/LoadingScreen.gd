extends Node

var generalserver
var specificserver

onready var matchmaking_label = get_node("PanelContainer/CenterContainer/VBoxContainer/Label")

func _ready():
	generalserver = get_node("/root/Server")
	specificserver = generalserver.get_children()[0]
	
	var _timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "loadingAnim")
	_timer.set_wait_time(0.1)
	_timer.set_one_shot(false)
	_timer.start()

var loadRight = true

func loadingAnim():
	if (loadRight):
		if (matchmaking_label.visible_characters == 29):
			loadRight = false
			return
		matchmaking_label.visible_characters += 1
	else:
		if (matchmaking_label.visible_characters == 11):
			loadRight = true
			return
		matchmaking_label.visible_characters -= 1
	

func _on_Button_pressed():
	# Cancel matchmaking on server side
	generalserver.cancel_matchmaking()
	# Kick player back to beginning
	get_tree().change_scene("res://minigames/PartyScreen/World.tscn")
	# Still need to cancel server-side matchmaking.
	pass # Replace with function body.
