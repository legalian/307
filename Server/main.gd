extends Node2D
# Party Management Variables ###################################################
const PartyHandler = preload("res://PartyHandler.gd")
const PartyPlayer = preload("res://PartyPlayer.gd")

var network = NetworkedMultiplayerENet.new()
var partyHandler
var port = 1909
var max_players = 3000

var party_screen = preload("res://PartyScreen/World.tscn")

# Lobby Management Variables ###################################################

const LobbyHandler=preload("res://LobbyHandler.gd")
var lobbyHandler

var matchmaking_pool=[] # This is used as a queue

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

func make_new_minigame(var minigame):#makes a new minigame object, inserts it into the tree, and returns it.	
	var instance = minigame.instance()#it's really important that this method isn't called more than once- it has side effects.
	instance.name = instance.systemname()
	add_child(instance,true)
	return instance
	
func make_party_screen():
	var instance = party_screen.instance()
	instance.name = instance.systemname()
	add_child(instance,true)
	return instance

func _Peer_Connected(player_id):
	print("User " + str(player_id) + " connected.")

func reassign_party_to_minigame(var party,var minigame):
	for player in partyHandler.get_players_in_party(party):
		rpc_id(player.playerID,"setminigame",minigame.systemname(),minigame.name)
		minigame.add_player(player)
		print("setting ",minigame.name,minigame.get_path())
	if (party.minigame != null):
		party.minigame.queue_free()
	else:
		print("Attempted to queue_free() null minigame")
	party.minigame = minigame

remote func party_ready():
	var party = partyHandler.get_party_by_player(get_tree().get_rpc_sender_id())
	if party!=null:
		var lobby_code = matchmake(party)
		
		if (lobby_code == null):
			print("Matchmaking failed")
			print("lobby_code = NULL @@ party_ready()")
			return
		
		var lobby = lobbyHandler.get_lobby(lobby_code)
		
		if (lobby == null):
			print("Lobby not created properly")
			print("lobby_code = " + lobby_code)
			print("lobby = null @@ party_ready()")
		
		debug_print_lobbies()
		
		reassign_party_to_minigame(party, make_new_minigame(lobby.get_current_minigame()))
		# No need to return anything; reassign_party_to_minigame will call the client
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
	rpc_id(player_id,"setminigame",newparty.minigame.systemname(),newparty.minigame.name)
	newparty.minigame.add_player(partyHandler.player_objects.get(player_id))
	print("Systemname: " + newparty.minigame.systemname())
	send_party_code_to_client(player_id, newparty.code)

remote func join_party(var partyID):
	var player_id = get_tree().get_rpc_sender_id()
	print("Joining party")
	var joined_party = partyHandler.join_party_by_id(player_id, partyID)
	send_party_code_to_client(player_id, joined_party.code)
	if (joined_party.minigame != null && str(joined_party.code) != str(PartyHandler.invalid_party_id)):
		print("Players: " + str(joined_party.playerIDs))
		rpc_id(player_id,"setminigame",joined_party.minigame.systemname(),joined_party.minigame.name)
	else:
		print("Party code invalid: " + str(partyID))

func send_party_code_to_client(var clientID, var partyID):
	rpc_id(clientID, "receive_party_code", partyID)

func _Peer_Disconnected(player_id):
	var party = partyHandler.get_party_by_player(player_id)
		
	if party!=null:
		var minigame = party.minigame
		if minigame!=null:
			minigame.remove_player(player_id)
			if minigame.player_count()==0:minigame.queue_free()
		partyHandler.leave_party(player_id)
		
		# Player has left, freeing up space in lobby; matchmake again
		print("Attempting to matchmake_pool()")
		matchmake_pool()
		
		if (party.playerIDs.size() == 0):
			print("Party size detected to be empty, removing from lobby")
			lobbyHandler.remove_from_lobby(party)
			debug_print_lobbies()
	
	print("User " + str(player_id) + " disconnected.")	

###############################################################################
# @desc
# This function can be called by going through party_ready(). This should be done
# for solo queue as well as party queue.
#
# @param
# party:		This a Party object that has the playerIDs filled out.
#
# @returns
# lobby_id:		This will contain the id of either a new lobby or existing
#				lobby. The Lobby object will be stored inside LobbyHandler.gd,
#				and can be accessed via LobbyHandler.get_lobby(lobby_id), which
#				returns a Lobby.gd object. 
###############################################################################
var test_bool = false
# Use this boolean to simulate matchmaking failing.
func matchmake(var party):
	print("\n\n" + str(party.playerIDs.size()) + " player(s) have requested to matchmake.\n")
	print("Here are the players that have requested to matchmake under party " + str(party.code) + ":")
	for playerID in party.playerIDs:
		print("\tPlayerID:" + str(playerID) + "\n")
	
	# Check if party list size is less than 0.
	if (party.playerIDs.size() <= 0):
		print("FATAL ERROR @@ REMOTE FUNC MATCHMAKE(PARTY_SIZE): party_size is <= 0")
		return null
	
	print("Added Party " + str(party.code) + " to the matchmaking pool")
	matchmaking_pool.append(party)
	debug_print_matchmaking_pool()

	if (test_bool):
		print("Test bool detected! FORCIBLY RETURNING NULL ON MATCHMAKING")
		test_bool = false
		return
	
	print("Processing party! Attempting to add to lobby")
	# Try to send them to a lobby and get the code
	var lobby_code = lobbyHandler.add_to_lobby(party)
	
	# Trying to check for cstatus here will not work.
	
	if (lobby_code != null): # We've gotten a lobby
		matchmaking_pool.remove(matchmaking_pool.find(party))
		print("Set lobby code " + str(lobby_code) + " to party " + str(party.code))
		party.lobby_code = lobby_code
		debug_print_matchmaking_pool()
		return lobby_code
	
	debug_print_matchmaking_pool()
	return null

################################################################################
# @desc
# Goes through the entire pool and tries to get as many players into lobbies
# as possible. First come first serve.
# This should be called whenever a party disconnects.
################################################################################

func matchmake_pool():
	print("Attempting to matchmake as many players in the pool as possible")
	for party in matchmaking_pool: # Go through the entire pool
		var lobby_code = lobbyHandler.add_to_lobby(party)
		
		if (lobby_code == null):
			print("Matchmaking Pool failed")
			print("lobby_code = NULL @@ matchmake_pool()")
			debug_print_matchmaking_pool()
			continue
		
		var lobby = lobbyHandler.get_lobby(lobby_code)
		
		if (lobby == null):
			print("Matchmaking Pool lobby not created properly")
			print("lobby code = " + str(lobby_code))
			print("lobby = NULL @@ matchmake_pool()")
			debug_print_matchmaking_pool()
			continue
		
		# we have a valid party!
		matchmaking_pool.remove(matchmaking_pool.find(party))
		reassign_party_to_minigame(party, make_new_minigame(lobby.get_current_minigame()))
		debug_print_matchmaking_pool()
	return
	
################################################################################
# @desc
# Removes a party from the matchmaking pool. If called while matchmake_pool()
# has found a lobby, matchmake_pool() will override this, and the party
# will be forced into the game.
################################################################################
remote func cancel_matchmaking():
	var playerID = get_tree().get_rpc_sender_id()
	var party = partyHandler.get_party_by_player(playerID)
	
	matchmaking_pool.remove(matchmaking_pool.find(party))
	debug_print_matchmaking_pool()

func debug_print_matchmaking_pool():
	print("\n ========= MATCHMAKING POOL DEBUG =========")
	print("Matchmaking Pool Size: " + str(matchmaking_pool.size()) + "\n")
	
	print("~PARTY LIST~")
	for party in matchmaking_pool:
		party.debug_print()
	
	print("\n ========= MATCHMAKING POOL DEBUG =========\n")

func debug_print_lobbies():
	lobbyHandler.debug_print()
	
	for lobby in lobbyHandler.get_lobbies().values():
		lobby.debug_print()
