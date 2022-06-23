extends Button

export(String) var minigame_scene
export var additive_load_scene = true #additive or replacement

signal minigameComplete

var minigame
var hoverflag = true #flag controls the stray mouse event for exit when you load a scene as an overlay


func _on_ScanButton_pressed() :
	AudioPlayer._play_UI_Button_Select()
	hoverflag = false
	disabled = true
	var loaded_scene = load(minigame_scene)
	minigame = loaded_scene.instance()
	add_child(minigame)
	minigame.get_node("CanvasLayer/SceneBackground/Scanner Minigame").connect("complete", self, "scanPerformed")

func scanPerformed():
	emit_signal("minigameComplete")

func hideMinigame():
	minigame.queue_free()
