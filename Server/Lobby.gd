extends Node

var lobby_code
var players = []

var max_lobby_players = 20

func _init(var code):
	lobby_code = code

func set_lobby_code(var code):
	lobby_code = code

func get_lobby_code():
	return lobby_code

func add_party(var party):
	players.append(party)
	
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
