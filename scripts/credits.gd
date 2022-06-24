extends Control


func _ready():
	GamepadMenu.add_menu(name, [$Credits])

func _exit_tree():
	GamepadMenu.remove_menu(name)

