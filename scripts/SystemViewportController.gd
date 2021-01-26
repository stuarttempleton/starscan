extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var allow_planet_click = false

# Called when the node enters the scene tree for the first time.
func _ready():
	ToggleView()
	pass # Replace with function body.


func ViewPlanet(_planetID):
	if (allow_planet_click):
		ToggleView()
		$PlanetView._generate_planet_map($SystemView/SolarSystem.system.Planets[_planetID].Type)
		print("View planet %s requested." % [$SystemView/SolarSystem.system.Planets[_planetID].Name])

func ViewSystem():
	if(!allow_planet_click):
		ToggleView()

func ToggleView():
	allow_planet_click = !allow_planet_click
	#$SystemView.visible = allow_planet_click
	$PlanetView.visible = !allow_planet_click
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
