extends Button

export var scene_to_load = ""
export var additive_load_scene = true #additive or replacement

func _ready():
	connect("mouse_entered",self,"mouse_enter")
	connect("mouse_exited",self,"mouse_exit")
	connect("pressed", self, "on_button_pressed")

func on_button_pressed () :
	print("Load: %s" % [scene_to_load])
	if additive_load_scene:
		var loaded_scene = load(scene_to_load)
		add_child(loaded_scene.instance())
	else:
		get_tree().change_scene(scene_to_load)

func mouse_enter():
	GameController.EnableDisableMovement(false)
	
func mouse_exit():
	GameController.EnableDisableMovement(true)
