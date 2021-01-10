extends Node


var StarMap
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
	

