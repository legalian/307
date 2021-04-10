extends Node

var SelfUsername
var AvatarSelected = 0

onready var generalserver = get_node("/root/Server")
var specificserver = null
var AvatarMenuOpen = false

var VehicleStyles = ["Sedan","Van","Truck","Race","Taxi","Ambulance","Hatchback","Police","Tractor","Garbage","Future","Firetruck"]

onready var partycodeNode = get_node("/root/PartyScreen/Control/VBoxContainer/HBoxContainer/PartyCode")

func _MUT_send_partycode():
	var partycode = find_node("PartyCode").text
	var file = File.new()
	file.open("user://saved_partycode.dat", file.WRITE)
	file.store_string(partycode)
	file.close()

func _MUT_set_username():
	$UsernameInput.text = ["Corge","Grault","Garply","Waldo"][int(OS.get_environment("ACTIVECORNER"))-1]

func _ready():
	specificserver = generalserver.get_children()[0]
	SelfUsername = generalserver.selfplayer.username
	find_node("PartyCode").text = str(generalserver.partycode)
	print(">>>_ready() PartyScreen/World.gd()")
	print("generalserver.partycode = " + str(generalserver.partycode))
	print("<<<_ready() PartyScreen/World.gd()")
	find_node("UsernameLabel").text = SelfUsername
	#if OS.get_environment("MULTI_USER_TESTING")=="party":
		#if OS.get_environment("ACTIVECORNER")=="1":
		#	$MUT_test_flow.play("Multi_User_Testing_Partylead")
		#else:
		#	$MUT_test_flow.play("Multi_User_Testing_Partyfollow")
		
	add_child($Raccoon.hotswap(generalserver.selfplayer.avatar),true)
	$Raccoon.set_Hat(generalserver.selfplayer.hat)
	var VehicleSelected = generalserver.selfplayer.vehicle
	var CurrentVehicle = find_node("VehicleSprites")
	CurrentVehicle.animation = VehicleStyles[VehicleSelected]

#may 2

func _on_Button_Back_pressed():
	#generalserver.attemptEnterGame()
	print("need to implement leave party functionality")
	get_tree().change_scene("Main.tscn")


func _on_EnterGameButton_pressed():
	get_tree().change_scene("res://minigames/PartyScreen/LoadingScreen.tscn")
	generalserver.attemptEnterGame()
	
	
func _on_Button_CopyCode_pressed():
	OS.set_clipboard(str(generalserver.partycode))
