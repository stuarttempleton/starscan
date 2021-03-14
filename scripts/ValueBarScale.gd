extends ColorRect

export(String) var ship_value_key
export(String) var ship_capacity_key
export(float) var warn_fraction
export(Color) var normal_color
export(Color) var warn_color

var targetScaleX = 1.0

func _ready():
	print("%s %f, %s %f" % [ship_value_key, ShipData.StarShip[ship_value_key], ship_capacity_key, ShipData.StarShip[ship_capacity_key]])
	SetPercent(1.0)

func SetPercent(fraction) :
	if (fraction > 1.0):
		print("%s fraction %f is too high, clamping to 1.0" % [ship_value_key, fraction])
		fraction = 1.0
		
	if (fraction != targetScaleX):
		#TODO: value just changed, trigger attention-grabbing effects?
		pass
	targetScaleX = fraction
	
	if (fraction <= warn_fraction):
		color = warn_color
	else:
		color = normal_color

func _process(_delta):
	var value = ShipData.StarShip[ship_value_key]
	var capacity = ShipData.StarShip[ship_capacity_key]
	SetPercent(value / capacity)
	
	var fractionDiff = rect_scale.x - targetScaleX
	if (abs(fractionDiff) > 0.001) :
		var fractionDelta = fractionDiff * 0.9
		var newX = rect_scale.x - fractionDelta
		rect_scale = Vector2(newX, 1)
