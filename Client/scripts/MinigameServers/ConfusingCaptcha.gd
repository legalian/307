extends "res://scripts/MinigameServers/MinigameBase.gd"

var clientstatus = "UNSPAWNED"
var gameinstance

var world_map = "Grass";
var selfPlayerInstance
var curQuestion = "TEST QUESTION";

func _ready():
	gameinstance = get_tree().get_root().get_node_or_null("/root/WorldContainer")
	if gameinstance!=null && gameinstance.get('world_type')!='captcha': gameinstance = null
	var _timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "syncUpdate")
	_timer.set_wait_time(0.1)#10 rpc updates per second
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()




func spawn(x, y):
	rpc_id(1,"spawn",x,y)

func syncUpdate():
	if gameinstance==null: return
	if players[0].playerID in gameinstance.players:
		rpc_unreliable_id(1,"syncUpdate",gameinstance.players[players[0].playerID].pack())

remote func questionText(textOfQuestion):
		curQuestion = textOfQuestion;
		

remote func frameUpdate(s_players, time):
	if gameinstance==null:
		gameinstance = get_tree().get_root().get_node_or_null("/root/WorldContainer")
		if gameinstance!=null && gameinstance.get('world_type')!='captcha': gameinstance = null
		if gameinstance==null: return
	var visited = []

	if gameinstance.world == null:
		gameinstance.load_map("Grass")
		#audio play stuff
	if(selfPlayerInstance == null):
		selfPlayerInstance = gameinstance.get_node_or_null("World/Player");
	else:
		selfPlayerInstance.find_node("RoundTime").setTime(time);
		selfPlayerInstance.find_node("Problem").setQuestion(curQuestion)
	for s_player in s_players:
		visited.append(s_player['id'])
		if s_player['id'] in gameinstance.players:
			gameinstance.players[s_player['id']].unpack(s_player)
		else:
			if s_player['id'] == players[0].playerID:
				gameinstance.players[s_player['id']] = preload("res://ConfusingCaptchaCharacters/RaccoonPlayer.tscn").instance()
			else:
				gameinstance.players[s_player['id']] = preload("res://ConfusingCaptchaCharacters/AutonomousAvatar.tscn").instance()
			gameinstance.get_node("World").add_child(gameinstance.players[s_player['id']])
			gameinstance.players[s_player['id']].unpack(s_player)
	var mustremove = []
	for player in gameinstance.players:
		if gameinstance.players[player].dying: continue
		if !visited.has(player): mustremove.append(player)
	for player in mustremove:
		gameinstance.get_node("World").remove_child(gameinstance.players[player])
		gameinstance.players[player].queue_free()
		gameinstance.players.erase(player)
	visited = []


remote func die(package):
	if gameinstance == null: return
	gameinstance.players[package['id']].unpack(package)
	gameinstance.players[package['id']].die()
	
remote func win(playerID):
	if playerID==players[0].playerID:
		get_tree().change_scene("res://minigames/ConfusingCaptcha/WinScreen.tscn")
	else:
		get_tree().change_scene("res://minigames/ConfusingCaptcha/LoseScreen.tscn")
	
remote func setMap(map):
	world_map = "Grass"

func showlose():
	get_tree().change_scene("res://minigames/ConfusingCaptcha/LoseScreen.tscn")
	
	





