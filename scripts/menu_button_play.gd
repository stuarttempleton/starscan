extends Button


export var scene_to_load = ""

func _ready():
	if !get_node("../../../..").in_game:
		grab_focus()
	connect("pressed", self, "on_button_pressed")

func on_button_pressed () :
	if (scene_to_load != "") :
		StarMapData.LoadSave()
		ShipData.LoadSave()
		get_tree().change_scene(scene_to_load)
	else :
		print("THIS MENU BUTTON HAS NO SCENE TO LOAD")

