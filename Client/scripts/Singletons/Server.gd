extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
#var ip = "64.227.13.167"
var port = 1909

const Player = preload("res://scripts/MinigameServers/Player.gd")

var players = []

func _ready():
	ConnectToServer()
	
func ConnectToServer():
	network.create_client(ip,port)
	get_tree().set_network_peer(network)
	
	network.connect("connection_failed",self,"_OnConnectionFailed")
	network.connect("connection_succeeded",self,"_OnConnectionSucceeded")

func _OnConnectionFailed():
	print("Failed to connect")
	
func _OnConnectionSucceeded():
	print("Succesfully connected")
	players.append(Player.new({'id':get_tree().get_network_unique_id()}))
	#print("rpc call happened.")
	#rpc_id(1,"gameCall","shoot")
	
func attemptEnterGame():
	# var lobby_id = rpc_id(1, "matchmake", party_list)
	# rpc_id(1, "party_ready", lobby_id)
	rpc_id(1,"party_ready")

func createParty():
	rpc_id(1, "create_party")

func join_party(var partyID):
	rpc_id(1, "join_party", partyID)

remote func setminigame(systemname,lobbyname):
	for ms in get_children():
		remove_child(ms)
		ms.queue_free()
	print(get_children())
	var instance = load("res://scripts/MinigameServers/"+systemname+".tscn").instance()
	instance.name = lobbyname
	add_child(instance)
	get_tree().change_scene("res://minigames/"+systemname+"/World.tscn")
	print(get_children())


remote func receive_party_code(var recPartyID):
	print("Party created - code: " + str(recPartyID))
	#while (get_tree().current_scene.filename != "res://minigames/PartyScreen/World.tscn"):
		#print(get_tree().current_scene.filename)
		#continue
		#Do nothing
	#if (str(recPartyID) != str(100000)):
	#	get_tree().get_root().find_node("/root/Node2D/MainPartyCreationScreenLabel").text = recPartyID
	#else:
	#	get_tree().get_root().find_node("/root/Node2D/MainPartyCreationScreenLabel").text = "Invalid Code"
