extends ColorRect

var lastpeek = 100
export var ship_value_key = "Fuel"
func _ready():
	print("%s %f" % [ship_value_key, ShipData.Ship()[ship_value_key]])
	SetPercent(0.5)

func SetPercent(percent) :
	lastpeek = percent * 100
	rect_scale = Vector2(percent, 1)

func _physics_process(_delta):
	if (ShipData.Ship()[ship_value_key] != lastpeek) :
		SetPercent(ShipData.Ship()[ship_value_key] / 100)
	pass
