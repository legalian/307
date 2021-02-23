extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
#var ip = "64.227.13.167"
var port = 1909


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
	#print("rpc call happened.")
	#rpc_id(1,"gameCall","shoot")
	
remote func setlobby(systemname):
	var instance = load("res://scripts/MinigameServers/"+systemname+".tscn").instance()
	instance.name = systemname
	add_child(instance)
	
	
	
	
	
	

	








# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
