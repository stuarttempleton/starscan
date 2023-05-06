extends Node


var StarShip
var Loaded = false
var SavedSinceLoad = false
var DefaultShipFile = "res://ship_data/shiptestdata.json"
var SavedShipFile = "user://Player_Ship_Data.json"

signal FuelTanksEmpty

func _ready():
	self.LoadShipData(DefaultShipFile)
	
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
	self.LoadShipData(DefaultShipFile)
	StarShip.Captain = $"/root/StoryGenerator/WordGenerator".CreateWord().capitalize()
	StarShip.ShipSeedNumber = randi()
	DirAccess.remove_absolute(SavedShipFile)
	self.SaveShip()

func LoadSave() :
	if (!self.SaveExists()):
		self.LoadShipData(DefaultShipFile)
		self.SaveShip()
	self.LoadShipData(SavedShipFile)

func SaveShip() :
	self.Save(SavedShipFile)
	
func SaveExists():
	return FileAccess.file_exists(SavedShipFile)
	
func LoadShipData(filename):
	print("Loading ship data from %s" % filename)
	var shipdata_file = FileAccess.open(filename, FileAccess.READ)
	var json = JSON.new()
	json.parse(shipdata_file.get_as_text())
	shipdata_file.close()
	StarShip = json.data
	
	# Set default known routes if needed
	if !StarShip.has("KnownRoutes") || StarShip.KnownRoutes == null:
		StarShip.KnownRoutes = []
		
	# Set default ship sector if needed
	if !StarShip.has("Sector"):
		StarShip.Sector = 0
	Loaded = true
	SavedSinceLoad = false
	
func Save(filename):
	var file = FileAccess.open(filename, FileAccess.WRITE)
	file.store_string(JSON.stringify(StarShip, "\t"))
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

func DeductArtifact(_Payment):
	var qty = TurnInCargoType("Artifacts",0, _Payment)
	return qty

func TurnInArtifacts():
	var qty = TurnInCargoType("Artifacts",0, GetInventoryQTYFor("Artifacts"))
	StarShip.DeliveredArtifacts += qty
	UpdatePlayStat("ArtifactsTurnedIn", qty)
	return qty #report how many we turned in for displayor whatever


func TurnInCargoType(cargoType, _tradeValue, qty):
	if qty > GetInventoryQTYFor(cargoType):
		qty = GetInventoryQTYFor(cargoType)
	GainInventoryItem(cargoType, qty * -1) #nuke it
	return qty


func GetInventoryQTYFor(resourceName):
	var qty = 0
	for cargo in StarShip.Inventory:
		if cargo.Type == resourceName:
			return cargo.Quantity
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
	UpdatePlayStat("CrewLost", crewLost)
	StarShip.Crew -= crewLost
	return crewLost

func AddRouteList(Routes):
	var added = 0
	for route in Routes:
		added += AddKnownRoute(route)
	return added

func AddKnownRoute(Route):
	if !StarMapData.RouteListHas(StarShip.KnownRoutes, Route):
		StarShip.KnownRoutes.append(Route)
		return 1
	return 0

func GetPosition(useMapScale = true):
	var scale = StarMapData.MapScale if useMapScale else 1
	return Vector2(StarShip.X, StarShip.Y) * scale


func UpdatePlayStat(stat, qty):
	if StarShip.PlayStats.has(stat):
		StarShip.PlayStats[stat] += qty
	else:
		StarShip.PlayStats[stat] = qty

func GetPlayStat(stat):
	var qty = 0
	if StarShip.PlayStats.has(stat):
		qty = StarShip.PlayStats[stat]
	return qty


