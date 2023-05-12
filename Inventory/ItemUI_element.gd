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
			$ItemButtons/Button.text = "Turn In"
		CONTEXT.DESTROY, _:
			$ItemButtons/Button.text = "Discard"

func _on_Button_pressed():
	match context:
		CONTEXT.TURN_IN:
			AudioPlayer.PlaySFX(AudioPlayer.AUDIO_KEY.CARGO_TURN_IN)
			ShipData.TurnInArtifactsBySeed(Seed)
		CONTEXT.DESTROY, _:
			AudioPlayer.PlaySFX(AudioPlayer.AUDIO_KEY.CARGO_DESTROY)
			RemoveItemFromCargo()
	queue_free()
