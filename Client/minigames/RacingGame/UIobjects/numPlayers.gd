extends Label

var numPlayers = 20

func _ready():
	self.text = "/ " + str(Server.players.size())
