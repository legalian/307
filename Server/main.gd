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
		print("setting ")
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
	partyHandler.join_party_by_id(player_id, partyID)

func _Peer_Disconnected(player_id):
	var party = partyHandler.get_party_by_player(player_id)
	if party!=null:
		var lobby = party.lobby
		lobby.remove_player(player_id)
		if lobby.player_count()==0: lobby.queue_free()
		partyHandler.leave_party(player_id)
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
