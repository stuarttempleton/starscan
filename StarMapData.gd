extends Node


var StarMap
var MapScale = 10000
var Loaded = false
var SavedSinceLoad = false
var DatabaseFileName = "res://starmap_data/testdata.json"
var SavedDatabaseFileName = "res://starmap_data/testdata_PLAYERSAVE.json"


func _ready():
	self.LoadMapData(DatabaseFileName)
	
	#EXPLANATION
	
	#Print name of first planet in first system
	#print(self.Systems()[0].Planets[0].Name)
	#print(self.Systems()[0].X - self.Systems()[0].Y)
	
	#Change name of first planet in first system
	#self.Systems()[0].Planets[0].Name = "updated name!"
	
	#Save to a save file
	#self.Save(SavedDatabaseFileName)

func ResetMap() :
	self.LoadMapData(DatabaseFileName)
	var dir = Directory.new()
	dir.remove(SavedDatabaseFileName)

func LoadSave() :
	self.LoadMapData(SavedDatabaseFileName)

func SaveMap() :
	self.Save(SavedDatabaseFileName)
	
func SaveExists():
	var save_file = File.new()
	return save_file.file_exists(SavedDatabaseFileName)
	
func LoadMapData(filename):
	var starmapdata_file = File.new()
	starmapdata_file.open(filename, File.READ)
	var starmapdata_json = JSON.parse(starmapdata_file.get_as_text())
	starmapdata_file.close()
	StarMap = starmapdata_json.result
	Loaded = true
	SavedSinceLoad = false
	
func Save(filename):
	var file = File.new()
	file.open(filename, File.WRITE)
	file.store_string(JSON.print(StarMap, "\t"))
	file.close()
	SavedSinceLoad = true;
	
func Systems() :
	if !Loaded :
		print("StarMap Not Loaded! FAILING ON PURPOSE FIX THIS")
	else:
		return StarMap.Systems
	

