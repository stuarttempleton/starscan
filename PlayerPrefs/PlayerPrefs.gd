extends Node


@export var default_prefs_file_name = "res://PlayerPrefs/DefaultPlayerPrefs.json"
@export var prefs_file_name = "user://PlayerPrefs.json"

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
	return FileAccess.file_exists(prefs_file_name)


func _load_data(filename):
	print("Loading player preference data from %s" % filename)
	var _file = FileAccess.open(filename, FileAccess.READ)
	var _json = JSON.new()
	_json.parse(_file.get_as_text())
	if _json.data:
		settings = _json.data
	else:
		settings = {}
	_file.close()
	loaded = true
	saved_since_load = false


func _save_data(filename = prefs_file_name):
	var file = FileAccess.open(filename, FileAccess.WRITE)
	file.store_string(JSON.stringify(settings, "\t"))
	file.close()
	saved_since_load = true;
