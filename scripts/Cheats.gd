extends Node

var godmode_enabled = false

signal godmode_changed

func _ready():
	Console.add_command('godmode', self, 'toggle_godmode')\
		.set_description('Toggles godmode (unlimited fuel and crew)')\
		.register()

func toggle_godmode():
	godmode_enabled = !godmode_enabled
	Console.write_line('godmode ' + ('enabled' if godmode_enabled else 'disabled'))
	if godmode_enabled:
		ShipData.StarShip.Crew = ShipData.StarShip.CrewCapacity
		ShipData.StarShip.Fuel = ShipData.StarShip.FuelCapacity
	emit_signal('godmode_changed')
