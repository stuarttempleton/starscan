extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var UseNebulaInstead = false
export var UseOutpostInstead = false

onready var arrow = $arrow

var MapScale = StarMapData.MapScale


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var ship = ShipData.Ship()
	var shipPos = Vector2(ship.X, ship.Y)
		
	var target
	var distance
	
	if UseNebulaInstead:
		distance = StarMapData.DistanceToNearestNebula(shipPos)
		target = StarMapData.NearestNebula
	elif UseOutpostInstead:
		target = StarMapData.GetNearestOutpostSystem(shipPos)
		distance = StarMapData.GetDistanceToSystem(shipPos, target)
	else:
		if (StarMapData.NearestSystem == null):
			StarMapData.FindNearestSystem(Vector2(ship.X,ship.Y))
		target = StarMapData.NearestSystem
		distance = StarMapData.NearestSystemDistance
		pass
	
	if distance * MapScale < 145:
		arrow.hide()
	else:
		arrow.show()
	look_at(Vector2(target.X * MapScale, target.Y * MapScale))
	
	pass
