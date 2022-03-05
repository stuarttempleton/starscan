extends Control


export var boiler_plate = "Towing to %s."
var ship
var shipAvatar


func _ready():
	shipAvatar = get_tree().get_root().find_node("ShipAvatar", true, false)
	shipAvatar.connect("TowingAlert", self, "TowingUpdates")
	ship = ShipData.Ship()
	$TowNotification.hide()


func TowingUpdates(istowing):
	if istowing:
		var nearestOutpostSystem = StarMapData.GetNearestOutpostSystem(Vector2(ship.X,ship.Y))
		TowingTo(nearestOutpostSystem.Name)
		$TowNotification.show()
	else:
		$TowNotification.hide()


func TowingTo(txt):
	$TowNotification/TowDetails.text = boiler_plate % [txt]
