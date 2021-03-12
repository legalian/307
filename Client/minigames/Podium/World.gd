extends Node2D

var generalserver
var Playerlist
var SelfPlayer
var TopPlayers

var AvatarStyles = ["Racoon"]
var HatStyles = ["None","Tophat","Smallhat","Viking","Paperhat","Headphones"]

# Called when the node enters the scene tree for the first time.
func _ready():
	generalserver = get_node("/root/Server")
	SelfPlayer = generalserver.selfplayer
	Playerlist = generalserver.players+[]
	_SortPlayers()
	_SetScene()


func _SetScene():
	print("Set Scene")
	var currentPlacement = null
	for i in range(1,4):
		currentPlacement = find_node("Place" + str(i))
		if TopPlayers.size()<i:
			currentPlacement.visible = false
			continue
		currentPlacement.get_node("PlayerName").bbcode_text = "[center]" + TopPlayers[i-1].username + "[/center]"
		currentPlacement.get_node("Avatar").set_Hat(TopPlayers[i-1].hat)
	if (SelfPlayer != Playerlist[0] and  SelfPlayer != Playerlist[1] and SelfPlayer != Playerlist[2]):
		find_node("CongratsText").hide()
	else:
		find_node("CongratsText").show()
	

func _SortPlayers():
	Playerlist.sort_custom(self, "sort_by_score");
	TopPlayers = Playerlist
	
func sort_by_score(var playerA, var playerB):
	return (playerA.score <= playerB.score)


func _on_MainMenu_Button_pressed():
	get_tree().quit()



func _on_Matchmake_Button_pressed():
	pass # Replace with function body.
