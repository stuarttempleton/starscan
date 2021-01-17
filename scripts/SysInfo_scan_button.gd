extends Button

export(String) var minigame_scene
export var additive_load_scene = true #additive or replacement

signal minigameComplete

var minigame

func _ready():
	connect("mouse_entered",self,"mouse_enter")
	connect("mouse_exited",self,"mouse_exit")
	connect("pressed", self, "on_button_pressed")

func on_button_pressed () :
	print("Load: %s" % [minigame_scene])
	var loaded_scene = load(minigame_scene)
	minigame = loaded_scene.instance()
	add_child(minigame)
	minigame.get_node("Scanner Minigame").connect("success", self, "scanPerformed")
	minigame.get_node("Scanner Minigame").connect("fail", self, "scanPerformed")
	minigame.get_node("Scanner Minigame").connect("complete", self, "hideMinigame")

func mouse_enter():
	GameController.EnableDisableMovement(false)
	
func mouse_exit():
	GameController.EnableDisableMovement(true)

func scanPerformed():
	#print("Scan game ended")
	emit_signal("minigameComplete")

func hideMinigame():
	minigame.queue_free()
