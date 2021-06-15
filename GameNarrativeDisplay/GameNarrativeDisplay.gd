extends CanvasLayer


signal ChoiceSelected(int_choice)

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
		$MessageBoxUI/HBoxContainer/Button1,
		$MessageBoxUI/HBoxContainer/Button2,
		$MessageBoxUI/HBoxContainer/Button3,
		$MessageBoxUI/HBoxContainer/Button4,
	]
	messageNodes = [
		$MessageBoxUI
	]
	SetMessageNodeVisibility(false)
#	var txt = "[b]A surface encounter...[/b]\r\n\r\n"
#	txt += "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. "
#	txt += "\r\n\r\n"
#	txt += "[indent][code]"
#	txt += "[color=#00ff00]You found 1 artifact.[/color]\r\n"
#	txt += "[color=#00ff00]You gained 1 fuel.[/color]\r\n"
#	txt += "[color=#ff0000]You lost 10 resources.[/color]\r\n"
#	txt += "[color=#ff0000]You lost half your crew (42 souls).[/color]\r\n"
#	txt += "[/code][/indent]"
#	DisplayText(txt, ["OK", "Space Port"])


func SetMessageNodeVisibility(newState):
	for node in messageNodes:
		node.visible = newState
	GameController.EnableMovement(!newState)


func DisplayText(txt, array_buttons):
	var message = txt if not Texts.has(txt) else Texts[txt]
	
	if array_buttons.size() > buttons.size():
		print("TOO MANY OPTIONS SENT! ONLY USING %d", buttons.size())
	$MessageBoxUI/Message.bbcode_text = message
	SetMessageNodeVisibility(true)
	$MessageBoxUI/Message.percent_visible = 0
	
	for btn in buttons:
		btn.visible = false
	
	var i = 0
	for btn in array_buttons:
		buttons[i].visible = true
		buttons[i].text = btn
		i += 1
		if ( i == buttons.size() ):
			break
	pass

func _process(delta):
	if($MessageBoxUI/Message.percent_visible > 0.9):
		$MessageBoxUI/Message.percent_visible = 1
	else:
		$MessageBoxUI/Message.percent_visible += display_speed * delta


func CancelDialog():
	CloseWithPress(-1)

func CloseWithPress(int_button):
	SetMessageNodeVisibility(false)
	emit_signal("ChoiceSelected", int_button)


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
