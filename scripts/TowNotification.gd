extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var boiler_plate = "Towing to %s."

var ship
var shipAvatar
# Called when the node enters the scene tree for the first time.
func _ready():
	shipAvatar = get_tree().get_root().find_node("ShipAvatar", true, false)
	shipAvatar.connect("TowingAlert", self, "TowingUpdates")
	ship = ShipData.Ship()
	$TowNotification.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func TowingUpdates(istowing):
	if istowing:
		var nearestOutpostSystem = StarMapData.GetNearestOutpostSystem(Vector2(ship.X,ship.Y))
		TowingTo(nearestOutpostSystem.Name)
		$TowNotification.show()
	else:
		$TowNotification.hide()


func TowingTo(txt):
	$TowNotification/TowDetails.text = boiler_plate % [txt]
