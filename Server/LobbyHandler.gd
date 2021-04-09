extends Node

# Constants
const Lobby=preload("res://Lobby.gd")
const max_lobbies = 150


# Internal Data Structures
var lobbies = {}


# Global variables
var rng

func _init():
	rng = RandomNumberGenerator.new()
	rng.randomize()

func get_lobby(var lobby_id):
	if (str(lobby_id) == "defaultCode"):
		print("get_lobby() is called on the party screen!")
		# We're on the party screen, return null
		return null
	
	if lobbies.has(lobby_id):
		return lobbies[lobby_id]
	
	return null

func create_lobby():	
	var tempLobby = Lobby.new(rng.randi_range(100000, 999999))
	
	while (lobbies.has(tempLobby.lobby_code)): # If taken,
		rng.randomize() # Randomize the generator
		
		# Generate another code
		tempLobby.lobby_code = rng.randi_range(100000, 999999)
	
	if (lobbies.size() < max_lobbies):
		lobbies[tempLobby.lobby_code] = tempLobby
		return tempLobby.lobby_code
	
	return null

func delete_lobby(lobbyID):
	lobbies.erase(lobbyID)

func remove_from_lobby(var party):
	if (party == null):
		print("Attempted to remove a null party from the lobby.")
		return false
	
	if (str(party.lobby_code) == "defaultCode"):
		print("Attempting to remove a party with \"defaultCode\"" + 
			   "returning false")
		return false
	
	var lobby = get_lobby(party.lobby_code)
	if (lobby == null):
		print("get_lobby() returned null in remove_from_lobby()")
		return false
	
	if (!lobby.remove_party(party)):
		print("Error! Party was not removed correctly from the party!")
		# lobby.remove_party(party) should return true on success!	
		return false
	
	if (lobby.get_occupied() == 0):
		print("Lobby has no players. Deleting")
		delete_lobby(party.lobby_code)
		return false
	
	if (lobby.get_occupied() < lobby.min_players_per_lobby):
		print("Lobby is detected to not have enough parties. Returning true")
		# Depending on the situation, we disconnect all players or leave it be
		# This is handled in main.gd
		return true
	
	print("Some error occurred!")
	return false

func add_to_lobby(var party):
	for lobby in lobbies.values():
		# Loop through the lobbies that are created
		if ((lobby.max_players_per_lobby - lobby.get_occupied()) >= party.size()
			&& !lobby.in_game):
			# Checks if adding the party would make the lobby size too big,
			# and checks if the lobby hasn't started yet.
			
			if (lobby.add_party(party)):
				return true
	
	# Lobbies that are already created are all full or started
	# Create a new one
	var fresh_lobby_code = create_lobby()
	
	if (fresh_lobby_code != null): # New lobby was created successfully
		if (lobbies.get(fresh_lobby_code).add_party(party)):
			return true
	
	# New lobby was not created successfully; too many lobbies
	return false

func debug_print():
	print("\n ========= LOBBYHANDLER DEBUG ========= ")
	print("LOBBIES CREATED: " + str(lobbies.size()))
	
	print("\n~LOBBY LIST~")
	for code in lobbies.keys():
		print("    " + str(code))
	
	if (lobbies.keys().size() == 0):
		print("    There are no lobbies currently in use.")
		
	print("\n ========= LOBBYHANDLER DEBUG ========= \n")
