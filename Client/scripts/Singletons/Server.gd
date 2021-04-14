extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
#var ip = "64.227.13.167"
var port = 1909

var partycode = "undefined"

const Player = preload("res://scripts/MinigameServers/Player.gd")

const MINIGAMES = ["PartyScreen", "BattleRoyale", "DemoDerby", "RacingGame", "MapSelection", "MinigameSelection", "Podium", "ConfusingCaptcha"]
var loading_queue

var selfplayer = Player.new({'id':null})
var players = [selfplayer]
# players[0] is yourself.

func _ready():
	loading_queue = preload("res://scripts/Resource_Loader.gd").new()
	loading_queue.start()
	for mg in MINIGAMES:
		loading_queue.queue_resource("res://minigames/"+mg+"/World.tscn")
		loading_queue.queue_resource("res://scripts/MinigameServers/"+mg+".tscn")
		
	ConnectToServer()

func ConnectToServer():
	network.create_client(ip,port)
	get_tree().set_network_peer(network)
	
	network.connect("connection_failed",self,"_OnConnectionFailed")
	network.connect("connection_succeeded",self,"_OnConnectionSucceeded")
	network.connect("server_disconnected", self, "_OnServerDisconnect")

func _OnServerDisconnect():
	# This will fire when the server disconnects.
	get_tree().change_scene("res://kick_from_serv.tscn")

func _OnConnectionFailed():
	print("Failed to connect")
	
func _OnConnectionSucceeded():
	print("Succesfully connected")
	players[0].playerID = get_tree().get_network_unique_id()
	var multi_user_testing = OS.get_environment("MULTI_USER_TESTING")
	var scenes_no_shim = ["party", "lobby", "quickplay", "podium", "battleroyale", "racing", "demoderby", "confusingcaptcha"]
	if (scenes_no_shim.has(multi_user_testing)):
		print("Client has noshim: " + multi_user_testing)
		var file = File.new()
		file.open("user://saved_partycode.dat", file.READ)
		var tmpCode = file.get_as_text()
		file.close()
		var file2 = File.new()
		file2.open("user://pc_created.dat", file.READ)
		var created = file.get_as_text()
		file2.close()
		if (tmpCode && (created || multi_user_testing == "party")):
			print("Joined party for test flow: " + tmpCode)
			join_party(tmpCode)
		else:
			print("Created party for test flow")
			createParty()

func attemptEnterGame():
	# var lobby_id = rpc_id(1, "matchmake", party_list)
	# rpc_id(1, "party_ready", lobby_id)
	rpc_id(1,"party_ready")

func createParty():
	if (network.get_connection_status() == network.CONNECTION_CONNECTED):
		rpc_id(1, "create_party",selfplayer.pack())
	else:
		get_tree().change_scene("res://disc_from_serv.tscn")

func join_party(var partyID):
	if (network.get_connection_status() == network.CONNECTION_CONNECTED):
		rpc_id(1, "join_party", partyID,selfplayer.pack())
	else:
		get_tree().change_scene("res://disc_from_serv.tscn")

func leave_party():
	if (network.get_connection_status() == network.CONNECTION_CONNECTED):
		if (str(partycode) != "undefined"):
			players.clear()
			players.append(selfplayer)
			rpc_id(1, "leave_party", partycode,selfplayer.pack())
		else:
			print("Cannot leave party that is undefined")
	else:
		get_tree().change_scene("res://disc_from_serv.tscn")

func cancel_matchmaking():
	rpc_id(1, "cancel_matchmaking")

remote func setminigame(systemname,lobbyname):
	for ms in get_children():
		remove_child(ms)
		ms.queue_free()
		
	var server_path = "res://scripts/MinigameServers/"+systemname+".tscn"
	var scene_path = "res://minigames/"+systemname+"/World.tscn"
	
	var server_resource = loading_queue.get_resource(server_path)
	var instance = server_resource.instance()
	instance.name = lobbyname
	print("created associate node: ",lobbyname," ",instance.name)
	add_child(instance,true)
	var scene_resource = loading_queue.get_resource(scene_path)
	var _success = get_tree().change_scene_to(scene_resource)

remote func receive_party_code(var recPartyID):
	print("Party created - code: " + str(recPartyID))
	partycode = recPartyID
	var node = get_tree().get_root().get_node_or_null("/root/Node2D/PartyCode")
	if node!=null: node.text = str(recPartyID)

	var file = File.new()
	file.open("user://saved_partycode.dat", file.WRITE)
	file.store_string(str(partycode))
	file.close()
	
	var file2 = File.new()
	file2.open("user://pc_created.dat", file.WRITE)
	file2.store_string(str(partycode))
	file2.close()

func get_player(player_id):
	for player in players:
		if player.playerID==player_id: return player

remote func add_players(packed):
	print("added players:",packed)
	for p in packed:
		var pl = get_player(p['id'])
		if pl!=null: pl.unpack(p)
		else: players.append(Player.new(p))
	var node = get_tree().get_root().get_node_or_null("/root/PartyScreen/Control/VBoxContainer/Playerlist")
	if node!=null:
		print("updated playerlist")
		node.update_playerlist()

remote func drop_player(player_id):
	for i in range(players.size()-1,-1,-1):
		if players[i].playerID==player_id: players.remove(i)
	var node = get_tree().get_root().get_node_or_null("/root/PartyScreen/Control/VBoxContainer/Playerlist")
	if node!=null:
		print("dropped player")
		node.update_playerlist()




