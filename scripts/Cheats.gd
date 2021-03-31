extends Node

var godmode_enabled = false

signal cheat_godmode
signal cheat_setscan
signal cheat_resetpois

func _ready():
	Console.add_command('godmode', self, '_cheat_toggle_godmode')\
		.set_description('Toggles godmode (unlimited fuel and crew).')\
		.register()
		
	Console.add_command('setscan', self, '_cheat_setscan')\
		.set_description('Sets the current scanner efficiency level (clamped to 0.0-1.0) for the nearest system.')\
		.add_argument('scan', TYPE_REAL)\
		.register()
		
	Console.add_command('resetpois', self, '_cheat_resetpois')\
		.set_description('Resets perceived and exhausted status for all pois on all planets in the nearest system.')\
		.register()

func _cheat_toggle_godmode():
	godmode_enabled = !godmode_enabled
	Console.write_line('godmode %s' % ('enabled' if godmode_enabled else 'disabled'))
	if godmode_enabled:
		ShipData.StarShip.Crew = ShipData.StarShip.CrewCapacity
		ShipData.StarShip.Fuel = ShipData.StarShip.FuelCapacity
	emit_signal('cheat_godmode')
	
func _cheat_setscan(newScan):
	clamp(newScan, 0.0, 1.0)
	Console.write_line('Setting scan level for nearest system, %s, to %f (currently %f)' % [StarMapData.NearestSystem.Name, newScan, StarMapData.NearestSystem.Scan])
	StarMapData.ScanNearestSystem(newScan)
	emit_signal('cheat_setscan')

func _cheat_resetpois():
	Console.write_line('Resetting POIs for nearest system, %s' % StarMapData.NearestSystem.Name)
	for planet in StarMapData.NearestSystem.Planets:
		planet.erase('POIs')
		planet.ArtifactCount = planet.OriginalArtifactCount
		planet.ResourceCount = planet.OriginalResourceCount
		planet.HazardCount = planet.OriginalHazardCount
	emit_signal('cheat_resetpois')
