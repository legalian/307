extends Node
const Party = preload("res://Party.gd")

var playerID
var party
var score = 0
var username
var avatar = 0
var hat = 0
var vehicle = 0
var dummy = 0;

func _init(var thisPlayerID, var thisParty):
	playerID = thisPlayerID
	party = thisParty
	username = "User "+str(thisPlayerID)

func on_disconnect():
	party.playerIDs.remove(party.playerIDs.find(playerID))
	print("Player " + str(playerID) + " removed from party " + str(party.code))
	print("Players: " + str(party.playerIDs))
	if (party.ownerID == playerID):
		# If the leaving player is the party owner, make a different player the owner
		if (!party.playerIDs.empty()):
			party.ownerID = party.playerIDs.front()
			print("Owner left. New owner is: " + str(party.ownerID))
		else:
			print("Party is now empty.")
	
func pack():
		return {
			'id':playerID,
			'score':score,
			'username':username,
			'avatar':avatar,
			'hat':hat,
			'vehicle':vehicle
		}

func unpack(packed):
	vehicle = packed['vehicle']
	username = packed['username']
	avatar = packed['avatar']
	hat = packed['hat']

func equals(var comparePlayer):
	return playerID == comparePlayer.playerID
