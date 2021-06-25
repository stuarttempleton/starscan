extends Node2D


export var pause_menu_path = ""
var is_gameloop = false
var is_movement_enabled = true
var pause_menu_scene
var pause_menu_instance
var is_usingmap = false

signal gameloop_state(loopstate)
signal map_state(mapstate)


func _ready():
	pause_menu_scene = load(pause_menu_path)
	
	$CanvasLayer/TextureButton.visible = is_gameloop


func Pause():
	AudioPlayer._play_UI_Button_Select()
	pause_menu_instance = pause_menu_scene.instance()
	add_child(pause_menu_instance)
	get_tree().paused = true


func Unpause():
	AudioPlayer._play_UI_Button_Select()
	if pause_menu_instance:
		pause_menu_instance.queue_free()
	get_tree().paused = false


func EnterGameLoop(is_loop):
	is_gameloop = is_loop
	emit_signal("gameloop_state",is_gameloop)
	$CanvasLayer/TextureButton.visible = is_gameloop
	$WinLoseCheck.isInGame = is_gameloop
	is_usingmap = false

func isGameOver():
	return $WinLoseCheck.handlingGameOver

func EnableMovement(toggle_movement):
	is_movement_enabled = toggle_movement

func togglePause():
	if get_tree().paused:
		Unpause()
	else:
		Pause()

func _input(_event):
	if is_gameloop:
		if Input.is_action_just_released("ui_cancel"):
			togglePause()
		if Input.is_action_just_released("starmap_mapview"):
			MapToggle()

func MapToggle():
	is_usingmap = !is_usingmap
	emit_signal("map_state", is_usingmap)

func _on_TextureButton_pressed():
	togglePause()


func _on_TextureButton_mouse_entered():
	EnableMovement(false)


func _on_TextureButton_mouse_exited():
	EnableMovement(true)
