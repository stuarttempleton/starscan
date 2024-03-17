extends Node2D


var allow_planet_click = false # this is a toggle for what you're viewing.
var allow_poi_click = true #
export var PlanetSurfaceMap_scene = "res://planet_maps/PlanetSurfaceMap.tscn"
var args

func _ready():
	args = SceneChanger.SceneVars[get_tree().current_scene.filename]
	if args["do_entry"]:
		AudioPlayer.PlayBG(AudioPlayer.AUDIO_KEY.BG_SPACE)
		AudioPlayer.PlayMusic(AudioPlayer.AUDIO_KEY.MUSIC_SYSTEM_MAP)
		$EnterSystemEvent.StartEvent()
	GameController.EnableCargo()

func PlanetHover(planet_position, planet_name):
	$HoverUI/Label.text = planet_name
	$HoverUI.set_position(Vector2(planet_position.x - $HoverUI.get_rect().size.x/2, planet_position.y - $HoverUI.get_rect().size.x/2))
	$HoverUI.visible = true

func PlanetUnhover():
	$HoverUI.visible = false

func ViewPlanet(_planetID):
	AudioPlayer._play_UI_Button_Select()
	
	var planet = $SystemView/SolarSystem.system.Planets[_planetID]
	var scan = $SystemView/SolarSystem.system.Scan
	if !StarMapData.IsVisited(planet):
		StarMapData.SetVisited(planet)
		ShipData.UpdatePlayStat("PlanetsVisited",1)
		if StarMapData.AllPlanetsVisited($SystemView/SolarSystem.system):
			ShipData.UpdatePlayStat("SystemsCompleted",1)
	SceneChanger.LoadScene(PlanetSurfaceMap_scene, 0.5, {"planet":planet,"scan":scan})
