extends HBoxContainer
class_name ItemUI_element

# Declare member variables here. Examples:
enum CONTEXT {DESTROY, TURN_IN}
var Seed = 0
var Rarity = 0
var context = CONTEXT.DESTROY


# Handle removing item and setting up ui
func RemoveItemFromCargo():
	ShipData.RemoveItemFromInventoryBySeed(Seed)

func SetItem(item):
	$ItemTextPanel/ItemText.bbcode_text = item.Name
	Seed = item.Seed
	Rarity = item.Rarity

func SetContext(_context:int = 0):
	context = _context
	match context:
		CONTEXT.TURN_IN:
			$ItemButtons/Button.text = "TRANSFER"
		CONTEXT.DESTROY, _:
			$ItemButtons/Button.text = "DESTROY"

func _on_Button_pressed():
	match context:
		CONTEXT.TURN_IN:
			ShipData.TurnInArtifactsBySeed(Seed)
		CONTEXT.DESTROY, _:
			RemoveItemFromCargo()
	queue_free()
