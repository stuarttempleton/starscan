class_name Sysinfo_enter_button
extends "res://scripts/GamepadButton.gd"

export(String) var SystemViewport_scene
var hoverflag = false


func _process(_delta):
	if !disabled:
		if Input.is_action_just_pressed("ui_accept"):
			if get_parent().get_parent().visible:
				if !GamepadMenu.menu_is_active():
					if GameController.is_movement_enabled():
						_on_EnterButton_pressed()


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
