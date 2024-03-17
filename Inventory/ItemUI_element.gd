extends HBoxContainer
class_name ItemUI_element

# Declare member variables here. Examples:
enum CONTEXT {NONE, DESTROY, TURN_IN}
var Seed = 0
var Rarity = 0
var context = CONTEXT.DESTROY
signal item_removed(_seed)


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
		CONTEXT.NONE:
			$ItemButtons/Button.visible = false
		CONTEXT.TURN_IN:
			$ItemButtons/Button.text = "Turn In"
		CONTEXT.DESTROY, _:
			$ItemButtons/Button.text = "Discard"

func _on_Button_pressed():
	if NeedsConfirmation():
		MessageBox.connect("ChoiceSelected", self, "ChoiceResponse")	
		MessageBox.DisplayText("[center][b]%s Item?[/b]\r\n Remove %s from your inventory?" % [$ItemButtons/Button.text, $ItemTextPanel/ItemText.bbcode_text], ["YES","NO"], 0)
	else:
		DoButtonPress()

func NeedsConfirmation():
	#todo: rarity
	return (Rarity >= 0.9)

func ChoiceResponse(choice):
	MessageBox.disconnect("ChoiceSelected", self, "ChoiceResponse")

	match choice:
		-1: return
		0: DoButtonPress()
		1: return

func DoButtonPress():
	match context:
		CONTEXT.TURN_IN:
			AudioPlayer.PlaySFX(AudioPlayer.AUDIO_KEY.CARGO_TURN_IN)
			ShipData.TurnInArtifactsBySeed(Seed)
		CONTEXT.DESTROY, _:
			AudioPlayer.PlaySFX(AudioPlayer.AUDIO_KEY.CARGO_DESTROY)
			RemoveItemFromCargo()
	emit_signal("item_removed", Seed)
	get_parent().remove_child(self)
	queue_free()
