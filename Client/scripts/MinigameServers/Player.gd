extends Node

var randomNameList = ["Axe","Bean","Bear","Bee","Bird","Cactus","Burger","Claw","Coyote","Crumb","Dragon","Diamond","Ghost","Fox","Gamer","Joker","Noodle","Wolf","Keibo","Tomato","Storm","Socks","Lizard","Undefined","Lost","OnePiece","Cris","UwU","BigBoi","NoName"]

var playerID
var score = 0
var username = "" 
var avatar = 0
var hat = 0
var vehicle = 0

func _init(var packed):
	playerID = packed['id']
	#username = packed.get('username',"User "+str(packed['id']))
	username = packed.get('username',randomUsername())

	avatar = packed.get('avatar',0)
	score = packed.get('score',0)
	hat = packed.get('hat',0)
	vehicle = packed.get('vehicle',0)
	#defaults here must match defaults in server PartyPlayer.gd.
	
func unpack(packed):
	playerID = packed['id']
	username = packed['username']
	avatar = packed['avatar']
	score = packed['score']
	hat = packed['hat']
	vehicle = packed['vehicle']
	
func pack():
	return {
		'avatar':avatar,
		'hat':hat,
		'username':username,
		'vehicle':vehicle
	}


func randomUsername():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var my_random_number = rng.randi_range(0, randomNameList.size()-1)
	return randomNameList[my_random_number]
