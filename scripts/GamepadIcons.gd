extends Node2D

enum GamepadButtonTypes {ui_accept, ui_cancel, ui_select, dpad_all, dpad_any, dpad_up_down, dpad_left_right, dpad_up, dpad_down, dpad_left, dpad_right}

var GamepadIconSet = {
	"Keyboard":
		{
			"ui_accept":"res://sprites/GamepadGlyphs/Xbox/A.png",
			"ui_cancel":"res://sprites/GamepadGlyphs/Xbox/B.png",
			"ui_select":"res://sprites/GamepadGlyphs/Xbox/Y.png",
			"dpad_all":"res://sprites/GamepadGlyphs/dpad/all.png",
			"dpad_any":"res://sprites/GamepadGlyphs/dpad/any.png",
			"dpad_up_down":"res://sprites/GamepadGlyphs/dpad/up-down.png",
			"dpad_left_right":"res://sprites/GamepadGlyphs/dpad/left-right.png",
			"dpad_up":"res://sprites/GamepadGlyphs/dpad/up.png",
			"dpad_down":"res://sprites/GamepadGlyphs/dpad/down.png",
			"dpad_left":"res://sprites/GamepadGlyphs/dpad/left.png",
			"dpad_right":"res://sprites/GamepadGlyphs/dpad/right.png"
		},
	"XInput Gamepad":
		{
			"ui_accept":"res://sprites/GamepadGlyphs/Xbox/A.png",
			"ui_cancel":"res://sprites/GamepadGlyphs/Xbox/B.png",
			"ui_select":"res://sprites/GamepadGlyphs/Xbox/Y.png",
			"dpad_all":"res://sprites/GamepadGlyphs/dpad/all.png",
			"dpad_any":"res://sprites/GamepadGlyphs/dpad/any.png",
			"dpad_up_down":"res://sprites/GamepadGlyphs/dpad/up-down.png",
			"dpad_left_right":"res://sprites/GamepadGlyphs/dpad/left-right.png",
			"dpad_up":"res://sprites/GamepadGlyphs/dpad/up.png",
			"dpad_down":"res://sprites/GamepadGlyphs/dpad/down.png",
			"dpad_left":"res://sprites/GamepadGlyphs/dpad/left.png",
			"dpad_right":"res://sprites/GamepadGlyphs/dpad/right.png"
		},
	"Steam Virtual Gamepad":
		{
			"ui_accept":"res://sprites/GamepadGlyphs/Steam/A.png",
			"ui_cancel":"res://sprites/GamepadGlyphs/Steam/B.png",
			"ui_select":"res://sprites/GamepadGlyphs/Steam/Y.png",
			"dpad_all":"res://sprites/GamepadGlyphs/dpad/all.png",
			"dpad_any":"res://sprites/GamepadGlyphs/dpad/any.png",
			"dpad_up_down":"res://sprites/GamepadGlyphs/dpad/up_down.png",
			"dpad_left_right":"res://sprites/GamepadGlyphs/dpad/left_right.png",
			"dpad_up":"res://sprites/GamepadGlyphs/dpad/up.png",
			"dpad_down":"res://sprites/GamepadGlyphs/dpad/down.png",
			"dpad_left":"res://sprites/GamepadGlyphs/dpad/left.png",
			"dpad_right":"res://sprites/GamepadGlyphs/dpad/right.png"
		}
}
var CurrentIconSet = "Mouse/Touch"


func _ready():
	var _connection = Input.connect("joy_connection_changed",self,"UpdateIcon")
	UpdateIcon()

func UpdateIcon(device = 0, _connected = false):
	if Input.get_connected_joypads().size() > 0:
		CurrentIconSet = validate_gamepad_name(Input.get_joy_name(device))
	else:
		CurrentIconSet = "Mouse/Touch"

func validate_gamepad_name(gamepad_name):
	if GamepadIconSet.keys().has(gamepad_name):
		return gamepad_name
	else:
		return "XInput Gamepad" #default to xbox basic

func get_icon(icon):
	if CurrentIconSet == "Mouse/Touch":
		return null
	else:
		return load(GamepadIconSet[CurrentIconSet][GamepadButtonTypes.keys()[icon]])

func _exit_tree():
	Input.disconnect("joy_connection_changed",self,"UpdateIcon")

