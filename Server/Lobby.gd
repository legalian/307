extends Node

var lobby_code
var parties = []

# You can change this preload to manually change games.
# If you change minigames_per_match to 2, then Lobby.gd will attempt to create
# a random order out of 2 minigames.

# If minigames_per_match is has a number > size of minigame_list, everything will break.
# There is a check to make sure this does not happen.
var minigame_list = [preload("res://BattleRoyale/World.tscn")]

var minigame_order = []

var minigames_per_match = 1 # This number CANNOT be greater than minigame_list size!!

var current_minigame = 0

var started

var rng

var max_players_per_lobby = 20
var min_players_per_lobby = 2

func _init(var code):
	lobby_code = code
	
	rng = RandomNumberGenerator.new()
	rng.randomize()
	
	if (minigames_per_match > minigame_list.size()):
		print("ERROR! REQUESTING TO SCRAMBLE MORE MINIGAMES THAN AVAILABLE")
		debug_print()
		return
	
	scramble_minigames()

func get_scoreboard():
	var scoreboard = []
	
	for party in parties:
		for player in party:
			scoreboard.append(player.score)
			
	return scoreboard

func set_lobby_code(var code):
	lobby_code = code

func get_lobby_code():
	return lobby_code

func add_party(var party):
	print("Adding party " + str(party.code) + " to lobby " + str(lobby_code))
	if (parties.has(party)):
		print("Lobby already has this party!")
		return false
	
	parties.append(party)
	
	party.lobby_code = lobby_code
	
	if (parties.size() >= min_players_per_lobby):
		return true
	
	return false
################################################################################
# @desc
# Adds minigames in a random order from minigame_list.
################################################################################
func scramble_minigames():
	print("Entered minigame scrambling")
	while (minigame_order.size() != minigames_per_match):
		var rand = rng.randi_range(0, minigames_per_match - 1) # Number generation is inclusive		
		if (minigame_order.find(minigame_list[rand]) == -1):
			minigame_order.append(minigame_list[rand]) # Keep appending until size is correct

################################################################################
# @desc
# Gets the entire order. Be careful! Use get_next_minigame() when actually
# playing the minigames, as it helps the server keep track of the current
# minigame each lobby is playing.
################################################################################
func get_minigame_order():
	return minigame_order

################################################################################
# @desc
# Gets the minigame to be played.
#
# @returns
# minigame_order[current_minigame]
################################################################################
func get_current_minigame():
	return minigame_order[current_minigame]

################################################################################
# @desc
# Increases the internal counter of the lobby to the next minigame.
#
# @returns
# minigame_order[current_minigame]
#
# NOTE: This function will return null if you attempt to go to the next minigame
#		after all minigames are satisfied in the order.
################################################################################
func go_to_next_minigame():
	print("Incrementing current_minigame!")
	current_minigame = current_minigame + 1
	if (current_minigame >= minigame_order.size()):
		print("FATAL ERROR @@ FUNC GET_NEXT_MINIGAME(): trying to get next" + 
			  "minigame despite having finished all minigames")
		return null


################################################################################
# @desc
# This function removes a party given to it. If the party is not found, then
# the function returns false.
#
# NOTE: Because these are party objects, removing a player should be done via
#		the party. Removing a player from a party object will update it here
#		as well.
#
# @param
# party_code:	The party code of the party you want to remove from the lobby.
#
# @return
# Returns false if the party is not in the lobby; true if removed.
################################################################################
func remove_party(var in_party):
	
	for party in parties:
		if (party.code == in_party.code):
			print("Removing Party " + str(party.code) + " from lobby " + str(lobby_code))
			parties.erase(party)
			return true
	
	return false

func get_parties():
	return parties
	
func get_players():
	var players = []
	for party in parties:
		players.append(party)
	
	return players

func get_occupied():
	var occupied = 0
	
	for party in parties:
		occupied += party.size()

	return occupied

func has_player(var playerID):
	for party in parties:
		if (party.playerIDs.has(playerID)):
			return true
	
	return false

func has_party(var party_in):
	return parties.has(party_in)

func debug_print():
	print("\n ========= LOBBY DEBUG =========")
	print("LOBBY: " + str(lobby_code))
	print("CURRENT MINIGAME: " + str(current_minigame))
	
	print("\n~PARTY LIST~")
	var partycount = 0
	for party in parties:
		partycount += 1
		print("PARTY " + str(party.code) + ":")
		for playerID in party.playerIDs:
			print("\tPlayerID: " + str(playerID))
	
	print("\n ========= LOBBY DEBUG =========\n")
