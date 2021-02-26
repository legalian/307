extends Node

const Lobby=preload("res://Lobby.gd")
var lobbies = {}

var rng

var max_lobbies = 150

func _init(): # Called when LobbyHandler.new() is done
	rng = RandomNumberGenerator.new()
	rng.randomize()

func get_lobby(var lobby_id):
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
	
	return null

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
			return lobby_code
	
	# Lobbies that are already created are all full; create a new one
	var fresh_lobby_code = create_lobby()
	
	if (fresh_lobby_code != null): # New lobby was created successfully
		lobbies.get(fresh_lobby_code).add_party(party)
		return fresh_lobby_code
	
	# New lobby was not created successfully
	return null
	
func key_taken(var key):
	return lobbies.has(key)
	
