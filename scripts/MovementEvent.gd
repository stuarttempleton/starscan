extends Node2D

export var DeadZones = {}


func is_valid(position:Vector2):
	for zone in DeadZones.values():
		if zone.has_point(position):
			return false
	return true

func add_deadzone(id, zone:Rect2):
	DeadZones[id] = zone

func remove_deadzone(id):
	DeadZones.erase(id)

func reset_deadzones():
	DeadZones.clear()
