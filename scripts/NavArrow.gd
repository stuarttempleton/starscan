extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var UseNebulaInstead = false
onready var arrow = $arrow

var MapScale = StarMapData.MapScale


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var ship = ShipData.Ship()
	var target
	var distance
	
	if UseNebulaInstead:
		distance = StarMapData.DistanceToNearestNebula(Vector2(ship.X, ship.Y))
		target = StarMapData.NearestNebula
	else:
		if (StarMapData.NearestSystem == null):
			StarMapData.FindNearestSystem(Vector2(ship.X,ship.Y))
		target = StarMapData.NearestSystem
		distance = StarMapData.NearestSystemDistance
	
	if distance * MapScale < 145:
		arrow.hide()
	else:
		arrow.show()
	look_at(Vector2(target.X * MapScale, target.Y * MapScale))
	
	pass
