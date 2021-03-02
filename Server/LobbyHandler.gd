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
	return lobbies[lobby_id]

func delete_lobby(var lobby_id):
	lobbies[lobby_id] = null

################################################################################
# @desc
# Creates a new Lobby object, creates a unique code, and inserts it to the dict.
#
# @returns
# Returns the lobby code of the newly created lobby, null if there's too many
# lobbies.
################################################################################
func create_lobby():
	
	var tempLobby = Lobby.new(rng.randi_range(100000, 999999))
	while (key_taken(tempLobby.get_lobby_code())): # If taken,
		rng.randomize() # Randomize the generator
		tempLobby.set_lobby_code(rng.randi_range(100000, 999999)) # Generate another code
	

	if (lobbies.size() < max_lobbies):
		lobbies[tempLobby.get_lobby_code()] = tempLobby
		return tempLobby.get_lobby_code()
	
	debug_print()
	return null

################################################################################
# @desc
# Removes players/parties from the given lobby_id.
#
# @params
# party:	THIS MUST BE AN ARRAY OF PLAYER OBJECTS, NOT PEER IDs. To remove one
#			player, pass in an array of size 1. For a party, pass in an array of
#			player objects.
# lobby_id:	Lobby code that you want the player to be removed from. ALthough this
#			isn't technically needed, it speeds up performance.
#
# @returns
# Returns false if there were any errors, true on success.
################################################################################
func remove_from_lobby(var party):
	if (party == null):
		print("Attempted to remove a null party from the lobby.")
		debug_print()
		return false
	
	if (str(party.lobby_code) == "defaultCode"):
		print("Attempting to remove from 'PartyScreen' minigame; returning false")
		debug_print()
		return false
	
	var lobby = get_lobby(party.lobby_code)
	if (lobby == null):
		print("Attempted to get lobby from invalid lobby code @@ remove_from_lobby()")
		debug_print()
		return false
	
	debug_print()
	return lobby.remove_party(party)

################################################################################
# @desc
# Adds a party to the nearest available lobby.
#
# @params
# party:	A PartyPlayer array (a solo player would just be an array of 1) that
#			is to be placed into a lobby
#
# @returns
# Returns the lobby code on successful addition; null otherwise.
################################################################################
func add_to_lobby(var party):
	for lobby_code in lobbies.keys():
		# Loop through the lobbies that are created
		if (lobbies.get(lobby_code).get_avail_size() >= party.size()):
			lobbies.get(lobby_code).add_party(party)
			debug_print()
			return lobby_code
	
	# Lobbies that are already created are all full; create a new one
	var fresh_lobby_code = create_lobby()
	
	if (fresh_lobby_code != null): # New lobby was created successfully
		lobbies.get(fresh_lobby_code).add_party(party)
		debug_print()
		return fresh_lobby_code
	
	# New lobby was not created successfully
	debug_print()
	return null

func key_taken(var key):
	return lobbies.has(key)
	

func debug_print():
	print("\n ========= LOBBYHANDLER DEBUG ========= ")
	print("LOBBIES CREATED: " + str(lobbies.size()))
	
	print("\n~LOBBY LIST~")
	for code in lobbies.keys():
		print("    " + str(code))
		
	print("\n ========= LOBBYHANDLER DEBUG ========= \n")
