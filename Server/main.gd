extends Node2D

# Constants
const PartyHandler = preload("res://PartyHandler.gd")
const PartyPlayer = preload("res://PartyPlayer.gd")
const party_screen = preload("res://PartyScreen/World.tscn")
const LobbyHandler=preload("res://LobbyHandler.gd")

const port = 1909
const max_players = 3000


# Internal Data Structures
var matchmaking_pool=[]


# Global variables
var network = NetworkedMultiplayerENet.new()
var partyHandler
var lobbyHandler
var test_script_party


func _ready():
	StartServer()

func StartServer():
	print("\n\t>>> StartServer()")
	
	partyHandler = PartyHandler.new()
	
	# Create lobby handler
	lobbyHandler = LobbyHandler.new()
	
	network.create_server(port,max_players)
	get_tree().set_network_peer(network)
	print("Server started")
	
	network.connect("peer_connected",self,"_Peer_Connected")
	network.connect("peer_disconnected",self,"_Peer_Disconnected")
	print("\t<<< StartServer()\n")

# Makes a new minigame object, inserts it into the tree, and returns it.
func make_new_minigame(var minigame):
	print("\n\t>>> make_new_minigame()")
	if (minigame == null):
		print("Attempted to make_new_minigame(null)")
		print("<!<!<! make_new_minigame()\n")
		return
	
	# Do not call .instance() more than once.
	var instance = minigame.instance()
	instance.name = instance.systemname()
	print("Minigame name from instance: " + instance.systemname())
	add_child(instance,true)
	print("\t<<< make_new_minigame()\n")
	return instance
	
func make_party_screen():
	print("\n\t>>> make_party_screen()")
	var instance = party_screen.instance()
	instance.name = instance.systemname()
	add_child(instance,true)
	print("\t<<< make_party_screen()\n")
	return instance


func reassign_party_to_minigame(var party,var minigame):
	print("\n\t>>> reassign_party_to_minigame()")
	for player in partyHandler.get_players_in_party(party):
		
		rpc_id(player.playerID, "setminigame",
			   minigame.systemname(), minigame.name)
		
		minigame.add_player(player)
		print("setting ",minigame.name,minigame.get_path())
	if (party.minigame != null):
		print("queue_freeing " + str(party.minigame.systemname()))
		party.minigame.queue_free()
	else:
		print("Attempted to null.queue_free() in reassign_party_to_minigame()")
	party.minigame = minigame
	print("\t<<< reassign_party_to_minigame()\n")

remote func party_ready():
	print("\n\t>>> party_ready()")
	var party = partyHandler.get_party_by_player(get_tree().get_rpc_sender_id())
	if party!=null:
		if (party.playerIDs.size() <= 0):
			print("party.playerIDs.size() <= 0 in party_ready()")
			print("<!<!<! party_ready()\n")
			return
		
		matchmaking_pool.append(party)
		matchmake_pool()
	else:
		print("party = null in party_ready()")
		print("Player code: ", get_tree().get_rpc_sender_id())
		
		debug_print_lobbies()
		debug_print_matchmaking_pool()
	
	print("\t<<< party_ready()\n")

remote func create_party(packed):
	print("\n\t>>> create_party()")
	var player_id = get_tree().get_rpc_sender_id()
	print("Creating party...")
	var newparty = partyHandler.new_party(player_id)
	partyHandler.player_objects.get(player_id).unpack(packed)
	print("Code: " + str(newparty.code))
	print("Players: " + str(newparty.playerIDs))
	newparty.minigame = make_party_screen()
	
	rpc_id(player_id, "setminigame", 
		   newparty.minigame.systemname(), newparty.minigame.name)
	
	newparty.minigame.add_player(partyHandler.player_objects.get(player_id))
	print("Systemname: " + newparty.minigame.systemname())
	send_party_code_to_client(player_id, newparty.code)
	print("\t<<< create_party()\n")

remote func leave_party(var partyID, packed):
	print("\n\t>>> leave_party()")
	var player_id = get_tree().get_rpc_sender_id()
	var party_id = partyHandler.get_party_by_player(player_id)
	print("party_id: " + str(party_id))
	if (party_id != null):
		print("Sending leave party to partyhandler")
		var joined_party = partyHandler.get_party_by_player(player_id)
		joined_party.minigame.remove_player(player_id)
		partyHandler.leave_party(player_id)
		print("Updated playerlist: " + str(joined_party.playerIDs))
		unintroduce(player_id, joined_party.playerIDs)

remote func join_party(var partyID, packed):
	print("\n\t>>> join_party()")
	var player_id = get_tree().get_rpc_sender_id()
	if (partyHandler.parties.has(str(partyID)) &&
		!partyHandler.parties[str(partyID)].in_game):
		
		var joined_party = partyHandler.join_party_by_id(player_id, partyID)
		partyHandler.player_objects.get(player_id).unpack(packed)
		send_party_code_to_client(player_id, joined_party.code)
		
		if (joined_party.minigame != null &&
			str(joined_party.code) != str(PartyHandler.invalid_party_id)):
			
			print("Players: " + str(joined_party.playerIDs))
			
			rpc_id(player_id, "setminigame", 
				   joined_party.minigame.systemname(), 
				   joined_party.minigame.name)
			
			joined_party.minigame.add_player(
				partyHandler.player_objects.get(player_id))
			
			mutually_introduce(joined_party.playerIDs)
		else:
			print("Party code invalid: " + str(partyID))
			print("<!<!<! join_party()\n")
			return
	else:
		print("Party is already in game.")
		print("<!<!<! join_party()\n")
		return
	
	print("\t<<< join_party()\n")

func send_party_code_to_client(var clientID, var partyID):
	print("\n\t>>> send_party_code_to_client()")
	rpc_id(clientID, "receive_party_code", partyID)
	print("\t<<< send_party_code_to_client()\n")

func go_to_next_minigame(var player_id):
	print("\n\t>>> go_to_next_minigame()")
	var party = partyHandler.get_party_by_player(player_id)
	var lobby = lobbyHandler.get_lobby(party.lobby_code)
	
	if (lobby.go_to_next_minigame()):
		# There were no errors
		var minigame = make_new_minigame(lobby.get_current_minigame())
		for parties in lobby.parties:
			reassign_party_to_minigame(parties, minigame)
		print("\n\n NEXT MINIGAME ASSIGNED: " +
			  str(minigame.systemname()) + "\n\n")
	else:
		print("\n\n Go To Next Minigame failed!\n\n")
		print("\t<!<!<! go_to_next_minigame()\n")
		return
	
	print("\t<<< go_to_next_minigame()\n")

func _Peer_Disconnected(player_id):
	print("\n\t>>> peer_disconnected()")
	var party = partyHandler.get_party_by_player(player_id)
	_disconnect_handle_mut(player_id)
	if party!=null:
		print("Party was not null.")
		var minigame = party.minigame
		if minigame!=null:
			minigame.remove_player(player_id)
			if minigame.player_count()==0:minigame.queue_free()
		partyHandler.leave_party(player_id)
		
		matchmaking_pool.erase(party)
		
		var lobbyin = lobbyHandler.get_lobby(party.lobby_code)
		if lobbyin: unintroduce(player_id,lobbyin.get_player_ids())

		if lobbyin!=null:
			print("Lobby has " + str(lobbyin.get_occupied()) +
				  " players in it")
			if (lobbyin.get_occupied() < lobbyin.min_players_per_lobby):
				# Lobby does not have enough players.
				for allparty in lobbyin.parties:
					for playerID in allparty.playerIDs:
						print("Disconnecting player " + str(playerID) +
							  " from network")
						network.disconnect_peer(playerID, false)
				
				# Delete the lobby
				lobbyHandler.delete_lobby(lobbyin.lobby_code)
	
	matchmake_pool()
	print("User " + str(player_id) + " disconnected.")
	print("\t<<< peer_disconnected()\n")

func unintroduce(player_id,players):
	print("\n\t>>> unintroduce()")
	for player in players:
		rpc_id(player,"drop_player",player_id)
	print("\t<<< unintroduce()\n")

func mutually_introduce(players):
	print("\n\t>>> mutually_introduce()")
	var ba = []
	for player in players: ba.append(partyHandler.player_objects[player].pack())
	for player in players: rpc_id(player,"add_players",ba)
	print("\t<<< mutually_introduce()\n")

func matchmake_pool():
	print("\n\t>>> matchmake_pool()")
	for party in matchmaking_pool:
		# Go through the entire pool and add to lobbies
		if (str(party.lobby_code) == "defaultCode"):
			# Only add to a lobby if the party is not in one.
			if lobbyHandler.add_to_lobby(party):
				print("-=-=-=-")
				print(party.lobby_code)
				print(lobbyHandler.get_lobby(party.lobby_code))
				mutually_introduce(
					lobbyHandler.get_lobby(party.lobby_code).get_player_ids())
			# The lobby code is in party.lobby_code
	
	# Start the lobbies that can and remove them from the pool
	for party in matchmaking_pool:
		var lobby = lobbyHandler.get_lobby(party.lobby_code)
		if (lobby.lobby_code != null &&
			str(lobby.lobby_code) != "defaultCode" &&
			lobby.can_start):
			
			
			# Start the game!
			lobby.in_game = true
			var multi_user_testing = OS.get_environment("MULTI_USER_TESTING")
			var minigame = null
			#Note: "party", "lobby", and "quickplay" all have the same effect
			# when called through the multi user testing script.
			var scenes_no_shim = {
				"party":preload("res://PartyScreen/World.tscn"),
				"lobby":preload("res://PartyScreen/World.tscn"),
				"quickplay":preload("res://PartyScreen/World.tscn"),
				"podium":preload("res://Podium/World.tscn"),
				"battleroyale":preload("res://BattleRoyale/World.tscn"),
				"racing":preload("res://RacingGame/World.tscn"),
				"demoderby":preload("res://DemoDerby/World.tscn"),
				"confusingcaptcha":preload("res://ConfusingCaptcha/World.tscn")
				}
			
			if (scenes_no_shim.has(multi_user_testing) &&
				 multi_user_testing != "party" &&
				 multi_user_testing != "lobby" &&
				 multi_user_testing != "quickplay"):
				
				print("Minigame specified: " + multi_user_testing)
				minigame = make_new_minigame(scenes_no_shim[multi_user_testing]);

			else:
				minigame = make_new_minigame(lobby.get_current_minigame())
			for parties in lobby.parties:
				parties.in_game = true;
				matchmaking_pool.erase(parties)
				reassign_party_to_minigame(parties, minigame)
	
	debug_print_lobbies()
	debug_print_matchmaking_pool()
	print("\t<<< matchmake_pool()\n")

remote func cancel_matchmaking():
	print("\n\t>>> cancel_matchmaking()")
	var playerID = get_tree().get_rpc_sender_id()
	var party = partyHandler.get_party_by_player(playerID)
	var lobby = lobbyHandler.get_lobby(party.lobby_code)
	
	# There are two places the player can be in: the pool, or an unstarted lobby.
	# We want to remove from the pool,
	# or remove from the lobby; but do not remove from party.
	matchmaking_pool.erase(party)
	print("      Removing party from lobby")
	if (lobby != null):
		lobbyHandler.remove_from_lobby(party)
		# Do not disconnect from server!
	
	party.lobby_code = "defaultCode"
	
	debug_print_lobbies()
	debug_print_matchmaking_pool()
	print("\t<<< cancel_matchmaking()\n")

func debug_print_matchmaking_pool():
	print("\n ========= MATCHMAKING POOL DEBUG =========")
	print("Matchmaking Pool Size: " + str(matchmaking_pool.size()) + "\n")
	
	print("~PARTY LIST~")
	for party in matchmaking_pool:
		party.debug_print()
	
	print("\n ========= MATCHMAKING POOL DEBUG =========\n")

func debug_print_lobbies():
	lobbyHandler.debug_print()
	
	for lobby in lobbyHandler.lobbies.values():
		lobby.debug_print()

var shims = {
		"podium_shim":preload("res://Podium/World.tscn"),
		"battleroyale_shim":preload("res://BattleRoyale/World.tscn"),
		"racing_shim":preload("res://RacingGame/World.tscn"),
		"demoderby_shim":preload("res://DemoDerby/World.tscn"),
		"confusingcaptcha_shim":preload("res://ConfusingCaptcha/World.tscn")
		}
		
func _Peer_Connected(player_id):
	print("User " + str(player_id) + " connected.")
	var multi_user_testing = OS.get_environment("MULTI_USER_TESTING")

	
	#Note: "party", "lobby", and "quickplay" all have the same effect
	# when called through the multi user testing script
	var scenes_no_shim = {
		"party":preload("res://PartyScreen/World.tscn"),
		"lobby":preload("res://PartyScreen/World.tscn"),
		"quickplay":preload("res://PartyScreen/World.tscn"),
		"podium":preload("res://Podium/World.tscn"),
		"battleroyale":preload("res://BattleRoyale/World.tscn"),
		"racing":preload("res://RacingGame/World.tscn"),
		"demoderby":preload("res://DemoDerby/World.tscn"),
		"confusingcaptcha":preload("res://ConfusingCaptcha/World.tscn")
		}
	
	if (scenes_no_shim.has(multi_user_testing)):
		print ("Starting minigame " + str(multi_user_testing) + " without shim")

	
	var shims = {
		"podium_shim":preload("res://Podium/World.tscn"),
		"battleroyale_shim":preload("res://BattleRoyale/World.tscn"),
		"racing_shim":preload("res://RacingGame/World.tscn"),
		"demoderby_shim":preload("res://DemoDerby/World.tscn"),
		"confusingcaptcha_shim":preload("res://ConfusingCaptcha/World.tscn")
	}
		#,}
	
	print("multi_user_testing = " + str(multi_user_testing))
	if shims.has(multi_user_testing):
		var dummyobj = PartyPlayer.new(1010101010, null);
		var dummyobj2 = PartyPlayer.new(1010101011, null);
		dummyobj.dummy = 1;
		dummyobj2.dummy = 1;
		var playerobj = PartyPlayer.new(player_id, null);
		
		rpc_id(player_id, "add_players", 
			[playerobj.pack(),dummyobj.pack(),dummyobj2.pack()])
		
		var minigame = make_new_minigame(shims[multi_user_testing]);
		print("Minigame name from server: " + minigame.systemname())
		rpc_id(player_id,"setminigame",minigame.systemname(),minigame.name)
		minigame.add_player(dummyobj)
		minigame.add_player(dummyobj2)
		minigame.add_player(playerobj)

func _disconnect_handle_mut(player_id):
	print("\n\t>>> _disconnect_handle_mut()")
	var multi_user_testing = OS.get_environment("MULTI_USER_TESTING")
	if shims.has(multi_user_testing): get_tree().quit()
	print("\t<<< _disconnect_handle_mut()\n")
