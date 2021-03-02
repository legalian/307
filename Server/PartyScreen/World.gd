extends "res://GameBase.gd"
func systemname():
	return "PartyScreen"


func add_player(newplayer):
	for player in players:
		rpc_id(player.playerID,"add_player",newplayer.pack())
		rpc_id(newplayer.playerID,"add_player",player.pack())
	players.append(newplayer)
	print("player has been added to PartyScreen.")

remote func setusername(name):
	var player_id = get_tree().get_rpc_sender_id()
	get_player(player_id).username = name
	for player in players:
		if player.playerID!=player_id: rpc(player.playerID,"setusername",player_id,name)
	
remote func setavatar(avatar):
	var player_id = get_tree().get_rpc_sender_id()
	get_player(player_id).avatar = avatar
	for player in players:
		if player.playerID!=player_id: rpc(player.playerID,"setavatar",player_id,avatar)
	
remote func sethat(hat):
	var player_id = get_tree().get_rpc_sender_id()
	get_player(player_id).hat = hat
	for player in players:
		if player.playerID!=player_id: rpc(player.playerID,"sethat",player_id,hat)
	

