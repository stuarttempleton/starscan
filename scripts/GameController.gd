extends Node2D


export var pause_menu_path = ""
var is_paused = false
var is_gameloop = false
var pause_menu_scene
var pause_menu_instance
signal paused(pause_state)
signal gameloop_state(loopstate)


func _ready():
	pause_menu_scene = load(pause_menu_path)
	
func Pause():
	pause_menu_instance = pause_menu_scene.instance()
	add_child(pause_menu_instance)
	is_paused = true
	emit_signal("paused",is_paused)
	
func Unpause():
	pause_menu_instance.queue_free()
	is_paused = false
	emit_signal("paused",is_paused)

func EnterGameLoop(is_loop):
	is_gameloop = is_loop
	emit_signal("gameloop_state",is_gameloop)
	
func _input(event):
	if is_gameloop:
		if Input.is_action_just_released("ui_cancel"):
			if is_paused:
				Unpause()
			else:
				Pause()
