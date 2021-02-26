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

var game_types = [preload("res://BattleRoyale.tscn")]
var game_typenames = ["BattleRoyale"]
var assigned_lobbies = {}

#Note: This is a temporary variable I am using to test the party join/create system
var test_party_code

# Lobby Management Variables ###################################################
const LobbyHandler=preload("res://LobbyHandler.gd")

var lobby_propagator

var matchmaking_pool = [] # Array of parties that want to get into a lobby
var pool_mutex

var lobbyHandler




func _ready():
	StartServer()
	
func StartServer():
	partyHandler = PartyHandler.new()
	
	# Start async lobby checking service
	lobby_propagator = Thread.new()
	pool_mutex = Mutex.new()
	lobby_propagator.start(self, "_lobby_director")
	
	# Create lobby handler
	lobbyHandler = LobbyHandler.new()
	
	network.create_server(port,max_players)
	get_tree().set_network_peer(network)
	print("Server started")
	
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
# @desc
# This function can be called by rpc("matchmake", party_list) from the client.
#
# @param
# party_list:	The party list is a list of all players and their peer_ids'.
#				This will be needed to communicate to all players their
#				match_id. If the size of this list is <= 0, then an error will
#				be thrown.
#
# @returns
# lobby_id:		This id number will be unique per lobby. It should be used when
#				creating the lobby instances later on. If lobby_id is null, then
#				there was an error; you have not been placed in matchmaking.
###############################################################################
remote func matchmake(party_list):
	print(str(party_list.size()) + "player(s) have requested to matchmake. Party list:" + party_list)
	
	# Check if party list size is less than 0.
	if (party_list.size() <= 0):
		print("FATAL ERROR @@ REMOTE FUNC MATCHMAKE(PARTY_SIZE): party_size is <= 0")
		return null
	
	# Add the party to the matchmaking pool
	pool_mutex.lock()
	matchmaking_pool.append(party_list)
	pool_mutex.unlock()
	print("Added " + party_list + " to the matchmaking pool")
	
	
################################################################################
# @desc
# This function initializes the infinite loop that will constantly try and place
# players who are wating to be matchmaked into lobbies. It will be run async.
#
# Still need to do some research on how multithreading in gdscript works, not even sure if its supported tbh but it prolly is
#
# @returns
# match_id:		A match_id that is reserved for the pre-match room. (Industry term is lobby but not sure if that's the same lobby as above.)
################################################################################
func _lobby_director():
	while true: # Will the mutex unlock for the matchmake()?
		pool_mutex.lock() # Lock the matchmaking pool queue
		for party in matchmaking_pool: # Go through each party
			var lobby_code = lobbyHandler.add_to_lobby(party)
			# Try to send them to a lobby and get the code
			if (lobby_code == null): # Cannot enter a lobby
				break
			
			return lobby_code
		pool_mutex.unlock() # Unlock the matchmaking pool queue
		#sleep(1000) # TODO How to put a thread to sleep??
