extends Node2D


export var pause_menu_path = ""
var is_gameloop = false
var pause_menu_scene
var pause_menu_instance

# toggles for displaying overlay scenes
var is_usingmap = false
var is_usinginventory = false
var is_usingoptions = false

var scene_has_map = false
var scene_has_cargo = false
var movement_block_queue = 0

signal gameloop_state(loopstate)
signal map_state(mapstate)
signal pause_state(pausestate)
signal inventory_state(inventorystate)
signal options_state(optionsstate)


func _init():
	for arg in OS.get_cmdline_args():
		print("Arg: ", arg)
		var param = arg.split("=")
		match param[0]:
			"--windowed", "-w":
				match param[1]:
					"1","true","yes":
						PlayerPrefs.set_pref("window_fullscreen", false)
						PlayerPrefs.set_pref("window_size", {"x":1280,"y":720})
					"0","false","no":
						PlayerPrefs.set_pref("window_fullscreen", true)
	LoadWindowSettings()


func LoadWindowSettings():
	OS.window_fullscreen = PlayerPrefs.get_pref("window_fullscreen", true)
	if !OS.window_fullscreen:
		OS.window_size = Vector2(PlayerPrefs.get_pref("window_size", 1280).x,PlayerPrefs.get_pref("window_size", 720).y)


func SetViewScale():
	if OS.window_fullscreen:
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_DISABLED,  SceneTree.STRETCH_ASPECT_IGNORE, OS.window_size, PlayerPrefs.get_pref("view_scale", 1) )


func SaveWindowSettings():
	PlayerPrefs.set_pref("window_fullscreen", OS.window_fullscreen)


func _ready():
	pause_menu_scene = load(pause_menu_path)
	
	$CanvasLayer/TextureButton.visible = is_gameloop
	$CanvasLayer/MapButton.visible = is_gameloop && scene_has_map
	$CanvasLayer/CargoButton.visible = is_gameloop && scene_has_cargo
	SetViewScale() #hack because tree node is not ready during init
	SetUIDeadzones()
	
func SetUIDeadzones():
	for obj in $CanvasLayer.get_children():
		MovementEvent.add_deadzone(obj.name, obj.get_global_rect())


func Pause():
	AudioPlayer._play_UI_Button_Select()
	pause_menu_instance = pause_menu_scene.instance()
	add_child(pause_menu_instance)
	emit_signal("pause_state", true)
	EnableMovement(false)
	get_tree().paused = true
	$CanvasLayer/MapButton.visible = false
	$CanvasLayer/CargoButton.visible = false


func Unpause():
	AudioPlayer._play_UI_Button_Select()
	if pause_menu_instance:
		pause_menu_instance.queue_free()
	get_tree().paused = false
	EnableMovement(true)
	emit_signal("pause_state", false)
	$CanvasLayer/MapButton.visible = is_gameloop && scene_has_map
	$CanvasLayer/CargoButton.visible = is_gameloop && scene_has_cargo


func EnterGameLoop(is_loop):
	is_gameloop = is_loop
	emit_signal("gameloop_state",is_gameloop)
	$CanvasLayer/TextureButton.visible = is_gameloop
	$CanvasLayer/MapButton.visible = is_gameloop && scene_has_map
	$CanvasLayer/CargoButton.visible = is_gameloop && scene_has_cargo
	$WinLoseCheck.isInGame = is_gameloop
	is_usingmap = false

func isGameOver():
	return $WinLoseCheck.handlingGameOver

func EnableMovement(enable):
	if enable:
		movement_block_queue -= 1
	else:
		movement_block_queue += 1
	
	if movement_block_queue <= 0:
		movement_block_queue = 0


func ResetMoveBlock():
	movement_block_queue = 0

func is_movement_enabled():
	return movement_block_queue == 0

func EnableMap():
	scene_has_map = true
	$CanvasLayer/MapButton.visible = is_gameloop && scene_has_map

func DisableMap():
	scene_has_map = false
	$CanvasLayer/MapButton.visible = is_gameloop && scene_has_map

func EnableCargo():
	scene_has_cargo = true
	$CanvasLayer/CargoButton.visible = is_gameloop && scene_has_cargo

func DisableCargo():
	scene_has_cargo = false
	$CanvasLayer/CargoButton.visible = is_gameloop && scene_has_cargo


func togglePause():
	if get_tree().paused:
		Unpause()
	else:
		Pause()


func _process(_delta):
	if is_gameloop:
		if Input.is_action_just_released("pause_menu"):
			togglePause()
		if Input.is_action_just_released("starmap_mapview"):
			MapToggle()
		if Input.is_action_just_released("Inventory"):
			InventoryToggle()
		if Input.is_action_just_released("Options"):
			OptionsToggle()
	if Input.is_action_just_pressed("fullscreen_mode"):
		FullscreenToggle()
	if Input.is_key_pressed(KEY_Q):
		print("Mouse coords: %d,%d" %[get_viewport().get_mouse_position().x, get_viewport().get_mouse_position().y])
		

func OptionsToggle():
	AudioPlayer._play_UI_Button_Select()
	is_usingoptions = !is_usingoptions
	EnableMovement(!is_usingoptions)
	emit_signal("options_state",is_usingoptions)
	
	
func InventoryToggle():
	if scene_has_cargo and !get_tree().paused:
		AudioPlayer._play_UI_Button_Select()
		is_usinginventory = !is_usinginventory
		EnableMovement(!is_usinginventory)
		emit_signal("inventory_state", is_usinginventory)
		
		
func MapToggle():
	if scene_has_map and !get_tree().paused:
		AudioPlayer._play_UI_Button_Select()
		is_usingmap = !is_usingmap
		EnableMovement(!is_usingmap)
		emit_signal("map_state", is_usingmap)

func FullscreenToggle():
	PlayerPrefs.set_pref("window_fullscreen", !OS.window_fullscreen)
	LoadWindowSettings()
	SaveWindowSettings()
	SetViewScale()
	SetUIDeadzones()


func _on_TextureButton_pressed():
	togglePause()

func _on_TextureButton_mouse_entered():
	EnableMovement(false)

func _on_TextureButton_mouse_exited():
	EnableMovement(true)

func _on_MapButton_mouse_entered():
	EnableMovement(false)

func _on_MapButton_mouse_exited():
	EnableMovement(true)

func _on_MapButton_pressed():
	MapToggle()

func _on_CargoButton_pressed():
	InventoryToggle()
