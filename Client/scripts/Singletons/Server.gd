extends Node

var network = NetworkedMultiplayerENet.new()
#var ip = "127.0.0.1"
var ip = "64.227.13.167"
var port = 1909

var partycode = "undefined"

const Player = preload("res://scripts/MinigameServers/Player.gd")

var selfplayer = Player.new({'id':null})
var players = [selfplayer]
# players[0] is yourself.

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
	players[0].playerID = get_tree().get_network_unique_id()

func attemptEnterGame():
	# var lobby_id = rpc_id(1, "matchmake", party_list)
	# rpc_id(1, "party_ready", lobby_id)
	rpc_id(1,"party_ready")

func createParty():
	rpc_id(1, "create_party",selfplayer.pack())

func join_party(var partyID):
	rpc_id(1, "join_party", partyID,selfplayer.pack())

func cancel_matchmaking():
	rpc_id(1, "cancel_matchmaking")

remote func setminigame(systemname,lobbyname):
	for ms in get_children():
		remove_child(ms)
		ms.queue_free()
	var instance = load("res://scripts/MinigameServers/"+systemname+".tscn").instance()
	instance.name = lobbyname
	print("created associate node: ",lobbyname," ",instance.name)
	add_child(instance,true)
	var _success = get_tree().change_scene("res://minigames/"+systemname+"/World.tscn")

remote func receive_party_code(var recPartyID):
	print("Party created - code: " + str(recPartyID))
	partycode = recPartyID
	var node = get_tree().get_root().get_node_or_null("/root/Node2D/PartyCode")
	if node!=null: node.text = str(recPartyID)






func get_player(player_id):
	for player in players:
		if player.playerID==player_id: return player

remote func add_players(packed):
	print("added players:",packed)
	for p in packed:
		var pl = get_player(p['id'])
		if pl!=null: pl.unpack(p)
		else: players.append(Player.new(p))
	var node = get_tree().get_root().get_node_or_null("/root/Node2D/Playerlist")
	if node!=null:
		print("updated playerlist")
		node.update_playerlist()

remote func drop_player(player_id):
	for i in range(players.size()-1,-1,-1):
		if players[i].playerID==player_id: players.remove(i)
	var node = get_tree().get_root().get_node_or_null("/root/Node2D/Playerlist")
	if node!=null:
		print("dropped player")
		node.update_playerlist()




