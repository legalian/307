extends Node
const Party = preload("res://Party.gd")

var playerID
var party
var score = 0
var username
var avatar = "Raccoon"
var hat = "None"

func _init(var thisPlayerID, var thisParty):
	playerID = thisPlayerID
	party = thisParty
	username = "User "+str(thisPlayerID)

func on_disconnect():
	party.playerIDs.remove(party.playerIDs.find(playerID))
	print("Player " + str(playerID) + " removed from party " + str(party.code))
	print("Players: " + str(party.playerIDs))
	
func pack():
	return {
		'id':playerID,
		'score':score,
		'username':username,
		'avatar':avatar,
		'hat':hat
	}
