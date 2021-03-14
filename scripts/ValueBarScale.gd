extends ColorRect

export(String) var ship_value_key
export(String) var ship_capacity_key
export(float) var warn_fraction
export(Color) var normal_color
export(Color) var warn_color

func _ready():
	print("%s %f, %s %f" % [ship_value_key, ShipData.StarShip[ship_value_key], ship_capacity_key, ShipData.StarShip[ship_capacity_key]])
	SetPercent(1.0)

func SetPercent(fraction) :
	lastpeek = fraction * ShipData.StarShip[ship_capacity_key]
	rect_scale = Vector2(fraction, 1)
	
	if (fraction <= warn_fraction):
		color = warn_color
	else:
		color = normal_color

func _process(_delta):
	if (ShipData.StarShip[ship_value_key] != lastpeek) :
		SetPercent(ShipData.StarShip[ship_value_key] / ShipData.StarShip[ship_capacity_key])
	pass
