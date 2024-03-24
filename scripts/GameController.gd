extends Node2D


export var pause_menu_path = ""
var is_gameloop = false
var pause_menu_scene
var pause_menu_instance
var is_usingmap = false
var is_usinginventory = false
var scene_has_map = false
var scene_has_cargo = false
var movement_block_queue = 0

signal gameloop_state(loopstate)
signal map_state(mapstate)
signal pause_state(pausestate)
signal inventory_state(inventorystate)


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
		#OS.set_window_position(OS.get_screen_position(OS.get_current_screen()) + OS.get_screen_size()*0.5 - OS.get_window_size()*0.5)
	print("Screen DPI: %d" % [OS.get_screen_dpi()])

func SaveWindowSettings():
	PlayerPrefs.set_pref("window_fullscreen", OS.window_fullscreen)
	#if !OS.window_fullscreen:
	#	PlayerPrefs.set_pref("window_size", {"x":OS.window_size.x,"y":OS.window_size.y})

func GetScaleByDPI(dpi = 96):
	if dpi > 640:
		return 2.75
	if dpi > 560:
		return 2.5
	if dpi > 480:
		return 2.25
	if dpi > 400:
		return 2
	if dpi > 320:
		return 1.50
	if dpi > 240:
		return 1.25
	if dpi > 160:
		return 1
	if dpi > 80:
		return 1
	return 0.5
	
func _ready():
	pause_menu_scene = load(pause_menu_path)
	
	$CanvasLayer/TextureButton.visible = is_gameloop
	$CanvasLayer/MapButton.visible = is_gameloop && scene_has_map
	$CanvasLayer/CargoButton.visible = is_gameloop && scene_has_cargo
	SetUIDeadzones()
	if OS.window_fullscreen:
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT,  SceneTree.STRETCH_ASPECT_EXPAND, OS.window_size, GetScaleByDPI(OS.get_screen_dpi()) )
	
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
	if Input.is_action_just_pressed("fullscreen_mode"):
		PlayerPrefs.set_pref("window_fullscreen", !OS.window_fullscreen)
		LoadWindowSettings()
#		if get_viewport_rect().has_point(get_viewport().get_mouse_position()):
#			if Input.get_connected_joypads().size() > 0:
#				get_viewport().warp_mouse(get_viewport_rect().get_center())
		SaveWindowSettings()
	if Input.is_key_pressed(KEY_Q):
		print("Mouse coords: %d,%d" %[get_viewport().get_mouse_position().x, get_viewport().get_mouse_position().y])
		

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
