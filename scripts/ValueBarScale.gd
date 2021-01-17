extends ColorRect

var lastpeek
export(String) var ship_value_key
export(String) var ship_capacity_key

func _ready():
	print("%s %f, %s %f" % [ship_value_key, ShipData.StarShip[ship_value_key], ship_capacity_key, ShipData.StarShip[ship_capacity_key]])
	SetPercent(1.0)

func SetPercent(fraction) :
	lastpeek = fraction * ShipData.StarShip[ship_capacity_key]
	rect_scale = Vector2(fraction, 1)

func _process(_delta):
	if (ShipData.StarShip[ship_value_key] != lastpeek) :
		SetPercent(ShipData.StarShip[ship_value_key] / ShipData.StarShip[ship_capacity_key])
	pass
