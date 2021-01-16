extends Control

export var system_detail_boilerplate = "Outpost: %s\r\nPlanets: %d\r\nScan: %s\r\nSuitability: %s"

var DisplayedSystem

func _ready():
	$Background.connect("mouse_entered",self,"mouse_enter")
	$Background.connect("mouse_exited",self,"mouse_exit")
	$Background/InfoContainer/ScanButton.connect("minigameComplete", self, "RefreshDisplayedData")

func mouse_enter():
	GameController.EnableDisableMovement(false)
	
func mouse_exit():
	GameController.EnableDisableMovement(true)

func ScanTextHelper(scan):
	if scan < 0.001:
		return "Unknown"
	else:
		return str(int(scan * 10) * 10) + "% identified"

func OutpostTextHelper(system):
	if StarMapData.SystemHasOutpost(system):
		return "Yes"
	else:
		return "No"

func InRange(system):
	$Background.visible = true
	if DisplayedSystem != system:
		DisplayedSystem = system
		RefreshDisplayedData()

func NotInRange():
	$Background.visible = false
	
func RefreshDisplayedData():
	RefreshSystemNameText()
	RefreshDetailText()
	RefreshScannability()
	
func RefreshSystemNameText():
	$Background/InfoContainer/SystemName.text = DisplayedSystem.Name
	
func RefreshDetailText():
	$Background/InfoContainer/SystemDetail.text = system_detail_boilerplate % [OutpostTextHelper(DisplayedSystem), DisplayedSystem.Planets.size(), ScanTextHelper(DisplayedSystem.Scan), "Unknown"]
	
func RefreshScannability():
	$Background/InfoContainer/ScanButton.disabled = (DisplayedSystem.Scan > 0)

func _process(_delta):
	StarMapData.FindNearestSystem(Vector2(ShipData.Ship().X,ShipData.Ship().Y))
	if (StarMapData.NearestSystemDistance * 1000 < 3 ):
		InRange(StarMapData.NearestSystem)
	else:
		NotInRange()
