extends VBoxContainer

func _ready():
	self.visible = true
	pass # Replace with function body.

func add_scoreboard(var players):
	for player in players:
		var player_row = HBoxContainer.new()
		
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
