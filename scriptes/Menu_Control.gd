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
	get_tree().change_scene("res://minigames/driving_demo/World.tscn")

func _on_Button_Settings_pressed():
	# Show the Option Menu
	#get_node("Option_Control").show()
	pass



