extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if (StarMapData.NearestSystem == null):
		StarMapData.FindNearestSystem(Vector2(ShipData.Ship().X,ShipData.Ship().Y))
	var system = StarMapData.NearestSystem
	text = system.Name


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
