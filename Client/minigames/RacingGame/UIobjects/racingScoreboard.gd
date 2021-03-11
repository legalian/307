extends Node

onready var game = get_tree().get_current_scene();

var player_list


func _ready():
	set_process(true)
	player_list = find_node("PlayerList")
	self.visible = false;
	
func sort_by_place(var playerA, var playerB):
	return (playerA.place < playerB.place)

func _open_player_list():
	var players = game.players.values();
	players.sort_custom(self, "sort_by_place")
	player_list.add_scoreboard(players) # Add the data
	self.visible = true
	
func systemname():
	return "ScoreBoard"
