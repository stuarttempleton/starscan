extends Node

var godmode_enabled = false

signal cheat_godmode
signal cheat_setscan
signal cheat_resetpois
signal cheat_die

func _ready():
	Console.add_command('godmode', self, '_cheat_toggle_godmode')\
		super.set_description('Toggles godmode (unlimited fuel and crew).')\
		super.register()
		
	Console.add_command('setscan', self, '_cheat_setscan')\
		super.set_description('Sets the current scanner efficiency level (limit_length to 0.0-1.0) for the nearest system.')\
		super.add_argument('scan', TYPE_FLOAT)\
		super.register()
		
	Console.add_command('resetpois', self, '_cheat_resetpois')\
		super.set_description('Resets perceived and exhausted status for all pois on all planets in the nearest system.')\
		super.register()
		
	Console.add_command('die', self, '_cheat_die')\
		super.set_description('Kills all of your crew and ends the game.')\
		super.register()

func _cheat_die():
	Console.write_line("Killing crew. You monster.")
	ShipData.DeductCrew(ShipData.StarShip.Crew)
	emit_signal("cheat_die")
	
func _cheat_toggle_godmode():
	godmode_enabled = !godmode_enabled
	Console.write_line('godmode %s' % ('enabled' if godmode_enabled else 'disabled'))
	if godmode_enabled:
		ShipData.StarShip.Crew = ShipData.StarShip.CrewCapacity
		ShipData.StarShip.Fuel = ShipData.StarShip.FuelCapacity
	emit_signal('cheat_godmode')
	
func _cheat_setscan(newScan):
	newScan = clamp(newScan, 0.0, 1.0)
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
