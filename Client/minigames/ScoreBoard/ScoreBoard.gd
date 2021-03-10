extends Node

onready var generalserver = get_node("/root/Server")

var player_list

var pressed

func _ready():
	set_process(true)
	player_list = find_node("PlayerList")
	player_list.clear_scoreboard()
	player_list.hide()
	
	pressed = false

func _process(_delta):
	if Input.is_action_pressed("scoreboard"): #tab
		_open_player_list()
		pressed = true
	else:
		_close_player_list()
		pressed = false

func _open_player_list():
	if (!pressed): # First press
		var scores = generalserver.players
		print("SCOREBOARD ARRAY SIZE: " + str(scores.size()))
		
		player_list.add_scoreboard(scores) # Add the data
	self.visible = true

func _close_player_list():
	self.visible = false
	player_list.clear_scoreboard() # Clear the data for next press

func systemname():
	return "ScoreBoard"
