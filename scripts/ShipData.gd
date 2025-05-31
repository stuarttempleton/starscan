extends Node

#region Variables and Signals

var StarShip
var Loaded = false
var SavedSinceLoad = false
var DefaultShipFile = "res://ship_data/shiptestdata.json"
var SavedShipFile = "user://Player_Ship_Data.json"

signal FuelTanksEmpty

#endregion

#region Lifecycle

func _ready():
	self.LoadShipData(DefaultShipFile)

#endregion

#region Data Management

func ResetShip():
	self.LoadShipData(DefaultShipFile)
	StarShip.ShipSeedNumber = randi()
	StarShip.Captain = WordGenerator.Create(StarShip.ShipSeedNumber, StarMapData.GetRandomCulture(StarShip.ShipSeedNumber)).capitalize()
	AddItemListToInventory(ItemFactory.GenerateItemList(ItemFactory.ItemTypes.RESOURCE, 8))
	var dir = Directory.new()
	dir.remove(SavedShipFile)
	self.SaveShip()

func LoadSave():
	if (!self.SaveExists()):
		self.LoadShipData(DefaultShipFile)
		self.SaveShip()
	self.LoadShipData(SavedShipFile)

func SaveShip():
	self.Save(SavedShipFile)

func SaveExists():
	var save_file = File.new()
	return save_file.file_exists(SavedShipFile)

func LoadShipData(filename):
	print("Loading ship data from %s" % filename)
	var shipdata_file = File.new()
	shipdata_file.open(filename, File.READ)
	var shipdata_json = JSON.parse(shipdata_file.get_as_text())
	shipdata_file.close()
	StarShip = shipdata_json.result
	
	# Set default known routes if needed
	if !StarShip.has("KnownRoutes") || StarShip.KnownRoutes == null:
		StarShip.KnownRoutes = []
		
	# Set default ship sector if needed
	if !StarShip.has("Sector"):
		StarShip.Sector = 0
		
	Loaded = true
	SavedSinceLoad = false

func Save(filename):
	var file = File.new()
	file.open(filename, File.WRITE)
	file.store_string(JSON.print(StarShip, "\t"))
	file.close()
	SavedSinceLoad = true

#endregion

#region Accessors

func Inventory():
	if !Loaded:
		print("Ship Data Not Loaded! FAILING ON PURPOSE FIX THIS")
	else:
		return StarShip.Inventory

func Ship():
	if !Loaded:
		print("Ship Data Not Loaded! FAILING ON PURPOSE FIX THIS")
	else:
		return StarShip

func GetPosition(useMapScale = true):
	var scale = StarMapData.MapScale if useMapScale else 1
	return Vector2(StarShip.X, StarShip.Y) * scale

#endregion

#region Fuel Management

func ConsumeFuel(amount):
	if Cheat.godmode_enabled: return
	
	StarShip.Fuel -= amount
	if StarShip.Fuel < 0.001:
		StarShip.Fuel = 0
		emit_signal("FuelTanksEmpty")

func Refuel():
	StarShip.Fuel = StarShip.FuelCapacity

#endregion

#region Resource and Crew Payment

func PayToVisitAStar():
	return PayResourcesDefaultToCrew(2, 1.0)

func PayToVisitAPlanet():
	return PayResourcesDefaultToCrew(1, 1.0)

func PayResourcesDefaultToCrew(resourcesToPay, _crewLostPerUnpaidResource):
	var paid = {
		"Resources": resourcesToPay,
		"Crew": 0
	}
	paid.Resources = RemoveQTYItemsFromInventory(ItemFactory.ItemTypes.RESOURCE, resourcesToPay)
	paid.Crew = DeductCrew(resourcesToPay - paid.Resources)
	return paid

func DeductCrew(crewLost):
	if Cheat.godmode_enabled: return 0
	if crewLost == 0: return 0
	
	UpdatePlayStat("CrewLost", crewLost)
	StarShip.Crew -= crewLost
	return crewLost

#endregion

#region Inventory Management

func AddItemToInventory(_item):
	StarShip.Inventory.append(_item)

func AddItemListToInventory(_items = []):
	for _item in _items:
		AddItemToInventory(_item)

func GetInventoryFor(_itemType: int = 0):
	var items = []
	for item in StarShip.Inventory:
		if item.Type == _itemType:
			items.append(item)
	return items

func GetInventoryQTYFor(_itemType: int = 0):
	var qty = 0
	for _item in StarShip.Inventory:
		if _item.Type == _itemType:
			qty += 1
	return qty

func RemoveItemFromInventory(_item):
	StarShip.Inventory.erase(_item)

func RemoveItemFromInventoryBySeed(_seed):
	for item in StarShip.Inventory:
		if item.Seed == _seed:
			StarShip.Inventory.erase(item)

func RemoveQTYItemsFromInventory(_itemType: int = 0, _qty = 0):
	var qty = 0
	var items = GetInventoryFor(_itemType)
	items.shuffle()
	for item in items:
		qty += 1
		StarShip.Inventory.erase(item)
		if qty == _qty:
			break
	return qty

#endregion

#region Artifact Turn-In

func DeductArtifact(_Payment):
	var qty = RemoveQTYItemsFromInventory(ItemFactory.ItemTypes.ARTIFACT, _Payment)
	return qty

func TurnInArtifacts(_items: Array = []):
	var qty = _items.size()
	for item in _items:
		RemoveItemFromInventory(item)
	StarShip.DeliveredArtifacts += qty
	UpdatePlayStat("ArtifactsTurnedIn", qty)
	return qty

func TurnInArtifact(_item):
	TurnInArtifacts([_item])

func TurnInArtifactsBySeed(_seed):
	var items = []
	for item in StarShip.Inventory:
		if item.Seed == _seed:
			items.append(item)
	TurnInArtifacts(items)

#endregion

#region Route and Navigation

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

#endregion

#region Statistics

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

#endregion
