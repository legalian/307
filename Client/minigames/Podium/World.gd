extends Node

var Playerlist
var SelfPlayer
var TopPlayers

var AvatarStyles = ["Racoon"]
var HatStyles = ["None","Tophat","Smallhat","Viking","Paperhat","Headphones"]

# Called when the node enters the scene tree for the first time.
func _ready():
	SelfPlayer = Server.selfplayer
	Playerlist = Server.players+[]
	_SortPlayers()
	_SetScene()
	
	get_node("AnimationPlayer").play("CurtainCall")
	AudioPlayer.pause_music()
	AudioPlayer.play_music("res://audio/music/podium.ogg")


func _SetScene():
	print("Set Scene")
	var currentPlacement = null
	for i in range(1,4):
		currentPlacement = find_node("Place" + str(i))
		if TopPlayers.size()<i:
			currentPlacement.visible = false
			continue
		currentPlacement.get_node("PlayerName").bbcode_text = "[center]" + TopPlayers[i-1].username + "[/center]"
		currentPlacement.add_child(currentPlacement.get_node("Avatar").hotswap(TopPlayers[i-1].avatar),true)
		currentPlacement.get_node("Avatar").set_Hat(TopPlayers[i-1].hat)
	if (SelfPlayer != Playerlist[0] and  SelfPlayer != Playerlist[1] and SelfPlayer != Playerlist[2]):
		find_node("CongratsText").hide()
	else:
		find_node("CongratsText").show()
	

func _SortPlayers():
	Playerlist.sort_custom(self, "sort_by_score");
	TopPlayers = Playerlist
	
func sort_by_score(var playerA, var playerB):
	return (playerA.score >= playerB.score)


func _on_MainMenu_Button_pressed():
	AudioPlayer.play_sfx("res://audio/sfx/click_002.ogg")
	Server.leave_party()
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	AudioPlayer.play_music("res://audio/music/mainmenu" + str(rng.randi_range(1,2)) + ".ogg")
	get_tree().change_scene("res://Main.tscn")
