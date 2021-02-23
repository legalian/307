extends Node
const Party = preload("res://Party.gd")


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var playerID
var party

func _init(var thisPlayerID, var thisParty):
	playerID = thisPlayerID
	party = thisParty

func on_disconnect():
	party.playerIDs.remove(party.playerIDs.find(playerID))
	print("Player " + str(playerID) + " removed from party " + str(party.code))
	print("Players: " + str(party.playerIDs))
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
