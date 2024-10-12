extends Control


export var menus = {}
var menu_cursor = {}
var current_menu = ""

func _ready():
	var _connection = Input.connect("joy_connection_changed",self,"_joypad_changed")
	if Input.get_connected_joypads().size() > 0:
		$GamepadInfo.text = "Gamepad: %s" % Input.get_joy_name(0)
	else:
		$GamepadInfo.text = "Gamepad: mouse/touch"

func _joypad_changed(_device, _connected):
	if _connected:
		$GamepadInfo.text = "Gamepad: %s" % Input.get_joy_name(_device)
		activate_top_menu()
	else:
		$GamepadInfo.text = "Gamepad: mouse/touch"
		var foc = get_focus_owner()
		if foc:
			foc.release_focus()

func menu_is_active():
	#see if whatever has focus is part of our menu
	#quirk of godot input is that mouse interaction will give a button focus
	var foc = get_focus_owner()
	if menus.has(current_menu) && (foc):
		if menus[current_menu].has(foc):
			return true
	return false
	
func add_menu(id, buttons:Array, selected = 0):
	if buttons.size() <= 0:
		print("EMPTY ARRAY PASSED TO GAMEPADMENU!")
		return
	if menus.has(id):
		return
	else:
		print("Adding %d buttons for %s" % [buttons.size(),id])
	menus[id] = buttons
	menu_cursor[id] = selected
	activate_top_menu()

func refresh_menu(id, buttons:Array, selected = 0):
	if menus.has(id):
		menus[id] = buttons
		menu_cursor[id] = selected
		activate_top_menu()

func remove_menu(id):
	if menus.erase(id):
		print("Removed menu for %s" % id)
	menu_cursor.erase(id)
	activate_top_menu()

func reset_menus():
	menus.clear()
	menu_cursor.clear()
	activate_top_menu()

func get_cursor(id):
	if menu_cursor.has(id): return menu_cursor[id]
	return 0

func activate_top_menu():
	if menus.keys().size() > 0:
		current_menu = menus.keys().back()
		grab_focus()

func release_focus():
	if menus.size() > 0:
		if Input.get_connected_joypads().size() > 0:
			if menus[current_menu][menu_cursor[current_menu]].has_method("release_focus"):
				menus[current_menu][menu_cursor[current_menu]].release_focus()

func grab_focus():
	if menus.size() > 0:
		if Input.get_connected_joypads().size() > 0:
			if menus[current_menu][menu_cursor[current_menu]].has_method("grab_focus"):
				menus[current_menu][menu_cursor[current_menu]].grab_focus()

func focus_next():
	if menus.size() > 0:
		release_focus()
		menu_cursor[current_menu] += 1
		if menu_cursor[current_menu] >= menus[current_menu].size():
			menu_cursor[current_menu] = 0
		grab_focus()

func focus_previous():
	if menus.size() > 0:
		release_focus()
		menu_cursor[current_menu] -= 1
		if menu_cursor[current_menu] < 0:
			menu_cursor[current_menu] = menus[current_menu].size() - 1
		grab_focus()

func select_current():
	if menus.size() > 0:
		if Input.get_connected_joypads().size() > 0:
			if menus[current_menu][menu_cursor[current_menu]].has_method("select"):
				menus[current_menu][menu_cursor[current_menu]].select()

func type_disable_lr():
	if menus.size() > 0:
		if Input.get_connected_joypads().size() > 0:
			return (menus[current_menu][menu_cursor[current_menu]] is HSlider)
	return false # let it through

func _process(_delta):
	if Input.is_action_just_pressed("ui_left") && !type_disable_lr() || Input.is_action_just_pressed("ui_up"):
		focus_previous()
	elif Input.is_action_just_pressed("ui_right") && !type_disable_lr() || Input.is_action_just_pressed("ui_down"):
		focus_next()
	if Input.is_action_just_pressed("ui_accept"):
		select_current()
