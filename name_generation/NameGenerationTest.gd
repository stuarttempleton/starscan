extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var WordGeneratorNodePath = ""
var WordGenerator
# Called when the node enters the scene tree for the first time.
func _ready():
	WordGenerator = get_node(WordGeneratorNodePath)
	pass # Replace with function body.


func _on_Button_pressed():
	var SystemName = WordGenerator.CreateWord().to_upper()
	var PlanetList = ""
	var planet_qty = WordGenerator.NewRand(8) + 1
	var i = 1
	for w in WordGenerator.CreateWordList(planet_qty):
		PlanetList += "%d. %s\r\n" % [i, w.capitalize()]
		i += 1
	$VBoxContainer/Name.text = SystemName
	$VBoxContainer/Quote.text = PlanetList
