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
var LobbyHandler=load("res://LobbyHandler.gd")
var lobbyHandler

var matchmaking_pool=[] # This is used as a queue
# Matchmaking pool contains parties that are added to lobbies and not added as well.
# Parties which are added to lobbies just need to be started. When they are, they will be removed
# From the matchmaking pool.
# Parties which are not added to lobbies will be added when calling matchmaking_pool.
	
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
		if (party.playerIDs.size() <= 0):
			print("Party doesn't have any players!")
			return
		
		matchmaking_pool.append(party)
		
		print("Party_ready finished, calling matchmake_pool()")
			
		debug_print_lobbies()
		debug_print_matchmaking_pool()
		matchmake_pool()
	else:
		print("Attempted to mark a party as ready that does not exist.")
		print("Player code: ",get_tree().get_rpc_sender_id())
		
		debug_print_lobbies()
		debug_print_matchmaking_pool()

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
		joined_party.minigame.add_player(partyHandler.player_objects.get(player_id))
	else:
		print("Party code invalid: " + str(partyID))

func send_party_code_to_client(var clientID, var partyID):
	rpc_id(clientID, "receive_party_code", partyID)

func go_to_next_minigame(var player_id):
	var party = partyHandler.get_party_by_player(player_id)
	var lobby = lobbyHandler.get_lobby(party.lobby_code)
	
	if (lobby.go_to_next_minigame()):
		# There were no errors
		var minigame = make_new_minigame(lobby.get_current_minigame())
		for parties in lobby.get_parties():
			reassign_party_to_minigame(parties, minigame)
	else:
		print("\n\n Go To Next Minigame failed!\n\n")

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
			party.lobby_code = "defaultCode"
			debug_print_lobbies()
	
	print("User " + str(player_id) + " disconnected.")	

func matchmake_pool():
	print("Attempting to matchmake as many players in the pool as possible")
	var ret
	for party in matchmaking_pool: # Go through the entire pool and add to lobbies
		if (str(party.lobby_code) == "defaultCode"):
			# Only add to a lobby if the party is not in one.
			lobbyHandler.add_to_lobby(party)
			# The lobby code is in party.lobby_code
	
	# Start the lobbies that can and remove them from the pool
	for party in matchmaking_pool:
		var lobby = lobbyHandler.get_lobby(party.lobby_code)
		if (lobby.lobby_code != null &&
			str(lobby.lobby_code) != "defaultCode" &&
			lobby.can_start):
			
			# Start the game!
			lobby.in_game = true
			var minigame = make_new_minigame(lobby.get_current_minigame())
			for parties in lobby.get_parties():
				matchmaking_pool.erase(parties)
				reassign_party_to_minigame(parties, minigame)

	print("\n\n Matchmaking Pool finished \n\n")
	debug_print_lobbies()
	debug_print_matchmaking_pool()
	
remote func cancel_matchmaking():
	var playerID = get_tree().get_rpc_sender_id()
	var party = partyHandler.get_party_by_player(playerID)
	
	# There are two places the player can be in: the pool, or an unstarted lobby.
	# We want to remove from the pool,
	# or remove from the lobby; but do not remove from party.
	matchmaking_pool.erase(party)
	print("      Removing party from lobby")
	lobbyHandler.remove_from_lobby(party)
	party.lobby_code = "defaultCode"
	
	# Here, we DON'T want to iterate through the lobby and disconnect everyone else.
	
	debug_print_lobbies()
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
