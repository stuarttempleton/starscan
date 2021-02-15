extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal ChoiceSelected(int_choice)

var Texts = {
	"Greeting":"[b]Greetings, Nomad![/b]\r\nYou have been selected... etc....\r\n\r\nREFUEL and BEGIN your journey.",
	"Lose":"You lose, Nomad.",
	"Win":"You win, Nomad."
}

var buttons = []
var messageNodes = []
var display_speed = 0.5

func _ready():
	buttons = [
		$GameNarrativeDisplay2/HBoxContainer/Button1,
		$GameNarrativeDisplay2/HBoxContainer/Button2,
		$GameNarrativeDisplay2/HBoxContainer/Button3,
		$GameNarrativeDisplay2/HBoxContainer/Button4,
	]
	messageNodes = [
		$GameNarrativeDisplay2
	]
	SetMessageNodeVisibility(false)
	#DisplayText("[b]Hello![/b]\r\nHow ya doin?", ["OK"])


func SetMessageNodeVisibility(newState):
	for node in messageNodes:
		print("Setting visibility on ", node.name)
		node.visible = newState
	GameController.EnableDisableMovement(!newState)


func DisplayText(txt, array_buttons):
	print("Displaying: ", txt)
	var message = txt if not Texts.has(txt) else Texts[txt]
	
	if array_buttons.size() > buttons.size():
		print("TOO MANY OPTIONS SENT! ONLY USING %d", buttons.size())
	$GameNarrativeDisplay2/Message.bbcode_text = message
	SetMessageNodeVisibility(true)
	$GameNarrativeDisplay2/Message.percent_visible = 0
	
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
	if($GameNarrativeDisplay2/Message.percent_visible > 0.9):
		$GameNarrativeDisplay2/Message.percent_visible = 1
	else:
		$GameNarrativeDisplay2/Message.percent_visible += display_speed * delta


func CancelDialog():
	CloseWithPress(-1)

func CloseWithPress(int_button):
	SetMessageNodeVisibility(false)
	emit_signal("ChoiceSelected", int_button)


func _on_Button1_pressed():
	CloseWithPress(0)


func _on_Button2_pressed():
	CloseWithPress(1)


func _on_Button3_pressed():
	CloseWithPress(2)


func _on_Button4_pressed():
	CloseWithPress(3)
