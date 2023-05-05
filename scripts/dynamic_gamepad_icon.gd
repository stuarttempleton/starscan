extends TextureRect


@export var GamepadButton = GamepadIcons.GamepadButtonTypes.ui_accept # (GamepadIcons.GamepadButtonTypes)


func _ready():
	var _connection = Input.connect("joy_connection_changed",Callable(self,"UpdateIcon"))
	UpdateIcon()

func UpdateIcon(_device = 0, _connected = false):
	texture = GamepadIcons.get_icon(GamepadButton)

func _exit_tree():
	Input.disconnect("joy_connection_changed",Callable(self,"UpdateIcon"))
