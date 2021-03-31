extends Node

var lobby_code
var parties = []


var minigame_list = [preload("res://BattleRoyale/World.tscn"),
					 preload("res://RacingGame/World.tscn"),
					 preload("res://DemoDerby/World.tscn")]

var podium = preload("res://Podium/World.tscn")

var minigame_order = []
const MAPS = ["Grass", "Desert"]
var nextMap

var minigames_per_match = 3 # This number CANNOT be greater than minigame_list size!!
var current_minigame = 0

var can_start = false
var in_game = false
var rng

var max_players_per_lobby = 20
var min_players_per_lobby = 2
# Change this to 1 for debugging

func _init(var code):
	lobby_code = code
	
	rng = RandomNumberGenerator.new()
	rng.randomize()
	
	if (minigames_per_match > minigame_list.size()):
		print("minigames_per_match > minigame_list.size() in Lobby._init()")
		return
	
	scramble_minigames()
	# Add one to let get_next_minigame work

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
	
	if (get_occupied() >= min_players_per_lobby):
		can_start = true
		return true
	
	return false

func scramble_minigames():
	while (minigame_order.size() != minigames_per_match * 3):
		var rand = rng.randi_range(0, minigames_per_match - 1) # Number generation is inclusive		
		if (minigame_order.find(minigame_list[rand]) == -1):
			minigame_order.append()
			minigame_order.append(minigame_list[rand]) # Keep appending until size is correct
	
	minigame_order.append(podium)
	minigames_per_match += 1

func get_minigame_order():
	return minigame_order

func get_current_minigame():
	return minigame_order[current_minigame]

func go_to_next_minigame():
	current_minigame = current_minigame + 1
	if (current_minigame >= minigame_order.size()):
		print("FATAL ERROR @@ FUNC GET_NEXT_MINIGAME()")
		return false
	
	return true

func remove_party(var in_party):
	
	for party in parties:
		if (party.code == in_party.code):
			print("Removing Party " + str(party.code) + " from lobby " + str(lobby_code))
			parties.erase(party)
			return true
	
	return false

func get_parties():
	return parties
	
func get_player_ids():
	var players = []
	for party in parties:
		for player_id in party.playerIDs:
			players.append(player_id)
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
	print("CAN_START: " + str(can_start))
	print("IN GAME?: " + str(in_game))
	
	print("\n~PARTY LIST~")
	var partycount = 0
	for party in parties:
		partycount += 1
		print("PARTY " + str(party.code) + ":")
		for playerID in party.playerIDs:
			print("\tPlayerID: " + str(playerID))
	
	print("\n ========= LOBBY DEBUG =========\n")
	
func set_map(map):
	nextMap = map
