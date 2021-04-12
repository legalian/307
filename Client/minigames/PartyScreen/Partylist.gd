tool
extends VBoxContainer

onready var generalserver = get_node("/root/Server")

func _ready():
	update_playerlist()
	print("was just ready-marked")

func update_playerlist():
	print("updated!")
	for player_row in get_children():
		player_row.queue_free()
	for player in generalserver.players:
		var player_ID = Label.new()
		player_ID.text = str(player.username)
		add_child(player_ID)
