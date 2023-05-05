extends HBoxContainer


func _ready():
	var _connection = Input.connect("joy_connection_changed",Callable(self,"_joypad_changed"))
	_joypad_changed()

func _joypad_changed(_device = 0, _connected = false):
	$dpad_icon.visible = (Input.get_connected_joypads().size() > 0)
	$Label.visible = (Input.get_connected_joypads().size() > 0)
	$ui_accept_icon.visible = (Input.get_connected_joypads().size() > 0)
	$Label2.visible = (Input.get_connected_joypads().size() > 0)

func dpad_visible(show = true):
	$dpad_icon.visible = show && (Input.get_connected_joypads().size() > 0)
	$Label.visible = show && (Input.get_connected_joypads().size() > 0)

func _exit_tree():
	Input.disconnect("joy_connection_changed",Callable(self,"_joypad_changed"))
