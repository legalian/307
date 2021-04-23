tool
extends VBoxContainer

func _ready():
	update_playerlist()

func update_playerlist():
	print("updated!")
	for player_row in get_children():
		player_row.queue_free()
	var usernames = []
	for player in Server.players:
		usernames.append(str(player.username))
	usernames.sort()
	for n in usernames:
		var player_ID = Label.new()
		player_ID.text = n
		player_ID.add_color_override("font_color", Color(0, 1, 1, 1))
		add_child(player_ID)

