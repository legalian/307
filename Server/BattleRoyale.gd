extends "res://GameBase.gd"




remote func shoot():
	var player_id = get_tree().get_rpc_sender_id()
	print(str(player_id)+" is shooting.")

func systemname():
	return "BattleRoyale"


