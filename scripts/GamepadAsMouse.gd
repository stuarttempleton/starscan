extends Node2D


export var MAX_MOUSE_SPEED = 25
var hw_tick = 0
var IsUsingMouse = true
signal mouse_emulation_change(useMouse)

var scenes_for_ui_accept = [
	"res://scenes/SystemViewport.tscn",
	"res://planet_maps/PlanetSurfaceMap.tscn"
]
var enable_full_input = false

func _ready():
	SceneChanger.connect("scene_changed",self,"scene_changed")

func scene_changed(scene_path = ""):
	enable_full_input = scenes_for_ui_accept.has(scene_path)

func _process(_delta):
	var _target = Input.get_vector("move_mouse_left","move_mouse_right","move_mouse_up","move_mouse_down")
	if _target != Vector2.ZERO:
		MoveTo(get_viewport().get_mouse_position() + Vector2(-MAX_MOUSE_SPEED * -_target.x,-MAX_MOUSE_SPEED * -_target.y))
	
	if Input.is_action_just_pressed("joystick_mouse_button"):
		SendButtonPress(true)
	elif Input.is_action_just_released("joystick_mouse_button"):
		SendButtonPress(false)
	
	#we want to listen for ui_accept, but only when we're not displaying a menu
	if enable_full_input:
		if Input.is_action_just_pressed("ui_accept"):
			if !GamepadMenu.menu_is_active():
				SendButtonPress(true)
		elif Input.is_action_just_released("ui_accept"):
			if !GamepadMenu.menu_is_active():
				SendButtonPress(false)

func MoveTo(target):
	hw_tick = 1
	get_viewport().warp_mouse(target)

func SendButtonPress(pressed = true):
	var ev = InputEventMouseButton.new()
	ev.pressed = pressed
	ev.button_index = BUTTON_LEFT  
	ev.position =  get_viewport().get_mouse_position()
	get_tree().input_event(ev)

func _input(event):
	if event is InputEventMouseMotion:
		if hw_tick == 1:
			if IsUsingMouse:
				emit_signal("mouse_emulation_change",false)
			IsUsingMouse = false
			hw_tick = 0
		else:
			#we are using mouse
			if !IsUsingMouse:
				emit_signal("mouse_emulation_change",true)
			IsUsingMouse = true
			hw_tick = 0
