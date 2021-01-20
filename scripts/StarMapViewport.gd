extends Node2D

func _ready():
	ShipData.connect("FuelTanksEmpty", self, "_on_FuelTanksEmpty")
	
func _on_FuelTanksEmpty():
	var shipPos = Vector2(ShipData.Ship().X,ShipData.Ship().Y)
	var nearestOutpostSystem = StarMapData.GetNearestOutpostSystem(shipPos)
	var outpostSystemPos = Vector2(nearestOutpostSystem.X, nearestOutpostSystem.Y) * StarMapData.MapScale
	print("Setting position directly to " + str(outpostSystemPos))
	$ShipAvatarView/ShipAvatar.JumpToMapPosition(outpostSystemPos)
	ShipData.Refuel()
