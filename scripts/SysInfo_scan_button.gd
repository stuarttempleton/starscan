class_name Sysinfo_scan_button
extends "res://scripts/GamepadButton.gd"

@export var minigame_scene: String
@export var additive_load_scene = true #additive or replacement

signal minigameComplete

var minigame
var hoverflag = true #flag controls the stray mouse event for exit when you load a scene as an overlay

func _process(_delta):
	if !disabled:
		if Input.is_action_just_pressed("ui_select"):
			if get_parent().get_parent().visible:
				if !GamepadMenu.menu_is_active():
					if GameController.is_movement_enabled():
						_on_ScanButton_pressed()

func _on_ScanButton_pressed() :
	AudioPlayer._play_UI_Button_Select()
	hoverflag = false
	disabled = true
	var loaded_scene = load(minigame_scene)
	minigame = loaded_scene.instantiate()
	add_child(minigame)
	minigame.get_node("CanvasLayer/SceneBackground/Scanner Minigame").connect("complete",Callable(self,"scanPerformed"))

func scanPerformed():
	emit_signal("minigameComplete")

func hideMinigame():
	minigame.queue_free()
