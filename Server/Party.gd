extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var code = "defaultCode"
var playerIDs = []
var ownerID = ""
var lobby

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
	# Generate a code for the lobby
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
