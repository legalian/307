extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print("I have been added to a battle royale lobby")

func shoot():
	print("I am shooting")
	rpc_id(1,"shoot")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
