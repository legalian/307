extends Control


func _MUT_recieve_partycode():
	var file = File.new()
	file.open("user://saved_partycode.dat", file.READ)
	var partycode = file.get_as_text()
	file.close()
	$PartyCodeTextEdit.text = partycode
	
	
func _ready():
	var multi_user_testing = false;
	var active_corner = -1;
	var desired_screen = -1;
	
	if (OS.get_name() == "Windows"):
		# Windows Argument Parsing
		for argument in OS.get_cmdline_args():
			if argument.find("=") > -1:
				var arg = argument.split("=")[0].lstrip("-")
				var val = argument.split("=")[1]
				
				if (arg == "MULTI_USER_TESTING"):
					multi_user_testing = val
				if (arg == "ACTIVECORNER"):
					active_corner = val
				if (arg == "DESIREDSCREEN"):
					desired_screen = val
	else:
		# Linux Argument Parsing
		multi_user_testing = OS.get_environment("MULTI_USER_TESTING")
		active_corner = OS.get_environment("ACTIVECORNER")
		desired_screen = OS.get_environment("DESIREDSCREEN")
	
	if str(multi_user_testing) == "TRUE":
		var screen = int(desired_screen)%int(OS.get_screen_count())
		OS.set_current_screen(screen)
		var windowdecoration = OS.get_real_window_size()-OS.window_size
		var realwindowsize = OS.get_screen_size(screen)/2
		OS.window_size = realwindowsize - windowdecoration
		
		# Window splitting
		if str(active_corner) == "1":
			OS.window_position = OS.get_screen_position(screen)+Vector2(0,0)
		if str(active_corner) == "2":
			OS.window_position = OS.get_screen_position(screen)+Vector2(realwindowsize.x,0)
		if str(active_corner) == "3":
			OS.window_position = OS.get_screen_position(screen)+Vector2(0,realwindowsize.y)
		if str(active_corner) == "4":
			OS.window_position = OS.get_screen_position(screen)+realwindowsize

		# $MUT_test_flow
		if str(active_corner) == "1":
			$MUT_test_flow.play("Multi_User_Testing_Partylead")
		else:
			$MUT_test_flow.play("Multi_User_Testing_Partyfollow")
	
func _on_Button_Exit_pressed():
	# Exit the game
	get_tree().quit()


func _on_Button_Start_pressed():
	pass
	#get_tree().change_scene("res://minigames/isometric_test/World.tscn")

func _on_Button_Settings_pressed():
	# Show the Option Menu
	#get_node("Option_Control").show()
	pass

func _on_Button_Create_Party_pressed():
	var server = get_node("/root/Server")
	server.createParty()

func _on_Button_Join_Party_pressed():
	var server = get_node("/root/Server")
	server.join_party(get_node("PartyCodeTextEdit").text)

func _on_Button_Profile_pressed():
	var _success = get_tree().change_scene("res://Menus/Profile.tscn")
