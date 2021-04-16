extends VBoxContainer

func _ready():
	pass

func add_scoreboard(var players):	
	self.visible = true
	print("Adding " + str(players.size()) + " players to the scoreboard")
	for player in players:
		var player_row = HBoxContainer.new()
		
		player_row.add_constant_override("separation", 100);
		player_row.set_alignment(ALIGN_CENTER)
		
		var player_ID = Label.new()
		player_ID.text = str(player.playerID)
		player_row.add_child(player_ID)
		
		var player_score = Label.new()
		player_score.text = str(player.score)
		player_row.add_child(player_score)
		
		add_child(player_row)

func clear_scoreboard():
	for player_row in get_children():
		player_row.queue_free()
