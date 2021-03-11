extends MarginContainer

onready var game = get_tree().get_current_scene();
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var server

func _ready():
	print("Game: " + str(game.get_path()))

func sort_by_place(var playerA, var playerB):
	return (playerA.place < playerB.place)

func _process(_delta):
	if(server == null):
		server = get_node_or_null("/root/Server").get_children()[0]
	var players = game.players.values();
	players.sort_custom(self, "sort_by_place")
	if (true):
		var player1 = str(players[0].id)
		get_node("first").text = "1. " + player1;
	if (players.size() >= 2):
		var player2 = players[1].id;
		get_node("second").text = "2. " + player2;
	if (players.size() >= 3):
		var player3 = players[2].id;
		get_node("third").text = "3. " + player3;
