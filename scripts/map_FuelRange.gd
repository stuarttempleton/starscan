extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var FuelRangeBoiler = "Fuel Range: %.1f sector units"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	text = FuelRangeBoiler % [ShipData.StarShip.Fuel / ShipData.StarShip.FuelPerUnitDistance]
