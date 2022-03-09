extends Node


export var DefaultPrefsFileName = "res://PlayerPrefs/DefaultPlayerPrefs.json"
export var PrefsFileName = "user://PlayerPrefs.json"

var settings = {}
var SavedSinceLoad = false
var Loaded = false


func _init():
	LoadPrefs()


func LoadPrefs() :
	if (!self.PlayerPrefsExists()):
		self.LoadPrefsData(DefaultPrefsFileName)
		self.SavePrefs()
	self.LoadPrefsData(PrefsFileName)


func SavePrefs():
	self.Save(PrefsFileName)

func HasPref(property):
	return settings.has(property)

func GetPref(property):
	if HasPref(property):
		return settings[property]
	else:
		printerr("Unknown property requested: ", property)
		return 0


func SetPref(property, value):
	settings[property] = value
	SavePrefs()


func PlayerPrefsExists():
	var save_file = File.new()
	return save_file.file_exists(PrefsFileName)


func LoadPrefsData(filename):
	print("Loading player preference data from %s" % filename)
	var _file = File.new()
	_file.open(filename, File.READ)
	var _json = JSON.parse(_file.get_as_text())
	_file.close()
	settings = _json.result
	Loaded = true
	SavedSinceLoad = false


func Save(filename):
	var file = File.new()
	file.open(filename, File.WRITE)
	file.store_string(JSON.print(settings, "\t"))
	file.close()
	SavedSinceLoad = true;
