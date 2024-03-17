extends VBoxContainer


# Declare member variables here. Examples:
var PathToItemUI = "res://Inventory/ItemUI_element.tscn"
signal item_list_changed()
var item_length_cache = 0

func _process(delta):
	if item_length_cache != get_children().size():
		
		print("Item list changed! from %d to %d" % [item_length_cache, get_child_count()])
		item_length_cache = get_children().size()
		emit_signal("item_list_changed")
		
# List management functions
func ClearList():
	for w in get_children():
		w.queue_free()
		remove_child(w)
	pass

func GetButtons():
	var buttons = []
	for w in get_children():
		buttons.append(w.find_node("Button"))
	print("Returning %d buttons" % buttons.size())
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
