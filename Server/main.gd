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
		assigned_matches[iter] = false
	
	network.connect("peer_connected",self,"_Peer_Connected")
	network.connect("peer_disconnected",self,"_Peer_Disconnected")

func make_new_lobby():#makes a new lobby object, inserts it into the tree, and returns it.
	
	# TODO: Create random order of minigames.
	
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
	#partyHandler.leave_party(player_id)
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
func initialize_matchmaking():
	while (true):
		# Get first free match that hasn't started and < 20 players
		
		# Add party/players to that match if the result will still be within reqs
		
		# Repeat
		
		# yeh this line is red
