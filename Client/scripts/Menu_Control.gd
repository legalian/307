#################################################
# @Author : Elisto								#
# @mail : elisto@protonmail.com				   	#	
# @Github : https://github.com/Elisto		   	#
#################################################

extends Control


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
