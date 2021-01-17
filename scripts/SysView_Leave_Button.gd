extends Button

export(String) var StarMapViewport_scene

func _on_button_down():
	get_tree().change_scene(StarMapViewport_scene)
