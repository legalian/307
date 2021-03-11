extends Node

var playerID
var score = 0
var username
var avatar = "Raccoon"
var hat = "None"

func _init(var packed):
	playerID = packed['id']
	username = packed.get('username',"User "+str(packed['id']))
	avatar = packed.get('avatar',"Raccoon")
	score = packed.get('score',0)
	hat = packed.get('hat',"None")
	#defaults here must match defaults in server PartyPlayer.gd.
	
func unpack(packed):
	playerID = packed['id']
	username = packed['username']
	avatar = packed['avatar']
	score = packed['score']
	hat = packed['hat']
	
