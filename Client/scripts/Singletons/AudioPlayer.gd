extends Node

const Buses = {MASTER = "Master", SFX = "SFX", MUSIC = "Music"}

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
		p.bus = Buses.SFX
	
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.bus = Buses.MUSIC

func play_sfx(path):
	queue.append(path)
	
func play_music(path):
	var stream = load(path)
	if stream != music_player.stream:
		music_player.stream = stream
		music_player.play()
		resume_music()

func pause_music():
	music_player.stream_paused = true

func resume_music():
	music_player.stream_paused = false


func set_master_volume(percent):
	_set_bus_volume(Buses.MASTER, percent)

func set_sfx_volume(percent):
	_set_bus_volume(Buses.SFX, percent)

func set_music_volume(percent):
	_set_bus_volume(Buses.MUSIC, percent)
	

func get_master_volume():
	return _get_bus_volume(Buses.MASTER)

func get_sfx_volume():
	return _get_bus_volume(Buses.SFX)

func get_music_volume():
	return _get_bus_volume(Buses.MUSIC)


func set_master_muted(muted):
	_set_bus_muted(Buses.MASTER, muted)
	
func set_sfx_muted(muted):
	_set_bus_muted(Buses.SFX, muted)
	
func set_music_muted(muted):
	_set_bus_muted(Buses.MUSIC, muted)
	

func is_master_muted():
	return _is_bus_muted(Buses.MASTER)
	
func is_sfx_muted():
	return _is_bus_muted(Buses.SFX)
	
func is_music_muted():
	return _is_bus_muted(Buses.MUSIC)


func _set_bus_muted(bus_name, muted):
	var bus_index = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_mute(bus_index, muted)
	
func _is_bus_muted(bus_name):
	var bus_index = AudioServer.get_bus_index(bus_name)
	return AudioServer.is_bus_mute(bus_index)
	
func _set_bus_volume(bus_name, percent):
	var bus_index = AudioServer.get_bus_index(bus_name)
	
	var vol_db = linear2db(percent/100.0)
	AudioServer.set_bus_volume_db(bus_index, vol_db)
	
func _get_bus_volume(bus_name):
	var bus_index = AudioServer.get_bus_index(bus_name)
	
	var vol_db = AudioServer.get_bus_volume_db(bus_index)
	return db2linear(vol_db)*100.0

func _on_stream_finished(stream):
	# When finished playing a stream, make the player available again.
	available.append(stream)

func _process(delta):
	if not queue.empty() and not available.empty():
		available[0].stream = load(queue.pop_front())
		available[0].play()
		available.pop_front()
