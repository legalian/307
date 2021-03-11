extends Node2D

onready var generalserver = get_node("/root/Server")
var Playerlist = generalserver.players
var SelfPlayer = generalserver.selfplayer
var TopPlayers = Playerlist

var AvatarStyles = ["Racoon"]
var HatStyles = ["None","Tophat","Smallhat","Viking","Paperhat","Headphones"]
var HatLocation = [null, 
"res://Hats/Tophat.tscn",
"res://Hats/Whitehat.tscn",
"res://Hats/Viking.tscn",
"res://Hats/Paperhat.tscn",
"res://Hats/Headphones.tscn"]

# Called when the node enters the scene tree for the first time.
func _ready():
	_SortPlayers()
	_SetScene()


func _SetScene():
	print("Set Scene")
	var currentPlacement = null
	for i in range(1,4):
		currentPlacement = find_node("Place" + str(i))
		currentPlacement.get_node("PlayerName").bbcode_text = "[center]" + TopPlayers[i-1].username + "[/center]"
		currentPlacement.get_node("Avatar").set_Hat(HatLocation[TopPlayers[i-1].hat])
	if (SelfPlayer != Playerlist[0] and  SelfPlayer != Playerlist[1] and SelfPlayer != Playerlist[2])
		find_node("CongratsText").hide()
	else
		find_node("CongratsText").show()
	

func _SortPlayers():
	print("Sort Players")
	


func _on_MainMenu_Button_pressed():
	pass # Replace with function body.



func _on_Matchmake_Button_pressed():
	pass # Replace with function body.
