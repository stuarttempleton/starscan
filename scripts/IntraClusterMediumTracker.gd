extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal enter_medium()
signal exit_medium()
signal inside_medium()

var EnteredMedium = false
var time = 0
export var  MEDIUM_TICK = 1.5
var MediumCostInCrew = 1

func IsInMedium():
	var ship = ShipData.Ship()
	var MapScale = StarMapData.MapScale
	
	return ship.X > MapScale || ship.Y > MapScale || ship.X < 0 || ship.Y < 0 


func _process(delta):
	if IsInMedium():
		time += delta
		if time > MEDIUM_TICK:
			emit_signal("inside_medium")
			time = 0
			ShipData.DeductCrew(MediumCostInCrew)
			
		if !EnteredMedium:
			EnteredMedium = true #one time flag
			emit_signal("enter_medium")
			#print("entered intracluster medium!!!")
	else:
		if EnteredMedium:
			EnteredMedium = false #one time exit flag
			emit_signal("exit_medium")
			#print("exited intracluster medium!!!")
			time = 0
