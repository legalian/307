extends Node2D
# Party Management Variables ###################################################
const PartyHandler = preload("res://PartyHandler.gd")
const PartyPlayer = preload("res://PartyPlayer.gd")

var network = NetworkedMultiplayerENet.new()
var partyHandler
var port = 1909
var max_players = 3000

var party_screen = preload("res://PartyScreen.tscn")

# Lobby Management Variables ###################################################

const LobbyHandler=preload("res://LobbyHandler.gd")
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

func make_new_minigame(var minigame):#makes a new minigame object, inserts it into the tree, and returns it.	
	var instance = minigame.instance()#it's really important that this method isn't called more than once- it has side effects.
	instance.name = instance.systemname()
	add_child(instance)
	return instance
	
func make_party_screen():
	var instance = party_screen.instance()
	instance.name = instance.systemname()
	add_child(instance)
	return instance

func _Peer_Connected(player_id):
	print("User " + str(player_id) + " connected.")

func reassign_party_to_minigame(var party,var minigame):
	for player in partyHandler.get_players_in_party(party):
		minigame.add_player(player)
		rpc_id(player.playerID,"setminigame",minigame.systemname(),minigame.name)
		print("setting ",minigame.name,minigame.get_path())
	party.minigame.queue_free()
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
	newparty.minigame.add_player(partyHandler.player_objects.get(player_id))
	print("Systemname: " + newparty.minigame.systemname())
	rpc_id(player_id,"setminigame",newparty.minigame.systemname(),newparty.minigame.name)
	send_party_code_to_client(player_id, newparty.code)

remote func join_party(var partyID):
	var player_id = get_tree().get_rpc_sender_id()
	print("Joining party")
	var joined_party = partyHandler.join_party_by_id(player_id, partyID)
	if (str(joined_party.code) != str(PartyHandler.invalid_party_id)):
		print("Players: " + str(joined_party.playerIDs))
		send_party_code_to_client(player_id, joined_party.code)
	else:
		print("Lobby code invalid: " + str(partyID))
		send_party_code_to_client(player_id, joined_party.code)

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
		
		if (party.playerIDs.size() == 0):
			print("Party size detected to be empty, removing from lobby")
			lobbyHandler.remove_from_lobby(party)
	
	print("User " + str(player_id) + " disconnected.")

###############################################################################
# @desc
# This function can be called by rpc("matchmake", party_list) from the client.
# When called, the function must be given an array of PartyPlayer objects.
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
remote func matchmake(party):
	print("\n\n" + str(party.playerIDs.size()) + " player(s) have requested to matchmake.\n")
	print("Here are the players that have requested to matchmake under party " + str(party.code) + ":")
	for playerID in party.playerIDs:
		print("\tPlayerID:" + str(playerID) + "\n")
	
	# Check if party list size is less than 0.
	if (party.playerIDs.size() <= 0):
		print("FATAL ERROR @@ REMOTE FUNC MATCHMAKE(PARTY_SIZE): party_size is <= 0")
		return null
	
	print("Added Party " + str(party.code) + " to the matchmaking pool")

	while true:
		# Try to send them to a lobby and get the code
		var lobby_code = lobbyHandler.add_to_lobby(party)
		
		if (lobby_code != null): # We've gotten a lobby
			print("Set lobby code " + str(lobby_code) + " to party " + str(party.code))
			party.lobby_code = lobby_code
			return lobby_code
		
		for player_id in party.playerIDs:
			if (rpc_id(player_id,"get_lobby_cstatus")):
				# Implement this clientside; check if any player has cancelled
				return null
