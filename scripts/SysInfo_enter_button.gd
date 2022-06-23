extends Button

export(String) var SystemViewport_scene
var hoverflag = false


func _on_button_down():
	AudioPlayer._play_UI_Button_Select()
	var Nearby = StarMapData.GetNearestBody()
	if Nearby.has("Destination"):
		var Destination = StarMapData.GetBodyByName(Nearby.Destination, "Nebulae")
		var Wormhole = get_tree().get_root().find_node("WormholeAction", true, false)
		Wormhole.EnterWormholeTo(StarMapData.SystemPosition(Destination, true))
	else:
		hoverflag = false
		SceneChanger.LoadScene(SystemViewport_scene, 0.5, {"do_entry": true})


func _on_EnterButton_pressed():
	AudioPlayer._play_UI_Button_Select()
	var Nearby = StarMapData.GetNearestBody()
	if Nearby.has("Destination"):
		var Destination = StarMapData.GetBodyByName(Nearby.Destination, "Nebulae")
		var Wormhole = get_tree().get_root().find_node("WormholeAction", true, false)
		Wormhole.EnterWormholeTo(StarMapData.SystemPosition(Destination, true))
	else:
		hoverflag = false
		SceneChanger.LoadScene(SystemViewport_scene, 0.5, {"do_entry": true})
