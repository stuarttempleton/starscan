extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var boiler_plate = "Nearest System: %s (%fu)"

# Called when the node enters the scene tree for the first time.
func _ready():
	#SetSystemText(StarMapData.Systems()[0])
	pass

func SetSystemText(system):
	var SystemName = "No Systems Nearby"
	var SystemDistance = INF
	if StarMapData.NearestSystem != null: 
		SystemName = StarMapData.NearestSystem.Name
		SystemDistance = StarMapData.NearestSystemDistance
	text = boiler_plate % [SystemName, SystemDistance]

func _physics_process(_delta):
	SetSystemText(StarMapData.NearestSystem)
