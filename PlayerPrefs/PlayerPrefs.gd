extends Node


export var DefaultPrefsFileName = "res://PlayerPrefs/DefaultPlayerPrefs.json"
export var PrefsFileName = "user://PlayerPrefs.json"

var settings = {}
var SavedSinceLoad = false
var Loaded = false


func _init():
	if (!self.PlayerPrefsExists()):
		self.Load(DefaultPrefsFileName)
		self.Save()
	self.Load(PrefsFileName)


func HasPref(property):
	return settings.has(property)

func GetPref(property, default_return = 0):
	if HasPref(property):
		return settings[property]
	else:
		printerr("Unknown property requested: ", property)
		return default_return


func SetPref(property, value):
	settings[property] = value
	Save()


func PlayerPrefsExists():
	var save_file = File.new()
	return save_file.file_exists(PrefsFileName)


func Load(filename):
	print("Loading player preference data from %s" % filename)
	var _file = File.new()
	_file.open(filename, File.READ)
	var _json = JSON.parse(_file.get_as_text())
	_file.close()
	settings = _json.result
	Loaded = true
	SavedSinceLoad = false


func Save(filename = PrefsFileName):
	var file = File.new()
	file.open(filename, File.WRITE)
	file.store_string(JSON.print(settings, "\t"))
	file.close()
	SavedSinceLoad = true;
