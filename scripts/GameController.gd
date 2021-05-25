extends Node2D


export var pause_menu_path = ""
var is_gameloop = false
var is_movement_enabled = true
var pause_menu_scene
var pause_menu_instance
signal gameloop_state(loopstate)


func _ready():
	pause_menu_scene = load(pause_menu_path)


func Pause():
	AudioPlayer._play_UI_Button_Select()
	pause_menu_instance = pause_menu_scene.instance()
	add_child(pause_menu_instance)
	get_tree().paused = true


func Unpause():
	AudioPlayer._play_UI_Button_Select()
	pause_menu_instance.queue_free()
	get_tree().paused = false


func EnterGameLoop(is_loop):
	is_gameloop = is_loop
	emit_signal("gameloop_state",is_gameloop)


func EnableMovement(toggle_movement):
	is_movement_enabled = toggle_movement
		
func _input(_event):
	if is_gameloop:
		if Input.is_action_just_released("ui_cancel"):
			if get_tree().paused:
				Unpause()
			else:
				Pause()
