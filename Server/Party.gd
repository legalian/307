extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var code = "defaultCode"
var playerIDs = []
var ownerID = ""
var minigame
var lobby_code = "defaultCode"

func _init(var partyOwnerID):
	print("Party created with owner: " + str(partyOwnerID))
	playerIDs.append(partyOwnerID)
	ownerID = partyOwnerID
	
func remove_player(var playerID):
	if (playerIDs.find(playerID) == -1):
		print("Error: Attempted to remove player that is not in the party. No action taken.")
		pass
	playerIDs.remove(playerIDs.find(playerID))
	print("Removed player: " + str(playerID))
# Called when the node enters the scene tree for the first time.
func _ready():
	# Generate a code for the minigame
	pass # Replace with function body.

func size():
	return playerIDs.size()
	
func debug_print():
	print("Party Code: " + str(code))
	print("# Players: " + str(playerIDs.size()))
	print("Owner: " + str(ownerID))
	print("Lobby code: " + str(lobby_code) + "\n")
	
	print("~PLAYER LIST~")
	for playerID in playerIDs:
		print("Player ID: " + str(playerID))
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
