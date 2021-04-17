extends Node

const CONFIG_PATH = "user://settings.cfg"

const buses = ["master", "music", "sfx"]
const audio_defaults = {"muted": false, "volume": 100}
const profile_settings = []

var ip
var config

func _ready():
	config = ConfigFile.new()
	var err = config.load(CONFIG_PATH)
	
	if err == ERR_FILE_NOT_FOUND:
		config.save(CONFIG_PATH)
	
	err = config.load(CONFIG_PATH)
	if err == OK:
		load_config()


func _exit_tree():
	save_config()


func save_config():
	for bus in buses:
		for setting in audio_defaults.keys():
			var full_name = bus+"_"+setting
			var prefix = "is_" if setting == "muted" else "get_"
			var value = AudioPlayer.call(prefix+full_name)
			config.set_value("audio", full_name, value)
	config.save(CONFIG_PATH)


func load_config():
	for bus in buses:
		for setting in audio_defaults.keys():
			var full_name = bus+"_"+setting
			var value = config.get_value("audio", full_name, audio_defaults[setting])
			AudioPlayer.call("set_"+full_name, value)
