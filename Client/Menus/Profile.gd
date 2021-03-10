extends Node2D

var UsernameInput = ""
var AvatarSelected = 0
var HatSelected = 0

onready var generalserver = get_node("/root/Server")
var AvatarMenuOpen = false
var HatMenuOpen = false

var AvatarStyles = ["Racoon"]
var HatStyles = ["None","Tophat","Smallhat","Viking","Paperhat","Headphones"]
var HatLocation = [null, 
"res://Hats/Tophat.tscn",
"res://Hats/Whitehat.tscn",
"res://Hats/Viking.tscn",
"res://Hats/Paperhat.tscn",
"res://Hats/Headphones.tscn"]

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


func _on_Button_Back_pressed():
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
	get_node("CurrentAvatar").text = "Avatar - " + AvatarStyles[AvatarSelected]

func _on_ChangeHat_pressed(HatType):
	print(HatType)
	HatSelected = HatType
	get_node("CurrentHat").text = "Hat - " + HatStyles[HatSelected]
	find_node("Avatar").set_Hat(HatLocation[HatType])


func _on_Button_ChooseHat_pressed():
	if (HatMenuOpen):
		#get_node("Button_ChooseCharacter").text = "Change"
		get_node("Hat Menu").hide()
		HatMenuOpen = false
	else:
		#get_node("Button_ChooseCharacter").text = "Close"
		get_node("Hat Menu").show()
		_set_Hat_Selection()
		HatMenuOpen = true

func _set_Hat_Selection():
	var HatSelection = get_node("Hat Menu").get_node("ColorRect").get_node("ButtonSelection")
	var currentNode = HatSelection
	for i in 8:
		currentNode = HatSelection.get_node("Avatar" + str(i))
		if(i < HatStyles.size()):
			currentNode.get_node("AvatarType").text = HatStyles[i]
			currentNode.show()
		else:
			currentNode.get_node("AvatarType").text = "Null"
			currentNode.hide()
			

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