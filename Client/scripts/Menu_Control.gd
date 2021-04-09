extends Control

var initcache = [
	preload("res://BattleRoyaleCharacters/AutonomousAvatar.tscn"),
	preload("res://BattleRoyaleCharacters/RaccoonPlayer.tscn"),
	
	preload("res://Characters/Raccoon.tscn"),
	preload("res://Characters/RaccoonRed.tscn"),
	preload("res://Characters/RaccoonShadow.tscn"),
	
	preload("res://Guns/basicGun.tscn"),
	preload("res://Guns/BasicRedBullet.tscn"),
	preload("res://Guns/blueBigSniper.tscn"),
	preload("res://Guns/BlueMuzzleFlare.tscn"),
	preload("res://Guns/Collectible.tscn"),
	preload("res://Guns/GreenMuzzleFlare.tscn"),
	preload("res://Guns/greenUzi.tscn"),
	preload("res://Guns/purpleDualGun.tscn"),
	preload("res://Guns/PurpleMuzzleFlare.tscn"),
	preload("res://Guns/RedMuzzleFlare.tscn"),
	
	preload("res://Hats/Headphones.tscn"),
	preload("res://Hats/Paperhat.tscn"),
	preload("res://Hats/Tophat.tscn"),
	preload("res://Hats/Viking.tscn"),
	preload("res://Hats/Whitehat.tscn"),
	
	preload("res://minigames/BattleRoyale/World-Desert.tscn"),
	preload("res://minigames/BattleRoyale/World-Grass.tscn"),
	preload("res://minigames/BattleRoyale/World.tscn"),
	
	preload("res://minigames/DemoDerby/objects/demoDerbyCar.tscn"),
	preload("res://minigames/DemoDerby/objects/fence.tscn"),
	preload("res://minigames/DemoDerby/objects/flag.tscn"),
	preload("res://minigames/DemoDerby/objects/name.tscn"),
	preload("res://minigames/DemoDerby/objects/powerup.tscn"),
	preload("res://minigames/DemoDerby/objects/trap.tscn"),
	
	preload("res://minigames/DemoDerby/World-Desert.tscn"),
	preload("res://minigames/DemoDerby/World-Grass.tscn"),
	preload("res://minigames/DemoDerby/World.tscn"),
	
	
	preload("res://minigames/RacingGame/objects/racingCar.tscn"),
	preload("res://minigames/RacingGame/objects/fence.tscn"),
	preload("res://minigames/RacingGame/objects/flag.tscn"),
	preload("res://minigames/RacingGame/objects/name.tscn"),
	preload("res://minigames/RacingGame/objects/powerup.tscn"),
	preload("res://minigames/RacingGame/objects/PU_Proj.tscn"),
	preload("res://minigames/RacingGame/objects/trap.tscn"),
	
	preload("res://minigames/RacingGame/World-Desert.tscn"),
	preload("res://minigames/RacingGame/World-Grass.tscn"),
	preload("res://minigames/RacingGame/World.tscn"),
	
	
	preload("res://objects/bench.tscn"),
	preload("res://objects/cactus_short.tscn"),
	preload("res://objects/cactus_tall.tscn"),
	preload("res://objects/cactus_tall_60percentscaled.tscn"),
	preload("res://objects/car.tscn"),
	preload("res://objects/explosion.tscn"),
	preload("res://objects/monument.tscn"),
	preload("res://objects/staticcarSmallWithCollision.tscn"),
	preload("res://objects/statue.tscn"),
	preload("res://objects/stone.tscn"),
	preload("res://objects/stump2.tscn"),
	preload("res://objects/stump.tscn"),
	preload("res://objects/tent-closed.tscn"),
	preload("res://objects/tent.tscn"),
	preload("res://objects/tree1.tscn"),
	preload("res://objects/tree2.tscn"),
	preload("res://objects/tree3.tscn"),
	preload("res://objects/tree4.tscn"),
	
	
	preload("res://minigames/MapSelection/world.tscn"),
	preload("res://minigames/MinigameSelection/world.tscn"),
]

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
