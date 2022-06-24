extends Node2D


export var menus = {}
var menu_cursor = {}
var current_menu = ""

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
	print("Removing menu for %s" % id)
	menus.erase(id)
	menu_cursor.erase(id)
	activate_top_menu()

func reset_menus():
	menus.clear()
	menu_cursor.clear()
	activate_top_menu()

func activate_top_menu():
	if menus.keys().size() > 0:
		current_menu = menus.keys().back()
		grab_focus()

func grab_focus():
	if menus.size() > 0:
		menus[current_menu][menu_cursor[current_menu]].grab_focus()

func focus_next():
	menu_cursor[current_menu] += 1
	if menu_cursor[current_menu] >= menus[current_menu].size():
		menu_cursor[current_menu] = 0
	grab_focus()

func focus_previous():
	menu_cursor[current_menu] -= 1
	if menu_cursor[current_menu] < 0:
		menu_cursor[current_menu] = menus[current_menu].size() - 1
	grab_focus()


func _process(delta):
	if Input.is_action_just_pressed("ui_left") || Input.is_action_just_pressed("ui_up"):
		focus_previous()
	elif Input.is_action_just_pressed("ui_right") || Input.is_action_just_pressed("ui_down"):
		focus_next()
