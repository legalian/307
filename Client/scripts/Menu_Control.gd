extends Control

func _MUT_recieve_partycode():
	var file = File.new()
	file.open("user://saved_partycode.dat", file.READ)
	var partycode = file.get_as_text()
	file.close()
	$PartyCodeTextEdit.text = partycode
	
func _ready():
	var multi_user_testing = OS.get_environment("MULTI_USER_TESTING");
	var active_corner = OS.get_environment("ACTIVECORNER");
	var desired_screen = OS.get_environment("DESIREDSCREEN");
	var flows_leader = {"party":"Multi_User_Testing_Partylead"}#,"lobby":"","quickplay":""}
	var flows_follower = {"party":"Multi_User_Testing_Partyfollow"}#,"lobby":"","quickplay":""}
	if flows_leader.has(multi_user_testing):
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
			$MUT_test_flow.play(flows_leader[multi_user_testing])
		else:
			$MUT_test_flow.play(flows_follower[multi_user_testing])
	
func _on_Button_Exit_pressed():
	AudioPlayer.play_sfx("res://audio/sfx/click_002.ogg")
	get_tree().quit()


func _on_Button_Start_pressed():
	AudioPlayer.play_sfx("res://audio/sfx/click_002.ogg")

func _on_Button_Settings_pressed():
	AudioPlayer.play_sfx("res://audio/sfx/click_002.ogg")
	# Show the Option Menu
	#get_node("Option_Control").show()
	pass

func _on_Button_Create_Party_pressed():
	AudioPlayer.play_sfx("res://audio/sfx/click_002.ogg")
	var server = get_node("/root/Server")
	server.createParty()

func _on_Button_Join_Party_pressed():
	AudioPlayer.play_sfx("res://audio/sfx/click_002.ogg")
	var server = get_node("/root/Server")
	server.join_party(get_node("PartyCodeTextEdit").text)

func _on_Button_Profile_pressed():
	AudioPlayer.play_sfx("res://audio/sfx/click_002.ogg")
	var _success = get_tree().change_scene("res://Menus/Profile.tscn")
