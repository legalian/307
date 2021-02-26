extends Node
const Party = preload("res://Party.gd")
const PartyPlayer = preload("res://PartyPlayer.gd")
const invalid_party_id = str(100000)
var codes_in_use = [invalid_party_id]
var parties = {str(invalid_party_id) : Party.new("defaultPartyOwner")}
var player_objects = {}

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
	
func _init():
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func get_players_in_party(var party):
	var outp = []
	for pid in party.playerIDs:
		outp.append(player_objects.get(pid))
	return outp

func get_party_by_player(var memberID):
	if player_objects.has(memberID):
		return player_objects[memberID].party

func new_party(var ownerID):
	if (!player_objects.has(ownerID)):
		var party = Party.new(ownerID)
		party.code = generate_code()
		parties[str(party.code)] = party
		player_objects[ownerID] = PartyPlayer.new(ownerID, party)
		return party
	else:
		print("Party not created - this player is already in a party: " + str(player_objects.get(ownerID).party.code))
		return player_objects.get(ownerID).party

func join_party_by_id(var playerID, var partyID):
	print("Player " + str(playerID) + " is attempting to join party " + str(partyID))
	if (parties.has(str(partyID))):
		parties.get(str(partyID)).playerIDs.append(playerID)
		player_objects[playerID] = PartyPlayer.new(playerID, parties[partyID])
		return parties.get(str(partyID))
	else:
		print("Party not found: " + str(partyID) + " in: " + str(parties))
		return parties.get(str(invalid_party_id))

func leave_party(var playerID):
	if (player_objects.has(playerID)):
		print("Player " + str(playerID) + " is leaving party " + str(player_objects.get(playerID).party.code))
		player_objects.get(playerID).on_disconnect()
		player_objects.erase(playerID)
	pass

func generate_code():
	randomize()
	var code = invalid_party_id
	while (codes_in_use.find(code) != -1):
		code = int(rand_range(100000, 999999))
	codes_in_use.append(code)
	print("Code created. New code list: " + str(codes_in_use))
	return code

func party_count():
	return codes_in_use.size() - 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
