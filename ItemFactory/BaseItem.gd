# BaseItem.gd
class_name BaseItem
extends Node

# Base Vars
var NameGenerator


# Initialize
func _ready():
	NameGenerator = WordGenerator

func _generate(_seed:int = randi()):
	return _build_item_data(_seed)
	
func _build_item_data(_seed:int, _name:String = "Generic Item"):
	var item = {
		"Seed":_seed,
		"Name":NameGenerator.Create(_seed),
		"Type":ItemFactory.ItemTypes.BASE
	}
	return item
