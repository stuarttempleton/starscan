extends VBoxContainer


# Declare member variables here. Examples:
var PathToItemUI = "res://Inventory/ItemUI_element.tscn"


# List management functions
func ClearList():
	for w in get_children():
		w.queue_free()
	pass

func GetButtons():
	var buttons = []
	for w in get_children():
		buttons.append(w.find_node("Button"))
	return buttons

func LoadItem(_item, _context:int = 0):
	# Load an item UI object.
	var loaded_scene = load(PathToItemUI)
	var item = loaded_scene.instance()
	
	# Populate the item data
	item.SetItem(_item)
	item.SetContext(_context)
	
	# Add it to the list
	add_child(item)
	
	# Sort the list by custom rarity
	var items = get_children()
	items.sort_custom(self, "RaritySort")
	
	# Repopulate the new ordered list
	var i = 0
	for child in items:
		move_child(child, i)
		i += 1

func RaritySort(a, b):
	return a.Rarity > b.Rarity
	
func DiscardAllByRarity(RarityThreshold:float = 1.0):
	for item in get_children():
		if item.Rarity <= RarityThreshold:
			item.RemoveItemFromCargo()
			item.queue_free()
