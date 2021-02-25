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

var assigned_matches = [] # This needs to be changed from var to a node that takes care of pre-match.
var player_queue = [] # GoDot does not have support for queues, using array instead. NOTE: This is a 2D array!!

#Note: This is a temporary variable I am using to test the party join/create system
var test_party_code

func _ready():
	StartServer()
	
func StartServer():
	partyHandler = PartyHandler.new()
	
	network.create_server(port,max_players)
	get_tree().set_network_peer(network)
	print("Server started")
	
	for iter in (max_players / min_players_per): # Assign all match ID slots to unoccupied.
		assigned_matches.append(false)
	
	network.connect("peer_connected",self,"_Peer_Connected")
	network.connect("peer_disconnected",self,"_Peer_Disconnected")

func make_new_lobby():#makes a new lobby object, inserts it into the tree, and returns it.
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

func reassign_party_to_lobby(var party,var lobby):
	for player in partyHandler.get_players_in_party(party):
		lobby.add_player(player)
		rpc_id(player.playerID,"setlobby",lobby.systemname(),lobby.name)
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
	newparty.lobby.add_player(partyHandler.player_objects.get(player_id))
	rpc_id(player_id,"setlobby",newparty.lobby.systemname(),newparty.lobby.name)

remote func join_party(var partyID):
	var player_id = get_tree().get_rpc_sender_id()
	print("Joining party")
	var joined_party = partyHandler.join_party_by_id(player_id, partyID)
	if (str(joined_party.code) != str(PartyHandler.invalid_party_id)):
		print("Players: " + str(joined_party.playerIDs))
	else:
		print("Lobby code invalid: " + str(partyID))

func _Peer_Disconnected(player_id):
	var party = partyHandler.get_party_by_player(player_id)
	if party!=null:
		var lobby = party.lobby
		lobby.remove_player(player_id)
		if lobby.player_count()==0: lobby.queue_free()
		partyHandler.leave_party(player_id)
	print("User " + str(player_id) + " disconnected.")
	
	
###############################################################################
# DESCRIPTION 
# This function can be called by rpc("matchmake", party_size) from the client.
#
# ARGUMENTS
# party_list:	The party list is a list of all players and their peer_ids'.
#				This will be needed to communicate to all players their
#				match_id. If the size of this list is <= 0, then an error will
#				be thrown.
#
# RETURNS
# match_id:		This id number will be unique per match. It should be used when
#				creating the match instances later on. If match_id is null, then
#				there was an error; you have not been placed in matchmaking.
###############################################################################
remote func matchmake(party_list):
	print(str(party_list.size()) + "player(s) have requested to matchmake. Party list:" + party_list)
	
	# Check if party list size is less than 0.
	if (party_list.size() <= 0):
		print("FATAL ERROR @@ REMOTE FUNC MATCHMAKE(PARTY_SIZE): party_size is <= 0")
		return null
	
	# TODO: Enqueue the list of IDs to the queue. The asynchronous script to 
	#		place players together should immediately take action.
	player_queue.append(party_list)
	
	while (true): # Keep looping until a free match_id is found. Need to implement cancellation.
		for match_id_iter in assigned_matches:
			if (!assigned_matches[match_id_iter]):
				assigned_matches[match_id_iter] = true
				return match_id_iter
				
	
	
################################################################################
# DESCRIPTION
# This function initializes the infinite loop that will constantly try and place
# players who are wating to be matchmaked into lobbies. It will be run async.
#
# Still need to do some research on how multithreading in gdscript works, not even sure if its supported tbh but it prolly is
#
# RETURNS
# match_id:		A match_id that is reserved for the pre-match room. (Industry term is lobby but not sure if that's the same lobby as above.)
################################################################################
#func initialize_matchmaking():
	#while (true):
		# Get first free match that hasn't started and < 20 players
		
		# Add party/players to that match if the result will still be within reqs
		
		# Repeat
		
		# yeh this line is red
