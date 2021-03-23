extends Node2D

var SelfUsername
var AvatarSelected = 0

onready var generalserver = get_node("/root/Server")
var specificserver = null
var AvatarMenuOpen = false

var scoreboard = preload("res://minigames/ScoreBoard/ScoreBoard.tscn")

func _MUT_send_partycode():
	var partycode = $PartyCode.text
	var file = File.new()
	file.open("user://saved_partycode.dat", file.WRITE)
	file.store_string(partycode)
	file.close()

func _MUT_set_username():
	$UsernameInput.text = ["Corge","Grault","Garply","Waldo"][int(OS.get_environment("ACTIVECORNER"))-1]

func _ready():
	generalserver = get_node("/root/Server")
	specificserver = generalserver.get_children()[0]
	SelfUsername = generalserver.selfplayer.username
	find_node("UsernameLabel").text = SelfUsername
	$PartyCode.text = str(generalserver.partycode)
	#if OS.get_environment("MULTI_USER_TESTING")=="party":
		#if OS.get_environment("ACTIVECORNER")=="1":
		#	$MUT_test_flow.play("Multi_User_Testing_Partylead")
		#else:
		#	$MUT_test_flow.play("Multi_User_Testing_Partyfollow")
	$Raccoon.set_Hat(generalserver.selfplayer.hat)



func _on_Button_Back_pressed():
	#generalserver.attemptEnterGame()
	print("need to implement leave party functionality")
	get_tree().change_scene("Main.tscn")


func _on_EnterGameButton_pressed():
	get_tree().change_scene("res://minigames/PartyScreen/LoadingScreen.tscn")
	generalserver.attemptEnterGame()
	
	
func _on_Button_CopyCode_pressed():
	OS.set_clipboard($PartyCode.text)
