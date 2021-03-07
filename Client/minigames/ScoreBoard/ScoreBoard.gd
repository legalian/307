extends Node

onready var generalserver = get_node("/root/Server")

var player_list

func _ready():
	set_process(true)
	player_list = find_node("PlayerList")
	player_list.clear_scoreboard()
	player_list.hide()
	pass

func _process(delta):
	if Input.is_key_pressed(16777218): #tab
		_open_player_list()
	else:
		_close_player_list()

func _open_player_list():
	player_list.add_scoreboard(generalserver.players) # Add the data
	self.visible = true

func _close_player_list():
	player_list.clear_scoreboard() # Clear the data for next press
	self.visible = false

func systemname():
	return "ScoreBoard"
