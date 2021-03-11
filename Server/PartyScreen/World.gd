extends "res://GameBase.gd"
func systemname():
	return "PartyScreen"


remote func setusername(name):
	var player_id = get_tree().get_rpc_sender_id()
	get_player(player_id).username = name
	for player in players:
		if player.playerID!=player_id: rpc_id(player.playerID,"setusername",player_id,name)
	
remote func setavatar(avatar):
	var player_id = get_tree().get_rpc_sender_id()
	get_player(player_id).avatar = avatar
	for player in players:
		if player.playerID!=player_id: rpc_id(player.playerID,"setavatar",player_id,avatar)
	
remote func sethat(hat):
	var player_id = get_tree().get_rpc_sender_id()
	get_player(player_id).hat = hat
	for player in players:
		if player.playerID!=player_id: rpc_id(player.playerID,"sethat",player_id,hat)
	

