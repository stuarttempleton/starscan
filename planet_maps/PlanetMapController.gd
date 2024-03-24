extends Node


export var PlanetDetailBoilerPlate = "Type: %s\r\nSize: %s\r\nOrbital Debris: %s"
var args
export var scene = "res://scenes/SystemViewport.tscn"

func _ready():
	args = SceneChanger.SceneVars[get_tree().current_scene.filename]
	_generate_planet_map(args["planet"], args["scan"])
	# warning-ignore:return_value_discarded
	get_tree().root.connect("size_changed", self, "_on_viewport_size_changed")
	GameController.EnableCargo()


func _on_viewport_size_changed():
	_generate_poi(args["planet"], args["scan"])


func _generate_poi(planet, scan):
	if planet.Type == "Outpost":
		$PointsOfInterest.ClearPOINodes()
	elif planet.Type == "Anomaly":
		$PointsOfInterest.ClearPOINodes()
	else:
		$PointsOfInterest._generate(planet, scan)
		GamepadMenu.remove_menu($PointsOfInterest.name)
		GamepadMenu.add_menu($PointsOfInterest.name, $PointsOfInterest._get_visible_children())


func _show_dialog(planet):
	if planet.Type == "Outpost":
		$OutpostDialog.DialogBegin(planet)
		$LeaveOrbit.visible = false
	elif planet.Type == "Anomaly":
		$AnomalyDialog.DialogBegin(planet)
	else:
		$PlanetDialog.DialogBegin(planet)


func _generate_planet_map(planet, _scan):
	$PlanetSurfaceMap/PlanetMap.visible = true
	$PlanetSurfaceMap/PlanetName.text = planet.Name
	$PlanetSurfaceMap/PlanetInformation.text = PlanetDetailBoilerPlate % [planet.Type, planet.Size, "Major" if planet.Ring else "Minor"]
	$PlanetSurfaceMap/PlanetMap._generate(planet)
	_generate_poi(args["planet"], args["scan"])
	_show_dialog(args["planet"])

func _on_generate_button_pressed(planet_type):
	$PlanetSurfaceMap/PlanetMap._generate(StarMapData.GetRandomPlanetByType(planet_type))

func _process(_delta):
	if !$LeaveOrbit.disabled:
		if Input.is_action_just_pressed("leave_system_orbit"):
			if !GamepadMenu.menu_is_active():
				_on_LeaveOrbit()

func _on_LeaveOrbit(play_sfx = true):
	if play_sfx:
		AudioPlayer._play_UI_Button_Select()
	GamepadMenu.remove_menu($PointsOfInterest.name)
	SceneChanger.LoadScene(scene, 0.0, {"do_entry": false})
