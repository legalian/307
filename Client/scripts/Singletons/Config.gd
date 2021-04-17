extends Node

const CONFIG_PATH = "user://settings.cfg"

const buses = ["master", "music", "sfx"]
const audio_defaults = {"muted": false, "volume": 100}
const profile_settings = []

# Don't change these variables directly, change your settings file
# The path to it for your OS can be found at
# https://docs.godotengine.org/en/stable/tutorials/io/data_paths.html#user-path-persistent-data
# Our server ip is 64.227.13.167
var ip
var port

var username
var avatar
var hat
var vehicle

var config

func _ready():
	config = ConfigFile.new()
	var err = config.load(CONFIG_PATH)
	
	if err == ERR_FILE_NOT_FOUND:
		config.save(CONFIG_PATH)
	
	err = config.load(CONFIG_PATH)
	if err == OK:
		load_config()
	else:
		print("Error loading config file.")
		get_tree().quit()


func _exit_tree():
	save_config()


func save_config():
	for bus in buses:
		for setting in audio_defaults.keys():
			var full_name = bus+"_"+setting
			var prefix = "is_" if setting == "muted" else "get_"
			var value = AudioPlayer.call(prefix+full_name)
			config.set_value("audio", full_name, value)
	
	config.set_value("network", "ip", ip)
	config.set_value("network", "port", port)
	
	config.set_value("profile", "username", Server.selfplayer.username)
	config.set_value("profile", "avatar", Server.selfplayer.avatar)
	config.set_value("profile", "hat", Server.selfplayer.hat)
	config.set_value("profile", "vehicle", Server.selfplayer.vehicle)
	
	config.save(CONFIG_PATH)


func load_config():
	for bus in buses:
		for setting in audio_defaults.keys():
			var full_name = bus+"_"+setting
			var value = config.get_value("audio", full_name, audio_defaults[setting])
			AudioPlayer.call("set_"+full_name, value)
	
	ip = config.get_value("network", "ip", "127.0.0.1")
	port = config.get_value("network", "port", 1909)
	
	username = config.get_value("profile", "username", "Default")
	avatar = config.get_value("profile", "avatar", 0)
	hat = config.get_value("profile", "hat", 0)
	vehicle = config.get_value("profile", "vehicle", "Sedan")
	
