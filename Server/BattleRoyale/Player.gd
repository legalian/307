extends Node

var playerID

func _init(var thisplayerID):
	playerID = thisplayerID

func pack():
	return {
		'id':playerID
	}


