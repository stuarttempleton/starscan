class_name GamepadButton
extends Button


export(GamepadIcons.GamepadButtonTypes) var GamepadButton = GamepadIcons.GamepadButtonTypes.ui_accept


func _ready():
	var _connection = Input.connect("joy_connection_changed",self,"UpdateIcon")
	UpdateIcon()

func UpdateIcon(_device = 0, _connected = false):
	if Input.get_connected_joypads().size() > 0:
		align = ALIGN_LEFT
	else:
		align = ALIGN_CENTER
	set_button_icon(GamepadIcons.get_icon(GamepadButton))

func _exit_tree():
	Input.disconnect("joy_connection_changed",self,"UpdateIcon")

