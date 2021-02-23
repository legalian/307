extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var generalserver = null
var specificserver = null

# Called when the node enters the scene tree for the first time.
func _ready():
	generalserver = get_node("/root/Server")
	specificserver = generalserver.get_children()[0]


func _on_Button_pressed():
	generalserver.attemptEnterGame()




