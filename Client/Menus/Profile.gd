extends Node2D

var UsernameInput = ""
var AvatarSelected = 0

onready var generalserver = get_node("/root/Server")
var AvatarMenuOpen = false

var AvatarStyles = ["Racoon"]

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

func _on_Button_ChooseHat_pressed():
	pass

func _on_Button_ChooseCharacter_pressed():
	if (AvatarMenuOpen):
		#get_node("Button_ChooseCharacter").text = "Change"
		get_node("Avatar Menu").hide()
		AvatarMenuOpen = false
	else:
		#get_node("Button_ChooseCharacter").text = "Close"
		get_node("Avatar Menu").show()
		_set_Avatar_Selection()
		AvatarMenuOpen = true

func _set_Avatar_Selection():
	var AvatarSelection = get_node("Avatar Menu").get_node("ColorRect").get_node("ButtonSelection")
	var currentNode = AvatarSelection
	for i in 8:
		currentNode = AvatarSelection.get_node("Avatar" + str(i))
		if(i < AvatarStyles.size()):
			currentNode.get_node("AvatarType").text = AvatarStyles[i]
			currentNode.show()
		else:
			currentNode.get_node("AvatarType").text = "Null"
			currentNode.hide()
			
		

func _on_EnterGameButton_pressed():
	get_tree().change_scene("res://minigames/PartyScreen/LoadingScreen.tscn")
	generalserver.attemptEnterGame()
