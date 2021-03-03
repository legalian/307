extends "res://GameBase.gd"
func systemname():
	return "BattleRoyale"




func add_player(newplayer):
	.add_player(newplayer)





remote func shoot():
	var player_id = get_tree().get_rpc_sender_id()
	print(str(player_id)+" is shooting.")




