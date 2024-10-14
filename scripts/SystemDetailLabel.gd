extends Label


export var main_boiler_plate = "System %s...\r\nScan confidence: %s\r\nKnown planets: %d\r\n"
export var planet_sub_boiler_plate = "%s: %s, %s"
export var highlight_boiler_plate = "<b>%s</b>"

var display_speed = 0.5
var system

func ScanConfidence(scan):
	if(scan < 0.001):
		return "NONE"
	elif(scan < 0.33):
		return "LOW"
	elif(scan < 0.66):
		return "MODERATE"
	else:
		return "HIGH"

func _ready():
	if (StarMapData.NearestSystem == null):
		StarMapData.FindNearestSystem(Vector2(ShipData.Ship().X,ShipData.Ship().Y))
	system = StarMapData.NearestSystem
	UpdateSystemText() 
	percent_visible = 0

func _process(delta):
	if(percent_visible > 0.9):
		percent_visible = 1
	else:
		percent_visible += display_speed * delta
	pass

func UpdateSystemText(highlight_planet = ""):
	var details = main_boiler_plate % [system.Name, ScanConfidence(system.Scan), system.Planets.size()]
	for planet in system.Planets:
		var planetText = planet_sub_boiler_plate % [planet.Name, planet.Type, planet.Size]
		if highlight_planet == planet.Name:
			planetText = highlight_boiler_plate % planetText
		details = "%s\r\n%s" % [details, planetText]
	text = details
