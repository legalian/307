extends Node2D

var regex = RegEx.new()
var UsernameInput = null

var generalserver = null
var specificserver = null



# Called when the node enters the scene tree for the first time.
#func _ready():
	#generalserver = get_node("/root/Server")
	#specificserver = generalserver.get_children()[0]
	#print(get_node("MainPartyCreationScreenLabel").get_path())
	

func _on_UsernameInput_text_changed(new_username):
	UsernameInput = new_username
	#print(new_username)


func _on_Button_Back_pressed():
	#generalserver.attemptEnterGame()
	get_tree().change_scene("Main.tscn")


func _on_Button_ConfirmUsername_pressed():
	#print(UsernameInput)
	#regex.compile("^[A-Za-z]+$")
	#var result = regex.search(UsernameInput)
	#var validCharacters = (result.get_string() == UsernameInput)
	
	if (UsernameInput.length() >= 3 and UsernameInput.length() <= 16): #and validCharacters):
		print(true)
	else:
		print(false)


