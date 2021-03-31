extends Node2D

var UsernameInput = ""
var AvatarSelected = 0
var HatSelected = 0
var VehicleSelected = 0

onready var generalserver = get_node("/root/Server")
var AvatarMenuOpen = false
var HatMenuOpen = false
var VehicleMenuOpen = false

var AvatarStyles = ["Raccoon","Shadow Raccoon","Red Raccoon"]
var HatStyles = ["None","Tophat","Smallhat","Viking","Paperhat","Headphones"]
var VehicleStyles = ["Sedan","Van","Truck","Race","Taxi","Future"]
#var VehicleRoots = ["res://exported/cars/sedan/diffuse.png","res://exported/cars/van/diffuse.png","res://exported/cars/truck/diffuse.png","res://exported/cars/race/diffuse.png","res://exported/cars/taxi/diffuse.png","res://exported/cars/raceFuture/diffuse.png"] # Sprite Roots


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
	UsernameInput = generalserver.selfplayer.username
	AvatarSelected = generalserver.selfplayer.avatar
	HatSelected = generalserver.selfplayer.hat
	VehicleSelected = generalserver.selfplayer.vehicle
	get_node("CurrentAvatar").text = "Avatar - " + AvatarStyles[AvatarSelected]
	get_node("CurrentHat").text = "Hat - " + HatStyles[HatSelected]
	get_node("CurrentName").text = UsernameInput
	$Avatar.set_Hat(HatSelected)
	var hotsw = $Avatar.hotswap(AvatarSelected)
	hotsw.z_index = -1;
	add_child(hotsw,true)
	_on_ChangeVehicle_pressed(VehicleSelected)
	

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
		generalserver.selfplayer.username  = UsernameInput
	else:
		find_node("UsernameInput").text = "Username is Invalid"
		print("Username is Invalid")


func _on_ChangeAvatar_pressed(AvatarType):
	#print(AvatarType)
	AvatarSelected = AvatarType
	get_node("CurrentAvatar").text = "Avatar - " + AvatarStyles[AvatarSelected]
	generalserver.selfplayer.avatar = AvatarSelected
	var av = $Avatar.hotswap(AvatarType)
	av.z_index = -1
	add_child(av,true)

func _on_ChangeHat_pressed(HatType):
	#print(HatType)
	HatSelected = HatType
	get_node("CurrentHat").text = "Hat - " + HatStyles[HatSelected]
	$Avatar.set_Hat(HatType)
	generalserver.selfplayer.hat = HatSelected

func _on_ChangeVehicle_pressed(VehicleType):
	#print(AvatarType)
	VehicleSelected = VehicleType
	get_node("CurrentVehicles").text = "Vehicle - " + VehicleStyles[VehicleSelected]
	generalserver.selfplayer.vehicle = VehicleSelected #Set Vechicle
	var CurrentVehicle = find_node("VehicleSprites")
	CurrentVehicle.animation = VehicleStyles[VehicleSelected]
	

func _on_Button_ChooseVehicle_pressed():
	if (VehicleMenuOpen):
		#get_node("Button_ChooseCharacter").text = "Change"
		get_node("Vehicle Menu").hide()
		find_node("SelectedVehicle").show()
		VehicleMenuOpen = false
	else:
		#get_node("Button_ChooseCharacter").text = "Close"
		get_node("Vehicle Menu").show()
		find_node("SelectedVehicle").hide()
		_set_Vehicle_Selection()
		VehicleMenuOpen = true

func _set_Vehicle_Selection():
	var VehicleSelection = get_node("Vehicle Menu").get_node("ColorRect").get_node("ButtonSelection")
	var currentNode = VehicleSelection
	for i in 8:
		currentNode = VehicleSelection.get_node("Avatar" + str(i))
		var VehicleDisplay = currentNode.get_node("VehicleDisplay")
		if(i < VehicleStyles.size()):
			currentNode.get_node("AvatarType").text = VehicleStyles[i]
			VehicleDisplay.animation = VehicleStyles[i]
			currentNode.show()
		else:
			currentNode.get_node("AvatarType").text = "Null"
			currentNode.hide()

func _on_Button_ChooseHat_pressed():
	if (HatMenuOpen):
		#get_node("Button_ChooseCharacter").text = "Change"
		get_node("Hat Menu").hide()
		find_node("SelectedVehicle").show()
		HatMenuOpen = false
	else:
		#get_node("Button_ChooseCharacter").text = "Close"
		get_node("Hat Menu").show()
		find_node("SelectedVehicle").hide()
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
		find_node("SelectedVehicle").show()
		AvatarMenuOpen = false
	else:
		#get_node("Button_ChooseCharacter").text = "Close"
		get_node("Avatar Menu").show()
		find_node("SelectedVehicle").hide()
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
