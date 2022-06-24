extends CanvasLayer


export var in_game = true
export(Array, NodePath) var in_game_nodes
export(Array, NodePath) var title_nodes

# Called when the node enters the scene tree for the first time.
func _ready():
	set_nodes_state(in_game_nodes, in_game)
	set_nodes_state(title_nodes, !in_game)
	GamepadMenu.add_menu(name, get_active_nodes())

func _exit_tree():
	GamepadMenu.remove_menu(name)

func get_active_nodes():
	var active = []
	for node in $MenuUIContainer/Menu/Buttons.get_children():
		if node.visible:
			active.push_back(node)
	return active

func set_nodes_state(nodes, state):
	for node in nodes :
		if "RemoveFromMenu" in get_node(node) and get_node(node).RemoveFromMenu == true:
			get_node(node).visible = false
		else:
			get_node(node).visible = state
