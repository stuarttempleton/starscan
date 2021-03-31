extends Node

var godmode_enabled = false

signal godmode_changed

func _ready():
	Console.add_command('godmode', self, '_cheat_toggle_godmode')\
		.set_description('Toggles godmode (unlimited fuel and crew)')\
		.register()
		
	Console.add_command('setscan', self, '_cheat_setscan')\
		.set_description('While visiting a system, sets the current scanner efficiency level (0.0-1.0).')\
		.add_argument('scan', TYPE_REAL)\
		.register()

func _cheat_toggle_godmode():
	godmode_enabled = !godmode_enabled
	Console.write_line('godmode %s' % ('enabled' if godmode_enabled else 'disabled'))
	if godmode_enabled:
		ShipData.StarShip.Crew = ShipData.StarShip.CrewCapacity
		ShipData.StarShip.Fuel = ShipData.StarShip.FuelCapacity
	emit_signal('godmode_changed')
	
func _cheat_setscan(newScan):
	clamp(newScan, 0.0, 1.0)
	Console.write_line('Setting scan level for nearest system, %s, to %f (currently %f)' % [StarMapData.NearestSystem.Name, newScan, StarMapData.NearestSystem.Scan])
	StarMapData.ScanNearestSystem(newScan)
