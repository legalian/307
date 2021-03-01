extends Node2D

var UsernameInput = null
var AvatarSelected = 0

var generalserver = null
var specificserver = null
var AvatarMenuOpen = false

# Called when the node enters the scene tree for the first time.
#func _ready():
	#generalserver = get_node("/root/Server")
	#specificserver = generalserver.get_children()[0]
	#print(get_node("MainPartyCreationScreenLabel").get_path())
	

func _on_UsernameInput_text_changed(new_username):
	UsernameInput = new_username
	#print(new_username)


func _on_Button_Back_pressed():
	#generalserver.attemptEnterGame()
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
