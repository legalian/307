extends Node2D
const PartyHandler = preload("res://PartyHandler.gd")
const PartyPlayer = preload("res://PartyPlayer.gd")

var network = NetworkedMultiplayerENet.new()
var partyHandler
var port = 1909
var max_players = 3000
var max_players_per = 20
var min_players_per = 10

var lobby_game_type = preload("res://PartyScreen.tscn")
var game_types = [preload("res://BattleRoyale.tscn")]

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

func make_new_lobby():#makes a new lobby object, inserts it into the tree, and returns it. here is where the randomization should go.
	randomize()
	var index = 0
	var scene = game_types[index]
	var instance = scene.instance()
	add_child(instance)
	return instance
	
func make_party_screen():
	var instance = lobby_game_type.instance()
	add_child(instance)
	return instance

func _Peer_Connected(player_id):
	print("User " + str(player_id) + " connected.")

func reassign_party_to_lobby(var party,var lobby):
	for pid in party.playerIDs:
		lobby.add_player(pid)
		rpc_id(pid,"setlobby",lobby.systemname(),lobby.name)
	party.lobby.queue_free()
	party.lobby = lobby

remote func party_ready():
	var party = partyHandler.get_party_by_player(get_tree().get_rpc_sender_id())
	if party!=null:
		reassign_party_to_lobby(party,make_new_lobby())
	else:
		print("Attempted to mark a party as ready that does not exist.")
		print("Player code: ",get_tree().get_rpc_sender_id())

remote func create_party():
	var player_id = get_tree().get_rpc_sender_id()
	print("Creating party...")
	var newparty = partyHandler.new_party(player_id)
	print("Code: " + str(newparty.code))
	print("Players: " + str(newparty.playerIDs))
	newparty.lobby = make_party_screen()
	rpc_id(player_id,"setlobby",newparty.lobby.systemname(),newparty.lobby.name)

remote func join_party(var partyID):
	var player_id = get_tree().get_rpc_sender_id()
	print("Joining party")
	partyHandler.join_party_by_id(player_id, partyID)

func _Peer_Disconnected(player_id):
	var party = partyHandler.get_party_by_player(player_id)
	if party!=null:
		var lobby = party.lobby
		lobby.remove_player(player_id)
		if lobby.player_count()==0: lobby.queue_free()
		partyHandler.leave_party(player_id)
	print("User " + str(player_id) + " disconnected.")
	







