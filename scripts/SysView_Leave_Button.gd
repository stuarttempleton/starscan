class_name Sysinfo_Leave_button
extends "res://scripts/GamepadButton.gd"

export(String) var StarMapViewport_scene


func _process(_delta):
	if !disabled:
		if Input.is_action_just_pressed("ui_cancel"):
			if !GamepadMenu.menu_is_active():
				_on_button_down()

func _on_button_down():
	AudioPlayer._play_UI_Button_Select()
	SceneChanger.LoadScene(StarMapViewport_scene, 0.5)
