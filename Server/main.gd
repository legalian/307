extends Node2D

var network = NetworkedMultiplayerENet.new()
var port = 1909
var max_players = 3000
var max_players_per = 20
var min_players_per = 10

var game_types = [preload("res://BattleRoyale.tscn")]
var assigned_lobbies = {}

func _ready():
	StartServer()
	
func StartServer():
	network.create_server(port,max_players)
	get_tree().set_network_peer(network)
	print("Server started")
	
	network.connect("peer_connected",self,"_Peer_Connected")
	network.connect("peer_disconnected",self,"_Peer_Disconnected")

func make_new_lobby():
	randomize()
	var scene = game_types[randi()%(game_types.length())]
	var instance = scene.instance()
	add_child(instance)
	return instance


func _Peer_Connected(player_id):
	print("User "+player_id+" connected.")
	#this part will need to be more complicated: all i'm doing here is making a new lobby for each player. This will need to be replaced with our party/lobby system.
	#each lobby object returned by scene.instance() will have a add_player() method, remove_player() method, and a is_accepting_players() method. you can change this if needed.
	#it would probably make more sense to make a party for each user, and have them leave that party and join a new one when a party code is submitted.
	var lobby = make_new_lobby();
	assigned_lobbies[player_id] = lobby
	lobby.add_player(player_id)
	
func _Peer_Disconnected(player_id):
	print("User "+player_id+" disconnected.")
	var lobby = assigned_lobbies[player_id]
	lobby.remove_player(player_id)
	assigned_lobbies.remove(player_id)
	if lobby.player_count()==0:
		lobby.queue_free()







