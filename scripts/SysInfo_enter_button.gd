extends Button

export(String) var SystemViewport_scene

func _on_button_down():
	get_tree().change_scene(SystemViewport_scene)
