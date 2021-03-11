extends MarginContainer

onready var game = get_tree().get_current_scene();
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var server

func _ready():
	print("Game: " + str(game.get_path()))
	server = get_node("/root/Server").get_children()[0]

func sort_by_place(var playerA, var playerB):
	return (playerA.place < playerB.place)

func _process(_delta):
	var players = game.players.values();
	players.sort_custom(self, "sort_by_place")
	if (server.get_player(players[0].id)):
		var player1 = server.get_player(players[0].id).username;
		get_node("first").text = "1. " + player1;
	if (server.get_player(players[1].id)):
		var player2 = server.get_player(players[1].id).username;
		get_node("second").text = "2. " + player2;
	if (players.size() >= 3 && server.get_player(players[2].id)):
		var player3 = server.get_player(players[2].id).username;
		get_node("third").text = "3. " + player3;
