extends Node2D

var UsernameInput = ""
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
	$PartyCode.text = str(generalserver.partycode)
	if OS.get_environment("MULTI_USER_TESTING")=="TRUE":
		if OS.get_environment("ACTIVECORNER")=="1":
			$MUT_test_flow.play("Multi_User_Testing_Partylead")
		else:
			$MUT_test_flow.play("Multi_User_Testing_Partyfollow")
	

func _on_UsernameInput_text_changed(new_username):
	UsernameInput = new_username
	#print(new_username)


func _on_Button_Back_pressed():
	#generalserver.attemptEnterGame()
	print("need to implement leave party functionality")
	get_tree().change_scene("Main.tscn")


func _on_Button_ConfirmUsername_pressed():
	#print(UsernameInput)
	#regex.compile("^[A-Za-z]+$")
	#var result = regex.search(UsernameInput)
	#var validCharacters = (result.get_string() == UsernameInput)
	
	if (UsernameInput.length() >= 3 and UsernameInput.length() <= 20): #and validCharacters):
		get_node("CurrentName").text = UsernameInput
	else:
		print("Username is Invalid")


func _on_ChangeAvatar_pressed(AvatarType):
	print(AvatarType)
	AvatarSelected = AvatarType
	get_node("CurrentAvatar").text = "Avatar - " + str(AvatarSelected)


func _on_Button_ChooseCharacter_pressed():
	if (AvatarMenuOpen):
		get_node("Button_ChooseCharacter").text = "Change"
		get_node("Avatar Menu").hide()
		AvatarMenuOpen = false
	else:
		get_node("Button_ChooseCharacter").text = "Close"
		get_node("Avatar Menu").show()
		AvatarMenuOpen = true


func _on_EnterGameButton_pressed():
	get_tree().change_scene("res://minigames/PartyScreen/LoadingScreen.tscn")
	generalserver.attemptEnterGame()
	
	
	
	
	

	
	
	
	
