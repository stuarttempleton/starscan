extends Node


export var default_prefs_file_name = "res://PlayerPrefs/DefaultPlayerPrefs.json"
export var prefs_file_name = "user://PlayerPrefs.json"

var settings = {}
var saved_since_load = false
var loaded = false


func _init():
	if (!self._player_prefs_exists()):
		self._load_data(default_prefs_file_name)
		self._save_data()
	self._load_data(prefs_file_name)


func has_pref(property):
	return settings.has(property)

func get_pref(property, default_return = 0):
	if has_pref(property):
		return settings[property]
	else:
		printerr("Unknown property requested: ", property)
		return default_return


func set_pref(property, value):
	settings[property] = value
	_save_data()


func _player_prefs_exists():
	var save_file = File.new()
	return save_file.file_exists(prefs_file_name)


func _load_data(filename):
	print("Loading player preference data from %s" % filename)
	var _file = File.new()
	_file.open(filename, File.READ)
	var _json = JSON.parse(_file.get_as_text())
	_file.close()
	settings = _json.result
	loaded = true
	saved_since_load = false


func _save_data(filename = prefs_file_name):
	var file = File.new()
	file.open(filename, File.WRITE)
	file.store_string(JSON.print(settings, "\t"))
	file.close()
	saved_since_load = true;
