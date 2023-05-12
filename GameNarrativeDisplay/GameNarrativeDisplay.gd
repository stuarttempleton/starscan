extends CanvasLayer


signal ChoiceSelected(int_choice)
signal DisplayState(bool_OnOff)

var Texts = {
	"Greeting":"[b]Greetings, Nomad![/b]\r\nYou have been selected... etc....\r\n\r\nREFUEL and BEGIN your journey.",
	"Lose":"[b]You lose, Nomad.[/b]\r\nYour entire crew got Space Dysentery. I hope you're happy with what you've done.",
	"Win":"[b]You win, Nomad.[/b]\r\nYou have delivered all of the artifacts to the fancy scientists.",
	"LowFuel":"[b]Greetings, Nomad![/b]\r\nYou have been selected... etc....\r\n\r\nREFUEL and BEGIN your journey.",
	"Restart":"[center][b]Restart game?[/b]\r\nThis will delete your current progress.",
	"Exit":"[center][b]Exit game?[/b]\r\nThis will save your current progress and exit the game.",
	"ReturnToMenu":"[center][b]Return to the main menu?[/b]\r\nThis will save your current progress and return to the main menu.",
	"RegenerateUniverse":"[center][b]Start a New Game?[/b]\r\nThis will delete any current progress and start an entirely new game."
}

var buttons = []
var messageNodes = []
var display_speed = 1.5

func _ready():
	buttons = [
		$MessageBoxUI/Vbox/ButtonPanel/HBoxContainer/Button1,
		$MessageBoxUI/Vbox/ButtonPanel/HBoxContainer/Button2,
		$MessageBoxUI/Vbox/ButtonPanel/HBoxContainer/Button3,
		$MessageBoxUI/Vbox/ButtonPanel/HBoxContainer/Button4,
	]
	messageNodes = [
		$MessageBoxUI
	]
	SetMessageNodeVisibility(false)


func SetMessageNodeVisibility(newState):
	for node in messageNodes:
		node.visible = newState


func DisplayText(txt, array_buttons, button_selected = 0):
	emit_signal("DisplayState", true)
	GameController.EnableMovement(false)
	var message = txt if not Texts.has(txt) else Texts[txt]
	
	# Search message of artifact ids to render
	var filtered_message = ""
	var item_ids = []
	var context = ItemUI_element.CONTEXT.DESTROY
	for w in message.split(" "):
		if w.substr(0,4) == "[id=":
			var id = w.substr(4,w.length()-1).to_int()
			item_ids.append(id)
		elif w.substr(0,9) == "[context=":
			context = w.substr(9,w.length()-1).to_int()
		else:
			filtered_message += "%s " % w
	
	$MessageBoxUI/Vbox/Panel/Vbox/Scroll/ItemList.ClearList()
	
	for id in item_ids:
		$MessageBoxUI/Vbox/Panel/Vbox/Scroll/ItemList.LoadItem(ItemFactory.GenerateItem(ItemFactory.ItemTypes.ARTIFACT, id), context)
	
	if array_buttons.size() > buttons.size():
		print("TOO MANY OPTIONS SENT! ONLY USING %d", buttons.size())
	$MessageBoxUI/Vbox/Panel/Vbox/Message.bbcode_text = filtered_message
	SetMessageNodeVisibility(true)
	$MessageBoxUI/Vbox/Panel/Vbox/Message.percent_visible = 0
	for btn in buttons:
		btn.visible = false
	
	var i = 0
	for btn in array_buttons:
		buttons[i].visible = true
		buttons[i].text = btn
		i += 1
		if ( i == buttons.size() ):
			break
	GamepadMenu.add_menu(name,buttons.slice(0,i - 1), button_selected)
	$MessageBoxUI/Vbox/GamepadHint.dpad_visible((array_buttons.size() > 1))


func _process(delta):
	if($MessageBoxUI/Vbox/Panel/Vbox/Message.percent_visible > 0.9):
		$MessageBoxUI/Vbox/Panel/Vbox/Message.percent_visible = 1
	else:
		$MessageBoxUI/Vbox/Panel/Vbox/Message.percent_visible += display_speed * delta


func CancelDialog():
	CloseWithPress(-1)

func CloseWithPress(int_button):
	GamepadMenu.remove_menu(name)
	SetMessageNodeVisibility(false)
	GameController.EnableMovement(true)
	emit_signal("ChoiceSelected", int_button)
	emit_signal("DisplayState", false)


func _on_Button1_pressed():
	AudioPlayer.PlaySFX(AudioPlayer.AUDIO_KEY.DIALOG_SELECT)
	CloseWithPress(0)


func _on_Button2_pressed():
	AudioPlayer.PlaySFX(AudioPlayer.AUDIO_KEY.DIALOG_SELECT)
	CloseWithPress(1)


func _on_Button3_pressed():
	AudioPlayer.PlaySFX(AudioPlayer.AUDIO_KEY.DIALOG_SELECT)
	CloseWithPress(2)


func _on_Button4_pressed():
	AudioPlayer.PlaySFX(AudioPlayer.AUDIO_KEY.DIALOG_SELECT)
	CloseWithPress(3)
