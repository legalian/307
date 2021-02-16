extends Node2D

var network = NetworkedMultiplayerENet.new()
var port = 1909
var max_players = 3000
var max_players_per = 20
var min_players_per = 10


func _ready():
	StartServer()
	
func StartServer():
	network.create_server(port,max_players)
	get_tree().set_network_peer(network)
	print("Server started")
	
	network.connect("peer_connected",self,"_Peer_Connected")
	network.connect("peer_disconnected",self,"_Peer_Disconnected")

func _Peer_Connected(player_id):
	print("User "+player_id+" connected.")
	
func _Peer_Disconnected(player_id):
	print("User "+player_id+" disconnected.")







