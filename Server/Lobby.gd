extends Node

var lobby_code
var parties = []

var max_lobby_players = 20

var minigame_list = [preload("res://BattleRoyale.tscn")]
var minigame_order = []

var minigames_per_match = 1 # This number CANNOT be greater than minigame_list size!!

var current_minigame = 0

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
	parties.append(party)
	
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
	current_minigame = current_minigame + 1
	if (current_minigame >= minigame_order.size()):
		print("FATAL ERROR @@ FUNC GET_NEXT_MINIGAME(): trying to get next" + 
			  "minigame despite having finished all minigames")
		return null


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
	for party in parties:
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
	for party in parties:
		if (party == partyToRemove):
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
	
func get_avail_size():
	var occupied = 0
	
	for party in parties:
		occupied += party.size()
	
	return max_lobby_players - occupied
