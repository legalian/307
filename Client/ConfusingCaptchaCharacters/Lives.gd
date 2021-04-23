extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setLives(lives):
	if(lives == 3):
		get_node("Life1").setLife(1);
		get_node("Life2").setLife(1);
		get_node("Life3").setLife(1);
	elif(lives == 2):
		AudioPlayer.play_sfx("res://audio/sfx/wrong.ogg")
		get_node("Life1").setLife(0);
		get_node("Life2").setLife(1);
		get_node("Life3").setLife(1);
	else:
		AudioPlayer.play_sfx("res://audio/sfx/wrong.ogg")
		get_node("Life1").setLife(0);
		get_node("Life2").setLife(0);
		get_node("Life3").setLife(1);
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
