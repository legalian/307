extends Control

func _MUT_recieve_partycode():
	var file = File.new()
	file.open("user://saved_partycode.dat", file.READ)
	var partycode = file.get_as_text()
	file.close()
	find_node("PartyCodeTextEdit").text = partycode
	
var gameTests = ["battleroyale", "racing", "demoderby", "confusingcaptcha", "battleroyale_shim", "racing_shim", "demoderby_shim", "podium_shim", "confusingcaptcha_shim"]

func _ready():
	var multi_user_testing = OS.get_environment("MULTI_USER_TESTING");
	var active_corner = OS.get_environment("ACTIVECORNER");
	var desired_screen = OS.get_environment("DESIREDSCREEN");
	if (Server.first_launch):
		Server.first_launch = false
		if(!gameTests.has(multi_user_testing)):
			find_node("IntroAnim").play("Intro")
		else:
			find_node("Overlay").visible = false
			find_node("VideoPlayer").visible = false
			find_node("TitleCreds").visible = false
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		AudioPlayer.play_music("res://audio/music/mainmenu" + str(rng.randi_range(1,2)) + ".ogg")
	else:
		find_node("Overlay").visible = false
		find_node("VideoPlayer").visible = false
		find_node("TitleCreds").visible = false
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
	Server.quickplay()
	get_tree().change_scene("res://minigames/PartyScreen/LoadingScreen.tscn")

func _on_Button_Settings_pressed():
	AudioPlayer.play_sfx("res://audio/sfx/click_002.ogg")
	var _success = get_tree().change_scene("res://Menus/Settings.tscn")

func _on_Button_Create_Party_pressed():
	AudioPlayer.play_sfx("res://audio/sfx/click_002.ogg")
	var server = get_node("/root/Server")
	server.createParty()

func _on_Button_Join_Party_pressed():
	AudioPlayer.play_sfx("res://audio/sfx/click_002.ogg")
	var server = get_node("/root/Server")
	if (find_node("PartyCodeTextEdit").text == null):
		return
	server.join_party(find_node("PartyCodeTextEdit").text)

func _on_Button_Profile_pressed():
	AudioPlayer.play_sfx("res://audio/sfx/click_002.ogg")
	var _success = get_tree().change_scene("res://Menus/Profile.tscn")
