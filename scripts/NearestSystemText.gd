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
	text = boiler_plate % [system[0].Name, system[1] * 1000]

func _physics_process(_delta):
	SetSystemText(StarMapData.GetNearestSystem(Vector2(ShipData.Ship().X,ShipData.Ship().Y)))
