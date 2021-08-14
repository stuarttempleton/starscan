extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var boiler_plate = "%s (%.1f sector units)"
export var UseOutpostInstead = false
# Called when the node enters the scene tree for the first time.
func _ready():
	#SetSystemText()
	pass

func SetSystemText():
	var SystemName = "No Systems Nearby"
	var SystemDistance = INF
	if UseOutpostInstead:
		var ship = ShipData.Ship()
		var shipPos = Vector2(ship.X, ship.Y)
		var target = StarMapData.GetNearestOutpostSystem(shipPos)
		SystemName = target.Name
			
		SystemDistance = StarMapData.GetDistanceToSystem(shipPos, target)
		pass
	else:
		if StarMapData.NearestSystem != null: 
			SystemName = StarMapData.NearestSystem.Name
			SystemDistance = StarMapData.NearestSystemDistance
	text = boiler_plate % [SystemName, SystemDistance * StarMapData.MapScale]

func _physics_process(_delta):
	SetSystemText()
