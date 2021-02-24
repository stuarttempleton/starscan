extends Node


var StarShip
var Loaded = false
var SavedSinceLoad = false
var DatabaseFileName = "res://ship_data/shiptestdata.json"
var SavedDatabaseFileName = "user://shiptestdata_PLAYERSAVE.json"

signal FuelTanksEmpty

func _ready():
	self.LoadShipData(DatabaseFileName)
	
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
	self.LoadShipData(DatabaseFileName)
	var dir = Directory.new()
	dir.remove(SavedDatabaseFileName)
	self.SaveShip()

func LoadSave() :
	if (!self.SaveExists()):
		self.LoadShipData(DatabaseFileName)
		self.SaveShip()
	self.LoadShipData(SavedDatabaseFileName)

func SaveShip() :
	self.Save(SavedDatabaseFileName)
	
func SaveExists():
	var save_file = File.new()
	return save_file.file_exists(SavedDatabaseFileName)
	
func LoadShipData(filename):
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
		
func ConsumeFuel(amount):
	StarShip.Fuel -= amount
	if StarShip.Fuel < 0.001:
		StarShip.Fuel = 0
		emit_signal("FuelTanksEmpty")
		
func Refuel():
	StarShip.Fuel = StarShip.FuelCapacity

func PayToVisitAStar():
	return PayResourcesDefaultToCrew(2, 1.0)
	
func PayToVisitAPlanet():
	return PayResourcesDefaultToCrew(1, 1.0)

func TurnInArtifacts():
	var qty = TurnInCargoType("Artifacts",0)
	StarShip.DeliveredArtifacts += qty
	print("Turned in " + str(qty) + " artifacts.")
	return qty #report how many we turned in for displayor whatever


func TurnInCargoType(cargoType, tradeValue):
	var qty = GetInventoryQTYFor(cargoType)
	var loot = qty * tradeValue
	GainInventoryItem(cargoType, qty * -1) #nuke it
	return qty


func GetInventoryQTYFor(resourceName):
	var qty = 0
	for cargo in StarShip.Inventory:
		if cargo.Type == resourceName:
			return cargo.Quantity
			break
	return qty


func GainInventoryItem(resourceName, resourcesToGain):
	var updated = false
	
	for cargo in StarShip.Inventory:
		if cargo.Type == resourceName:
			cargo.Quantity += resourcesToGain
			updated = true
			break
	if !updated:
		#add it
		StarShip.Inventory.append({
			"Type": resourceName,
			"Quantity": resourcesToGain })

func PayResourcesDefaultToCrew(resourcesToPay, crewLostPerUnpaidResource):
	var paid = {
		"Resources" : resourcesToPay,
		"Crew" : 0
	}
	
	var availableResources
	for cargo in StarShip.Inventory:
		if cargo.Type == "Resources":
			availableResources = cargo
			break
	
	if availableResources == null || availableResources.Quantity < paid.Resources:
		var difference = paid.Resources
		
		if availableResources != null:
			paid.Resources = availableResources.Quantity
			difference -= availableResources.Quantity
			availableResources.Quantity = 0
		
		paid.Crew = difference * crewLostPerUnpaidResource
		DeductCrew(paid.Crew)
	else:
		availableResources.Quantity -= paid.Resources
	
	return paid

func DeductCrew(crewLost):
	StarShip.Crew -= crewLost
	#TODO: report new crew count to GameController for game over check
