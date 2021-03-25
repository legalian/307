extends VBoxContainer

func _ready():
	pass # Replace with function body.

func add_scoreboard(var players):	
	self.visible = true
	print("Adding " + str(players.size()) + " players to the scoreboard")
	for player in players:
		var player_row = HBoxContainer.new()
		
		player_row.add_constant_override("separation", 100);
		player_row.set_alignment(ALIGN_CENTER)
		
		var player_score = Label.new()
		player_score.text = str(player.place)
		player_row.add_child(player_score)
		
		var player_ID = Label.new()
		player_ID.text = str(player.id)
		player_row.add_child(player_ID)
		
		
		add_child(player_row)
