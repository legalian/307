extends Node2D
const PartyHandler = preload("res://PartyHandler.gd")
const PartyPlayer = preload("res://PartyPlayer.gd")

var network = NetworkedMultiplayerENet.new()
var partyHandler
var port = 1909
var max_players = 3000
var max_players_per = 20
var min_players_per = 10

var game_types = [preload("res://BattleRoyale.tscn")]
var game_typenames = ["BattleRoyale"]
var assigned_lobbies = {}

#Note: This is a temporary variable I am using to test the party join/create system
var test_party_code

func _ready():
	StartServer()
	
func StartServer():
	partyHandler = PartyHandler.new()
	
	network.create_server(port,max_players)
	get_tree().set_network_peer(network)
	print("Server started")
	
	network.connect("peer_connected",self,"_Peer_Connected")
	network.connect("peer_disconnected",self,"_Peer_Disconnected")

func make_new_lobby():#makes a new lobby object, inserts it into the tree, and returns it.
	randomize()
	var index = 0
	var scene = game_types[index]
	var instance = scene.instance()
	instance.name = game_typenames[index]
	add_child(instance)
	return instance

func _Peer_Connected(player_id):
	print("User " + str(player_id) + " connected.")
	#this part will need to be more complicated: all i'm doing here is making a new lobby for each player. This will need to be replaced with our party/lobby system.
	#each lobby object returned by scene.instance() will have a add_player() method, remove_player() method, and a is_accepting_players() method. you can change this if needed.
	#it would probably make more sense to make a party for each user, and have them leave that party and join a new one when a party code is submitted.
	

remote func party_ready():
	var player_id = get_tree().get_rpc_sender_id()
	var lobby = make_new_lobby()
	for pid in partyHandler.get_party_by_player(player_id).playerIDs:
		assigned_lobbies[pid] = lobby
		lobby.add_player(pid)
		rpc_id(pid,"setlobby",lobby.systemname(),lobby.name)

remote func create_party():
	var player_id = get_tree().get_rpc_sender_id()
	print("Creating party...")
	var testParty = partyHandler.new_party(player_id)
	print("Code: " + str(testParty.code))
	print("Players: " + str(testParty.playerIDs))
	
func _Peer_Disconnected(player_id):
	#var lobby = assigned_lobbies[player_id]
	#lobby.remove_player(player_id)
	#assigned_lobbies.remove(player_id)
	#if lobby.player_count()==0:
	#	lobby.queue_free()
	partyHandler.leave_party(player_id)
	print("User " + str(player_id) + " disconnected.")
	







