extends Node

const Lobby=preload("res://Lobby.gd")
var lobbies = {}

var rng

var max_lobbies = 150

func _init(): # Called when LobbyHandler.new() is done
	rng = RandomNumberGenerator.new()
	rng.randomize()

func get_lobby(var lobby_id):
	if (str(lobby_id) == "defaultCode"):
		print("get_lobby() is called on the party screen!")
		# We're on the party screen, return nothing
		return
	if lobbies.has(lobby_id):
		return lobbies[lobby_id]
	return null

func get_lobbies():
	return lobbies

func delete_lobby(var lobby_id):
	lobbies.erase(lobby_id)

func create_lobby():	
	var tempLobby = Lobby.new(rng.randi_range(100000, 999999))
	while (key_taken(tempLobby.get_lobby_code())): # If taken,
		rng.randomize() # Randomize the generator
		tempLobby.set_lobby_code(rng.randi_range(100000, 999999)) # Generate another code
	

	if (lobbies.size() < max_lobbies):
		lobbies[tempLobby.get_lobby_code()] = tempLobby
		return tempLobby.get_lobby_code()
	
	return null

func remove_from_lobby(var party):
	if (party == null):
		print("Attempted to remove a null party from the lobby.")
		return false
	
	if (str(party.lobby_code) == "defaultCode"):
		print("Attempting to remove from 'PartyScreen' minigame; returning false")
		return false
	
	var lobby = get_lobby(party.lobby_code)
	if (lobby == null):
		print("Attempted to get lobby from invalid lobby code @@ remove_from_lobby()")
		return false
	
	if (!lobby.remove_party(party)):
		print("Error! Party was not removed correctly from the party!")
		# lobby.remove_party(party) should return true on success!	
		return false
	
	if (lobby.get_occupied() < lobby.min_players_per_lobby):
		print("Lobby is detected to not have enough parties, deleting from dictionary")
				
		# Disconnect all peers
		for party in lobby.get_parties():
			for playerID in party.playerIDs:
				print("Kicking player " + str(playerID) + " out")
				party.minigame.remove_player(playerID)
		
		delete_lobby(lobby.get_lobby_code())
		return true
	
	print("Some error occurred!")
	return false

func add_to_lobby(var party):
	for lobby in lobbies.values():
		# Loop through the lobbies that are created
		if ((lobby.max_players_per_lobby - lobby.get_occupied()) >= party.size() &&
			!lobby.in_game):
			
			# Checks if adding the party would make the lobby size too big,
			# and checks if the lobby hasn't started yet.
			
			if (lobby.add_party(party)):
				return true
	
	# Lobbies that are already created are all full or started; create a new one	
	var fresh_lobby_code = create_lobby()
	
	if (fresh_lobby_code != null): # New lobby was created successfully
		if (lobbies.get(fresh_lobby_code).add_party(party)):
			return true
	
	# New lobby was not created successfully; too many lobbies
	return false
	

func get_lobby_by_player(var playerID):
	for lobby in lobbies.values():
		if lobby.has_player(playerID):
			return lobby
	
	return null

func key_taken(var key):
	return lobbies.has(key)
	

func debug_print():
	print("\n ========= LOBBYHANDLER DEBUG ========= ")
	print("LOBBIES CREATED: " + str(lobbies.size()))
	
	print("\n~LOBBY LIST~")
	for code in lobbies.keys():
		print("    " + str(code))
	
	if (lobbies.keys().size() == 0):
		print("    There are no lobbies currently in use.")
		
	print("\n ========= LOBBYHANDLER DEBUG ========= \n")
