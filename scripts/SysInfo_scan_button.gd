extends Button

export(String) var minigame_scene
export var additive_load_scene = true #additive or replacement

signal minigameComplete

var minigame
var hoverflag = true #flag controls the stray mouse event for exit when you load a scene as an overlay

func _ready():
	connect("mouse_entered",self,"mouse_enter")
	connect("mouse_exited",self,"mouse_exit")
	connect("pressed", self, "on_button_pressed")

func on_button_pressed () :
	AudioPlayer._play_UI_Button_Select()
	$"../../..".YieldFocus(true)
	hoverflag = false
	disabled = true
	var loaded_scene = load(minigame_scene)
	minigame = loaded_scene.instance()
	add_child(minigame)
	minigame.get_node("CanvasLayer/SceneBackground/Scanner Minigame").connect("success", self, "scanPerformed")
	minigame.get_node("CanvasLayer/SceneBackground/Scanner Minigame").connect("fail", self, "scanPerformed")

func mouse_enter():
	hoverflag = true
	GameController.EnableMovement(false)
	
func mouse_exit():
	if hoverflag:
		GameController.EnableMovement(true)

func scanPerformed():
	emit_signal("minigameComplete")

func hideMinigame():
	minigame.queue_free()
