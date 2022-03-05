extends Label

export var FuelRangeBoiler = "Fuel Range: %.1f sector units"


func _process(_delta):
	text = FuelRangeBoiler % [ShipData.StarShip.Fuel / ShipData.StarShip.FuelPerUnitDistance]
