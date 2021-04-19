extends Node

var UsernameInput = ""
var AvatarSelected = 0
var HatSelected = 0
var VehicleSelected = 0

var AvatarMenuOpen = false
var HatMenuOpen = false
var VehicleMenuOpen = false

var AvatarStyles = ["Raccoon","Shadow Raccoon","Red Raccoon"]
var HatStyles = ["None","Tophat","Smallhat","Viking","Paperhat","Headphones"]
var VehicleStyles

#var VehicleRoots = ["res://exported/cars/sedan/diffuse.png","res://exported/cars/van/diffuse.png","res://exported/cars/truck/diffuse.png","res://exported/cars/race/diffuse.png","res://exported/cars/taxi/diffuse.png","res://exported/cars/raceFuture/diffuse.png"] # Sprite Roots


func _MUT_send_partycode():
	var partycode = find_node("PartyCode").text
	var file = File.new()
	file.open("user://saved_partycode.dat", file.WRITE)
	file.store_string(partycode)
	file.close()

func _MUT_set_username():
	find_node("UsernameInput").text = ["Corge","Grault","Garply","Waldo"][int(OS.get_environment("ACTIVECORNER"))-1]

func _ready():
	VehicleStyles = load("res://exported/cars/CarSpriteFrames.tres").get_animation_names()
	UsernameInput = Server.selfplayer.username
	AvatarSelected = Server.selfplayer.avatar
	HatSelected = Server.selfplayer.hat
	VehicleSelected = Server.selfplayer.vehicle
	#print(VehicleSelected)
	find_node("CurrentAvatar").text = "Avatar - " + AvatarStyles[AvatarSelected]
	find_node("CurrentHat").text = "Hat - " + HatStyles[HatSelected]
	find_node("CurrentName").text = UsernameInput
	find_node("Avatar").set_Hat(HatSelected)
	var hotsw = $Avatar.hotswap(AvatarSelected)
	#hotsw.z_index = 1;
	add_child(hotsw,true)
	_on_ChangeVehicle_pressed(VehicleSelected)
	_set_Vehicle_Selection()
	

func _on_UsernameInput_text_changed(new_username):
	UsernameInput = new_username


func _on_Button_Back_pressed():
	AudioPlayer.play_sfx("res://audio/sfx/click_002.ogg")
	Config.save_config()
	get_tree().change_scene("Main.tscn")


func _on_Button_ConfirmUsername_pressed():
	
	#print(UsernameInput)
	#regex.compile("^[A-Za-z]+$") 
	#var result = regex.search(UsernameInput)
	#var validCharacters = (result.get_string() == UsernameInput)
	
	if (UsernameInput.length() >= 3 and UsernameInput.length() <= 20): #and validCharacters):
		find_node("CurrentName").text = UsernameInput
		Server.selfplayer.username  = UsernameInput
		AudioPlayer.play_sfx("res://audio/sfx/click_002.ogg")
	else:
		find_node("UsernameInput").text = "Username is Invalid"
		AudioPlayer.play_sfx("res://audio/sfx/hurt.ogg")
		#print("Username is Invalid")


func _on_ChangeAvatar_pressed(AvatarType):
	AudioPlayer.play_sfx("res://audio/sfx/click_002.ogg")
	#print(AvatarType)
	AvatarSelected = AvatarType
	find_node("CurrentAvatar").text = "Avatar - " + AvatarStyles[AvatarSelected]
	Server.selfplayer.avatar = AvatarSelected
	var av = $Avatar.hotswap(AvatarType)
	av.z_index = -1
	add_child(av,true)

func _on_ChangeHat_pressed(HatType):
	AudioPlayer.play_sfx("res://audio/sfx/click_002.ogg")
	#print(HatType)
	HatSelected = HatType
	find_node("CurrentHat").text = "Hat - " + HatStyles[HatSelected]
	$Avatar.set_Hat(HatType)
	Server.selfplayer.hat = HatSelected

func _on_ChangeVehicle_pressed(VehicleType):
	AudioPlayer.play_sfx("res://audio/sfx/click_002.ogg")
	#print(AvatarType)
	VehicleSelected = VehicleType
	find_node("CurrentVehicles").text = "Vehicle - " + VehicleSelected
	Server.selfplayer.vehicle = VehicleSelected #Set Vechicle
	var CurrentVehicle = find_node("VehicleSprites")
	CurrentVehicle.play(VehicleSelected)
	

func _on_Button_ChooseVehicle_pressed():
	AudioPlayer.play_sfx("res://audio/sfx/click_002.ogg")
	if (VehicleMenuOpen):
		#get_node("Button_ChooseCharacter").text = "Change"
		get_node("Vehicle Menu").hide()
		VehicleMenuOpen = false
		var av = $Avatar.hotswap(Server.selfplayer.avatar)
		av.z_index = 1
		add_child(av,true)
	else:
		#get_node("Button_ChooseCharacter").text = "Close"
		get_node("Vehicle Menu").show()
		VehicleMenuOpen = true
		var av = $Avatar.hotswap(Server.selfplayer.avatar)
		av.z_index = -1
		add_child(av,true)

func _set_Vehicle_Selection():
	var VehicleSelection = get_node("Vehicle Menu/ColorRect/ButtonSelection/MarginContainer/GridContainer")
	for vehicle_name in VehicleStyles:
		var car_button = preload("res://Menus/CarButton.tscn").instance()
		car_button.connect("pressed", self, "_on_ChangeVehicle_pressed", [vehicle_name])
		var VehicleDisplay = car_button.find_node("VehicleDisplay")
		car_button.get_node("AvatarType").bbcode_text = "[center]"+vehicle_name+"[/center]"
		VehicleDisplay.animation = vehicle_name
		VehicleSelection.add_child(car_button)

func _on_Button_ChooseHat_pressed():
	AudioPlayer.play_sfx("res://audio/sfx/click_002.ogg")
	if (HatMenuOpen):
		#get_node("Button_ChooseCharacter").text = "Change"
		find_node("Hat Menu").hide()
		HatMenuOpen = false
		var av = $Avatar.hotswap(Server.selfplayer.avatar)
		av.z_index = 1
		add_child(av,true)
	else:
		#get_node("Button_ChooseCharacter").text = "Close"
		find_node("Hat Menu").show()
		_set_Hat_Selection()
		HatMenuOpen = true
		var av = $Avatar.hotswap(Server.selfplayer.avatar)
		av.z_index = -1
		add_child(av,true)

func _set_Hat_Selection():
	var HatSelection = find_node("Hat Menu").find_node("ColorRect").find_node("ButtonSelection")
	var currentNode = HatSelection
	for i in 8:
		currentNode = HatSelection.find_node("Avatar" + str(i))
		if(i < HatStyles.size()):
			currentNode.find_node("AvatarType").text = HatStyles[i]
			currentNode.show()
		else:
			currentNode.find_node("AvatarType").text = "Null"
			currentNode.hide()
	var av = $Avatar.hotswap(Server.selfplayer.avatar)
	av.z_index = 1
	add_child(av,true)

func _on_Button_ChooseCharacter_pressed():
	AudioPlayer.play_sfx("res://audio/sfx/click_002.ogg")
	if (AvatarMenuOpen):
		#get_node("Button_ChooseCharacter").text = "Change"
		find_node("Avatar Menu").hide()
		AvatarMenuOpen = false
		var av = $Avatar.hotswap(Server.selfplayer.avatar)
		av.z_index = 1
		add_child(av,true)
	else:
		#get_node("Button_ChooseCharacter").text = "Close"
		find_node("Avatar Menu").show()
		_set_Avatar_Selection()
		AvatarMenuOpen = true
		var av = $Avatar.hotswap(Server.selfplayer.avatar)
		av.z_index = -1
		add_child(av,true)

func _set_Avatar_Selection():
	
	var AvatarSelection = find_node("Avatar Menu").find_node("ColorRect").find_node("ButtonSelection")
	var currentNode = AvatarSelection
	for i in 8:
		currentNode = AvatarSelection.find_node("Avatar" + str(i))
		if(i < AvatarStyles.size()):
			currentNode.find_node("AvatarType").text = AvatarStyles[i]
			currentNode.show()
		else:
			currentNode.find_node("AvatarType").text = "Null"
			currentNode.hide()
			

func _on_EnterGameButton_pressed():
	get_tree().change_scene("res://minigames/PartyScreen/LoadingScreen.tscn")
	Server.attemptEnterGame()
