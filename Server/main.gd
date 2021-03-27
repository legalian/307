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
var LobbyHandler=preload("res://LobbyHandler.gd")
var lobbyHandler

var matchmaking_pool=[] # This is used as a queue
# Matchmaking pool contains parties that are added to lobbies and not added as well.
# Parties which are added to lobbies just need to be started. When they are, they will be removed
# From the matchmaking pool.
# Parties which are not added to lobbies will be added when calling matchmaking_pool.
	
	
var test_script_party

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

	if (minigame == null):
		print("MINIGAME IS NULL!!!!")
	
	var instance = minigame.instance()#it's really important that this method isn't called more than once- it has side effects.
	instance.name = instance.systemname()
	add_child(instance,true)
	return instance
	
func make_party_screen():
	var instance = party_screen.instance()
	instance.name = instance.systemname()
	add_child(instance,true)
	return instance


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

remote func create_party(packed):
	var player_id = get_tree().get_rpc_sender_id()
	print("Creating party...")
	var newparty = partyHandler.new_party(player_id)
	partyHandler.player_objects.get(player_id).unpack(packed)
	print("Code: " + str(newparty.code))
	print("Players: " + str(newparty.playerIDs))
	newparty.minigame = make_party_screen()
	rpc_id(player_id,"setminigame",newparty.minigame.systemname(),newparty.minigame.name)
	newparty.minigame.add_player(partyHandler.player_objects.get(player_id))
	print("Systemname: " + newparty.minigame.systemname())
	send_party_code_to_client(player_id, newparty.code)

remote func join_party(var partyID,packed):
	var player_id = get_tree().get_rpc_sender_id()
	print("Joining party")
	if (partyHandler.parties.has(str(partyID)) && !partyHandler.parties[str(partyID)].in_game):
		var joined_party = partyHandler.join_party_by_id(player_id, partyID)
		partyHandler.player_objects.get(player_id).unpack(packed)
		send_party_code_to_client(player_id, joined_party.code)
		if (joined_party.minigame != null && str(joined_party.code) != str(PartyHandler.invalid_party_id)):
			print("Players: " + str(joined_party.playerIDs))
			rpc_id(player_id,"setminigame",joined_party.minigame.systemname(),joined_party.minigame.name)
			joined_party.minigame.add_player(partyHandler.player_objects.get(player_id))
			mutually_introduce(joined_party.playerIDs)
		else:
			print("Party code invalid: " + str(partyID))
	else:
		print("Party is already in game.")

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
		print("\n\n NEXT MINIGAME ASSIGNED: " + str(minigame.systemname()) + "\n\n")
	else:
		print("\n\n Go To Next Minigame failed!\n\n")

func _Peer_Disconnected(player_id):
	var party = partyHandler.get_party_by_player(player_id)
	_disconnect_handle_mut(player_id)
	print("DICONNECT CALLED")
	if party!=null:
		print("DICONNECT CALLED WITH PARTY")
		var minigame = party.minigame
		if minigame!=null:
			print("DICONNECTINGG FRAOM MINIGAME")
			minigame.remove_player(player_id)
			if minigame.player_count()==0:minigame.queue_free()
		partyHandler.leave_party(player_id)
		
		var lobbyin = lobbyHandler.get_lobby(party.lobby_code)
		if lobbyin: unintroduce(player_id,lobbyin.get_player_ids())
		# Player has left, freeing up space in lobby; matchmake again
		print("Attempting to matchmake_pool()")
		matchmake_pool()
		
		if (party.playerIDs.size() == 0):
			print("Party size detected to be empty, removing from lobby")
			lobbyHandler.remove_from_lobby(party)
			party.lobby_code = "defaultCode"
			debug_print_lobbies()
	
	print("User " + str(player_id) + " disconnected.")

func unintroduce(player_id,players):
	for player in players:
		rpc_id(player,"drop_player",player_id)

func mutually_introduce(players):
	var ba = []
	for player in players: ba.append(partyHandler.player_objects[player].pack())
	for player in players: rpc_id(player,"add_players",ba)

func matchmake_pool():
	print("Attempting to matchmake as many players in the pool as possible")
	var ret
	for party in matchmaking_pool: # Go through the entire pool and add to lobbies
		if (str(party.lobby_code) == "defaultCode"):
			# Only add to a lobby if the party is not in one.
			if lobbyHandler.add_to_lobby(party):
				print("-=-=-=-")
				print(party.lobby_code)
				print(lobbyHandler.get_lobby(party.lobby_code))
				mutually_introduce(lobbyHandler.get_lobby(party.lobby_code).get_player_ids())
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
			var minigame = make_new_minigame(lobby.get_current_minigame())
			#Note: "party", "lobby", and "quickplay" all have the same effect when called through the multi user testing script, and "demoderby" will be enabled when the demoderby game is in a playable state
			var scenes_no_shim = {"party":preload("res://PartyScreen/World.tscn"), "lobby":preload("res://PartyScreen/World.tscn"), "quickplay":preload("res://PartyScreen/World.tscn"), "podium":preload("res://Podium/World.tscn"), "battleroyale":preload("res://BattleRoyale/World.tscn"), "racing":preload("res://RacingGame/World.tscn")}
			if (scenes_no_shim.has(multi_user_testing) && multi_user_testing != "party" && multi_user_testing != "lobby" && multi_user_testing != "quickplay"):
				print("Minigame specified: " + multi_user_testing)
				minigame = make_new_minigame(scenes_no_shim[multi_user_testing]);
			for parties in lobby.get_parties():
				parties.in_game = true;
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


var shims = {"battleroyale_shim":preload("res://BattleRoyale/World.tscn"),"racing_shim":preload("res://RacingGame/World.tscn")}#,"demoderby_shim":preload("res://DemoDerby/World.tscn")}


func _Peer_Connected(player_id):
	print("User " + str(player_id) + " connected.")
	var multi_user_testing = OS.get_environment("MULTI_USER_TESTING")

	
	#Note: "party", "lobby", and "quickplay" all have the same effect when called through the multi user testing script, and "demoderby" will be enabled when the demoderby game is in a playable state
	var scenes_no_shim = {"party":preload("res://PartyScreen/World.tscn"), "lobby":preload("res://PartyScreen/World.tscn"), "quickplay":preload("res://PartyScreen/World.tscn"), "podium":preload("res://Podium/World.tscn"), "battleroyale":preload("res://BattleRoyale/World.tscn"), "racing":preload("res://RacingGame/World.tscn")}
	if (scenes_no_shim.has(multi_user_testing)):
		print ("Starting minigame " + str(multi_user_testing) + " without shim")
		#var thisTestParty = partyHandler.get_party_by_player(str(player_id))
		#print("thisTestParty: " + str(thisTestParty))
		#var minigame = make_new_minigame(scenes_no_shim[multi_user_testing]);
		#if (thisTestParty.playerIDs.size() >= 3):
		#	for player in thisTestParty.playerIDs:
		#		rpc_id(player,"setminigame",minigame.systemname(),minigame.name)
		#if (test_script_party == null):
			#test_script_party = partyHandler.new_party(player_id)
		#else:
			#partyHandler.join_party_by_id(player_id, test_script_party.code)
			#var playerobj = PartyPlayer.new(player_id, null);
			#partyHandler.join_party_by_id(player_id, "testPartyCode")
			#rpc_id(player_id,"add_players",[playerobj.pack()])
			#rpc_id(player_id,"setminigame",minigame.systemname(),minigame.name)
			#minigame.add_player(playerobj)
			#if (test_script_party.playerIDs.size() >= 3):
			#	for player in test_script_party.playerIDs:
			#		rpc_id(player,"setminigame",minigame.systemname(),minigame.name)
	
	var shims = {"podium_shim":preload("res://Podium/World.tscn"), "battleroyale_shim":preload("res://BattleRoyale/World.tscn"),"racing_shim":preload("res://RacingGame/World.tscn")}#,"demoderby_shim":preload("res://DemoDerby/World.tscn")}
	print("multi_user_testing = " + str(multi_user_testing))
	if shims.has(multi_user_testing):
		var dummyobj = PartyPlayer.new(1010101010, null);
		var dummyobj2 = PartyPlayer.new(1010101011, null);
		var playerobj = PartyPlayer.new(player_id, null);
		rpc_id(player_id,"add_players",[playerobj.pack(),dummyobj.pack(),dummyobj2.pack()])
		var minigame = make_new_minigame(shims[multi_user_testing]);
		rpc_id(player_id,"setminigame",minigame.systemname(),minigame.name)
		minigame.add_player(dummyobj)
		minigame.add_player(dummyobj2)
		minigame.add_player(playerobj)

func _disconnect_handle_mut(player_id):
	var multi_user_testing = OS.get_environment("MULTI_USER_TESTING")
	if shims.has(multi_user_testing): get_tree().quit()





