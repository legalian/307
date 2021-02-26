extends Node

var lobby_code
var players = []

var max_lobby_players = 20

var minigame_list = [preload("res://BattleRoyale.tscn")]
var minigame_order = []

var minigames_per_match = 1 # This number CANNOT be greater than minigame_list size!!

var current_minigame = -1

var rng

func _init(var code):
	lobby_code = code
	
	rng = RandomNumberGenerator.new()
	rng.randomize()
	
	if (minigames_per_match > minigame_list.size()):
		print("ERROR! REQUESTING TO SCRAMBLE MORE MINIGAMES THAN AVAILABLE")
		print("ERROR! REQUESTING TO SCRAMBLE MORE MINIGAMES THAN AVAILABLE")
		print("ERROR! REQUESTING TO SCRAMBLE MORE MINIGAMES THAN AVAILABLE")
		print("ERROR! REQUESTING TO SCRAMBLE MORE MINIGAMES THAN AVAILABLE")
		print("ERROR! REQUESTING TO SCRAMBLE MORE MINIGAMES THAN AVAILABLE")
		return
	
	scramble_minigames()

func set_lobby_code(var code):
	lobby_code = code

func get_lobby_code():
	return lobby_code

func add_party(var party):
	players.append(party)
	
################################################################################
# @desc
# Adds minigames in a random order from minigame_list.
################################################################################
func scramble_minigames():
	while (minigame_order.size() != minigames_per_match):
		var rand = rng.randi_range(0, minigames_per_match - 1) # Number generation is inclusive
		if (!minigame_order.has(minigame_list.get(rand))):
			minigame_order.append(minigame_list.get(rand)) # Keep appending until size is correct

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
# Gets the next minigame to be played.
#
# @returns
# minigame_order[current_minigame]
#
# NOTE: This function will return the first minigame to be played when called
#		before joining the lobby. The internal order starts at -1.
# NOTE: This function will return null if you attempt to get the next minigame
#		after all minigames are satisfied in the order.
################################################################################
func get_next_minigame():
	current_minigame = current_minigame + 1
	if (current_minigame >= minigame_order.size()):
		print("FATAL ERROR @@ FUNC GET_NEXT_MINIGAME(): trying to get next" + 
			  "minigame despite having finished all minigames")
		return null
	
	return minigame_order[current_minigame]

################################################################################
# @desc
# This function removes a player given to it. If the player is not in the lobby,
# this function will return false.
#
# @param
# playerToRemove:	A PartyPlayer object that will be compared with the internal
#					array of parties, and then compared with the array of
#					players per party, and removed if matched.
#
# @return
# Returns false if the player is not in the lobby; true if successfully removed.
################################################################################
func remove_player(var playerToRemove):
	for party in players:
		for player in party:
			#if (player.equals(playerToRemove)):  TODO
				print("WARN @@ REMOVE_PLAYER(): Function waiting on player.equals()")
				party.erase(player)
				return true
	
	return false

################################################################################
# @desc
# This function removes a party given to it. If the party is not in the lobby,
# this function will return false.
#
# @param
# playerToRemove:	An array of PartyPlayer objects that will be compared with
#					the internal array of parties, and removed if matched.
#
# @return
# Returns false if the party is not in the lobby; true if successfully removed.
################################################################################
func remove_party(var partyToRemove):
	for party in players:
		if (party == partyToRemove):
			players.erase(party)
			return true
	
	return false

func get_players():
	return players
	
func get_avail_size():
	return max_lobby_players - players.size()
