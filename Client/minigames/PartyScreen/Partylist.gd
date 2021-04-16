tool
extends VBoxContainer

func _ready():
	update_playerlist()

func update_playerlist():
	print("updated!")
	for player_row in get_children():
		player_row.queue_free()
	for player in Server.players:
		var player_ID = Label.new()
		player_ID.text = str(player.username)
		player_ID.add_color_override("font_color", Color(0, 1, 1, 1))
		add_child(player_ID)
