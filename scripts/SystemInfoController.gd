extends Control

export var system_detail_boilerplate = "Outpost: %s\r\nPlanets: %d\r\nScan: %s\r\nSuitability: %s"
export var nebula_detail_boilerplate = "Scan: %s\r\nDanger: %s\r\nDestination: %s"

var DisplayedSystem
var NarrativeYield = false

func _ready():
	# warning-ignore:return_value_discarded
	$Background/InfoContainer/ScanButton.connect("minigameComplete", self, "RefreshDisplayedData")

func NearestBody():
	var shipPos = Vector2(ShipData.Ship().X,ShipData.Ship().Y)
	StarMapData.FindNearestSystem(shipPos)
	
	var body = {}
	body.system = StarMapData.NearestSystem
	body.distance = StarMapData.NearestSystemDistance
	
	var nebula_distance = StarMapData.DistanceToNearestNebula(shipPos)
	
	if nebula_distance < body.distance:
		body.distance = nebula_distance
		body.system = StarMapData.NearestNebula
		
	return body

func _process(_delta):
	var body = NearestBody()
	if (body.distance * 1000 < 3 ):
		InRange(body.system)
	else:
		NotInRange()

func ScanTextHelper(scan):
	if scan < 0.001:
		return "Unknown"
	else:
		return str(int(scan * 100)) + "% identified"

func OutpostTextHelper(system):
	if StarMapData.SystemHasOutpost(system):
		return "Yes"
	else:
		return "No"

func NebulaDestinationHelper(nebula):
	var dest = "Unknown"
	if nebula.Scan > 0 and nebula.has("Destination"):
		dest = nebula.Destination
	return dest
	
func NebulaHazardHelper(nebula):
	if nebula.Scan > 0.8:
		return "LOW"
	if nebula.Scan > 0.5:
		return "MODERATE"
	if nebula.Scan > 0.2:
		return "HIGH"
	if nebula.Scan > 0:
		return "EXTREME"
	return "Unknown"
	
func InRange(system):
	#$ColorRect.visible = true
	$Background.visible = true
	if DisplayedSystem != system:
		DisplayedSystem = system
		RefreshDisplayedData()
	MovementEvent.add_deadzone(name, $ColorRect.get_global_rect())

func _exit_tree():
	MovementEvent.remove_deadzone(name)

func NotInRange():
	#$ColorRect.visible = false
	$Background.visible = false
	MovementEvent.remove_deadzone(name)
	
func RefreshDisplayedData():
	RefreshSystemNameText()
	RefreshDetailText()
	RefreshButtonEnable()
	RefreshButtonText()

func RefreshButtonText():
	$Background/InfoContainer/ScanButton.text = "Scan System"
	$Background/InfoContainer/EnterButton.text = "Enter System"
	if DisplayedSystem.has("Destination"):
		$Background/InfoContainer/ScanButton.text = "Scan Anomaly"
		$Background/InfoContainer/EnterButton.text = "Enter Anomaly"

func RefreshSystemNameText():
	$Background/InfoContainer/SystemName.text = DisplayedSystem.Name

func RefreshDetailText():
	if DisplayedSystem.has("Planets"):
		$Background/InfoContainer/SystemDetail.text = system_detail_boilerplate % [OutpostTextHelper(DisplayedSystem), DisplayedSystem.Planets.size(), ScanTextHelper(DisplayedSystem.Scan), "Unknown"]
	else:
		$Background/InfoContainer/SystemDetail.text = nebula_detail_boilerplate % [ScanTextHelper(DisplayedSystem.Scan), NebulaHazardHelper(DisplayedSystem), NebulaDestinationHelper(DisplayedSystem)]

func RefreshButtonEnable():
	var scan = DisplayedSystem.Scan
	$Background/InfoContainer/ScanButton.disabled = (scan > 0)
	$Background/InfoContainer/ScanButton.visible = (scan <= 0)
	if DisplayedSystem.has("Destination"):
		$Background/InfoContainer/EnterButton.disabled = (scan <= 0)
	else:
		$Background/InfoContainer/EnterButton.disabled = false

