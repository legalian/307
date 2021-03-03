#################################################
# @Author : Elisto								#
# @mail : elisto@protonmail.com				   	#	
# @Github : https://github.com/Elisto		   	#
#################################################

extends Control


func _MUT_send_partycode():
	var partycode = "ABRACADABRA"
	var file = File.new()
	file.open("user://saved_partycode.dat", file.WRITE)
	file.store_string(partycode)
	file.close()

func _MUT_recieve_partycode():
	var file = File.new()
	file.open("user://saved_partycode.dat", file.READ)
	var partycode = file.get_as_text()
	file.close()
	print("RECIEVED PARTYCODE: ",partycode)
	
	
func _ready():
	if OS.get_environment("MULTI_USER_TESTING")=="TRUE":
		var screen = int(OS.get_environment("DESIREDSCREEN"))
		OS.set_current_screen(screen)
		var windowdecoration = OS.get_real_window_size()-OS.window_size
		var realwindowsize = OS.get_screen_size(screen)/2
		OS.window_size = realwindowsize - windowdecoration
		if OS.get_environment("ACTIVECORNER")=="1":
			OS.window_position = OS.get_screen_position(screen)+Vector2(0,0)
		if OS.get_environment("ACTIVECORNER")=="2":
			OS.window_position = OS.get_screen_position(screen)+Vector2(realwindowsize.x,0)
		if OS.get_environment("ACTIVECORNER")=="3":
			OS.window_position = OS.get_screen_position(screen)+Vector2(0,realwindowsize.y)
		if OS.get_environment("ACTIVECORNER")=="4":
			OS.window_position = OS.get_screen_position(screen)+realwindowsize
		if OS.get_environment("ACTIVECORNER")=="1":
			$MUT_test_flow.play("Multi_User_Testing_Partylead")
		else:
			$MUT_test_flow.play("Multi_User_Testing_Partyfollow")
	
func _on_Button_Exit_pressed():
	# Exit the game
	get_tree().quit()


func _on_Button_Start_pressed():
	print(get_node("/root/Server"))
	#get_tree().change_scene("res://minigames/isometric_test/World.tscn")

func _on_Button_Settings_pressed():
	# Show the Option Menu
	#get_node("Option_Control").show()
	pass

func _on_Button_Create_Party_pressed():
	var server = get_node("/root/Server")
	var code = server.createParty()

func _on_Button_Join_Party_pressed():
	var player_id = get_tree().get_rpc_sender_id()
	var server = get_node("/root/Server")
	print("Joining with code: " + get_node("PartyCodeTextEdit").text)
	server.join_party(get_node("PartyCodeTextEdit").text)
	print("Join party button pressed")


func _on_Button_Profile_pressed():
	get_tree().change_scene("res://Menus/ProfileScreen/ProfileSettings.tscn")
