extends Node
const Party = preload("res://Party.gd")

var playerID
var party

func _init(var thisPlayerID, var thisParty):
	playerID = thisPlayerID
	party = thisParty

func on_disconnect():
	party.playerIDs.remove(party.playerIDs.find(playerID))
	print("Player " + str(playerID) + " removed from party " + str(party.code))
	print("Players: " + str(party.playerIDs))
	
