extends Node2D
# Party Management Variables ###################################################
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

# Lobby Management Variables ###################################################
const LobbyHandler=preload("res://LobbyHandler.gd")

var lobby_propagator

var lobbyHandler

func _ready():
	StartServer()
	
func StartServer():
	partyHandler = PartyHandler.new()
	
	# Create lobby handler
	lobbyHandler = LobbyHandler.new()
	
	network.create_server(port,max_players)
	get_tree().set_network_peer(network)
	print("Server started")
	
	network.connect("peer_connected",self,"_Peer_Connected")
	network.connect("peer_disconnected",self,"_Peer_Disconnected")

func make_new_minigame():#makes a new minigame object, inserts it into the tree, and returns it.
	randomize()
	var index = randi()%(game_types.size())
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

func reassign_party_to_minigame(var party,var minigame):
	for player in partyHandler.get_players_in_party(party):
		minigame.add_player(player)
		############################# setlobby cannot be changed because it is not changed clientside.####################
		rpc_id(player.playerID,"setlobby",minigame.systemname(),minigame.name)
	party.minigame.queue_free()
	party.minigame = minigame

remote func party_ready():
	var party = partyHandler.get_party_by_player(get_tree().get_rpc_sender_id())
	if party!=null:
		reassign_party_to_minigame(party,make_new_minigame())
	else:
		print("Attempted to mark a party as ready that does not exist.")
		print("Player code: ",get_tree().get_rpc_sender_id())

remote func create_party():
	var player_id = get_tree().get_rpc_sender_id()
	print("Creating party...")
	var newparty = partyHandler.new_party(player_id)
	print("Code: " + str(newparty.code))
	print("Players: " + str(newparty.playerIDs))
	newparty.minigame = make_party_screen()
	newparty.minigame.add_player(partyHandler.player_objects.get(player_id))
	##################### setlobby cannot be changed because it is not changed clientside.####################
	rpc_id(player_id,"setlobby",newparty.minigame.systemname(),newparty.minigame.name)

remote func join_party(var partyID):
	var player_id = get_tree().get_rpc_sender_id()
	print("Joining party")
	partyHandler.join_party_by_id(player_id, partyID)

func _Peer_Disconnected(player_id):
	var party = partyHandler.get_party_by_player(player_id)
	if party!=null:
		var minigame = party.minigame
		minigame.remove_player(player_id)
		if minigame.player_count()==0: minigame.queue_free()
		partyHandler.leave_party(player_id)
	print("User " + str(player_id) + " disconnected.")
	
###############################################################################
# @desc
# This function can be called by rpc("delete_lobby", lobby_id) from the client.
# This will free up the lobby from the server.
#
# @param
# lobby_id:		This parameter should be given from the functional call by the
#				client with rpc("matchmake", party_list).
###############################################################################
remote func delete_lobby(var lobby_id):
	lobbyHandler.delete_lobby(lobby_id)

###############################################################################
# @desc
# This function can be called by rpc("get_lobby", lobby_id) from the client.
# This will return a Lobby.gd object that contains the minigame order, lobby_id,
# and the lobby's players consisting of PlayerParty.gd objects.
#
# @param
# lobby_id:		This parameter should be given from the functional call by the
#				client with rpc("matchmake", party_list).
#
# @returns
# Lobby:		A Lobby.gd object that matches the given lobby_id. If no
#				lobby_id matches, then null is returned instead.
###############################################################################
remote func get_lobby(var lobby_id):
	return lobbyHandler.get_lobby(lobby_id)

###############################################################################
# @desc
# This function can be called by rpc("matchmake", party_list) from the client.
# When called, the function must be given an array of PartyPlayer objects.
#
# @param
# party_list:	The party list is a list of PartyPlayer objects, each of which
#				represent a player in the party.
#
# @returns
# lobby_id:		This will contain the id of either a new lobby or existing
#				lobby. The Lobby object will be stored inside LobbyHandler.gd,
#				and can be accessed via LobbyHandler.get_lobby(lobby_id), which
#				returns a Lobby.gd object. 
###############################################################################
remote func matchmake(party_list):
	print(str(party_list.size()) + "player(s) have requested to matchmake. Party list:" + party_list)
	
	# Check if party list size is less than 0.
	if (party_list.size() <= 0):
		print("FATAL ERROR @@ REMOTE FUNC MATCHMAKE(PARTY_SIZE): party_size is <= 0")
		return null
	
	print("Added " + party_list + " to the matchmaking pool")
	
	while true: # Constantly try to add to a lobby
		var lobby_code = lobbyHandler.add_to_lobby(party_list)
		# Try to send them to a lobby and get the code
		if (lobby_code != null): # Cannot enter a lobby
			return lobby_code
		
		for player in party_list:
			if (rpc_id(player.playerID,"get_lobby_cstatus")):
				# Implement this clientside; check if any player has cancelled
				return null
