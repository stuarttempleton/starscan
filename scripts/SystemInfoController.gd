extends Control


var NearestSystem
export var system_detail_boilerplate = "Outpost: %s\r\nPlanets: %d\r\nScan: %s\r\nSuitability: %s"

func _ready():
	$Background.connect("mouse_entered",self,"mouse_enter")
	$Background.connect("mouse_exited",self,"mouse_exit")
	pass # Replace with function body.

func mouse_enter():
	print("mouse entered")
	GameController.EnableDisableMovement(false)
func mouse_exit():
	print("mouse exited")
	GameController.EnableDisableMovement(true)

func ScanTextHelper(scan):
	if scan:
		return "Yes"
	else:
		return "No"

func OutpustTextHelper(system):
	return "UNFINISHED"
	if StarMapData.SystemHasOutpost(system):
		return "Yes"
	else:
		return "No"

func InRange(system):
	$Background.visible = true
	if NearestSystem != system:
		NearestSystem = system
		$Background/InfoContainer/SystemName.text = system.Name
		$Background/InfoContainer/SystemDetail.text = system_detail_boilerplate % [OutpustTextHelper(system), system.Planets.size(), ScanTextHelper(system.Scan), "Unknown"]

func NotInRange():
	$Background.visible = false

func _process(_delta):
	var system = StarMapData.GetNearestSystem(Vector2(ShipData.Ship().X,ShipData.Ship().Y))
	if (system[1] * 1000 < 3 ):
		InRange(system[0])
	else:
		NotInRange()
