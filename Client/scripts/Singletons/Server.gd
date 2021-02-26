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
	rpc_id(1,"party_ready")

func createParty():
	rpc_id(1, "create_party")

func join_party(var partyID):
	rpc_id(1, "join_party", partyID)

remote func setlobby(systemname,lobbyname):
	for ms in get_children():
		remove_child(ms)
		ms.queue_free()
	print(get_children())
	var instance = load("res://scripts/MinigameServers/"+systemname+".tscn").instance()
	instance.name = lobbyname
	add_child(instance)
	get_tree().change_scene("res://minigames/"+systemname+"/World.tscn")
	print(get_children())

	
	
	
	
	

	








# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
