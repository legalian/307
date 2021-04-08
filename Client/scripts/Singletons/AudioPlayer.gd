extends Node

var num_sfx_players = 8

var available = []  # The available sfx players.

var queue = []  # The queue of sfx to play.

var music_player

func _ready():
	for i in num_sfx_players:
		var p = AudioStreamPlayer.new()
		add_child(p)
		available.append(p)
		p.connect("finished", self, "_on_stream_finished", [p])
		p.bus = "SFX"
	
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.bus = "Music"

func _on_stream_finished(stream):
	# When finished playing a stream, make the player available again.
	available.append(stream)


func play_sfx(path):
	queue.append(path)
	
func play_music(path):
	music_player.stream = load(path)
	music_player.play()

func pause_music():
	music_player.playing = false

func resume_music():
	music_player.playing = true

func set_master_volume(percent):
	var vol_db = (100-percent)/100 * -60
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), vol_db)

func set_sfx_volume(percent):
	var vol_db = (100-percent)/100 * -60
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), vol_db)

func set_music_volume(percent):
	var vol_db = (100-percent)/100 * -60
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), vol_db)

func _process(delta):
	if not queue.empty() and not available.empty():
		available[0].stream = load(queue.pop_front())
		available[0].play()
		available.pop_front()
