extends Node2D

var Serverlist = []
var Playerlist = []
var PlayerData = ["Name", 0, 1]

# Called when the node enters the scene tree for the first time.
func _ready():
	_SetScene()


func _SetScene():
	print("Set Scene")
	var currentPlacement = null
	for i in range(1,4):
		currentPlacement = find_node("Place" + str(i))
		currentPlacement.get_node("PlayerName").bbcode_text = "[center]" + PlayerData[0] + "[/center]"
		
