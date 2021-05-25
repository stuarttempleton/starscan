extends Button

export(String) var StarMapViewport_scene

func _on_button_down():
	AudioPlayer._play_UI_Button_Select()
	SceneChanger.LoadScene(StarMapViewport_scene)
