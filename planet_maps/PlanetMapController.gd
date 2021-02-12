extends Node2D


export var PlanetDetailBoilerPlate = "Type: %s\r\nSize: %s\r\nOrbital Debris: %s"

func _ready():
	
	#_generate_planet_map(StarMapData.GetRandomPlanetByType("Comet"))
	pass


func _generate_planet_map(planet):
	
	$PlanetSurfaceMap/PlanetMap.visible = true
	$PlanetSurfaceMap/PlanetName.text = planet.Name
	$PlanetSurfaceMap/PlanetInformation.text = PlanetDetailBoilerPlate % [planet.Type, planet.Size, "Major" if planet.Ring else "Minor"]
	$PlanetSurfaceMap/PlanetMap._generate(planet)


func _on_generate_button_pressed(planet_type):
	$PlanetSurfaceMap/PlanetMap._generate(StarMapData.GetRandomPlanetByType(planet_type))
