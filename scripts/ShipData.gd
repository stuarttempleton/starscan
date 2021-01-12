extends Node


var StarShip
var Loaded = false
var SavedSinceLoad = false
var DatabaseFileName = "res://ship_data/shiptestdata.json"
var SavedDatabaseFileName = "res://ship_data/shiptestdata_PLAYERSAVE.json"


func _ready():
	self.LoadMapData(DatabaseFileName)
	
	#EXPLANATION
	
	#Print name of ship
	#print(self.Ship().Name)
	
	#Print size of inventory[]
	#print(self.Inventory().size())
	
	#Append an inventory item (dupe the first entry)
	#self.Inventory().push_back(self.Inventory()[0])
	#print(self.Inventory().size())
	
	#Change name of first planet in first system
	#self.Systems()[0].Planets[0].Name = "updated name!"
	
	#Save to a save file
	#self.Save(SavedDatabaseFileName)
	
func ResetShip() :
	self.LoadMapData(DatabaseFileName)

func LoadSave() :
	self.LoadMapData(SavedDatabaseFileName)

func SaveShip() :
	self.Save(SavedDatabaseFileName)
	
func SaveExists():
	var save_file = File.new()
	return save_file.file_exists(SavedDatabaseFileName)
	
func LoadMapData(filename):
	var shipdata_file = File.new()
	shipdata_file.open(filename, File.READ)
	var shipdata_json = JSON.parse(shipdata_file.get_as_text())
	shipdata_file.close()
	StarShip = shipdata_json.result
	Loaded = true
	SavedSinceLoad = false
	
func Save(filename):
	var file = File.new()
	file.open(filename, File.WRITE)
	file.store_string(JSON.print(StarShip, "\t"))
	file.close()
	SavedSinceLoad = true;
	
func Inventory() :
	if !Loaded :
		print("Ship Data Not Loaded! FAILING ON PURPOSE FIX THIS")
	else:
		return StarShip.Inventory
		
func Ship() :
	if !Loaded :
		print("Ship Data Not Loaded! FAILING ON PURPOSE FIX THIS")
	else:
		return StarShip
