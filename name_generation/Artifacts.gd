extends Node

var RarityColor = {
	"Rare": "[color=#FFBF00]%s[/color]",
	"Common": "[color=#3261c7]%s[/color]"
}

var Patterns = {
	"Rare": ["%name's %noun", "%noun of %name", "The %name %noun", "%name %noun"],
	"Common": [
		"A %adjective %noun",
		"A %size %noun",
		"A %size %color %noun",
		"A %size %adjective %noun",
		"A %size %adjective %color %noun"]
}
var Words = {
	"%noun":["hammer", "book", "data cube", "obelisk"],
	"%color":["red", "yellow", "green", "blue", "chromatic"],
	"%size":["large", "small", "giant"],
	"%adjective": [ "ancient", "broken"]
}
var Nouns = ["Hammer"]

func SwapBoilerPlate(txt, key):
	var swapped = ""
	var split = txt.split(key, true)
	for i in range(0, split.size()):
		swapped += split[i]
		if i < split.size() - 1 :
			swapped += Words[key][NewRand(Words[key].size())]
	return swapped


func ExpandPattern(pat):
	var item = pat
	item = item.replace("%name", get_parent().CreateWord().capitalize())
	for key in Words.keys():
		item = SwapBoilerPlate(item, key)
	return item

func ConvertRarityFromFloat(rarity):
	if rarity > 0.9:
		return "Rare"
	return "Common"

func Create(RarityFloat=-1, color=false):
	if RarityFloat < 0:
		RarityFloat = (NewRand(99) + 1) * 0.01
	var rarity = ConvertRarityFromFloat(RarityFloat)
	var item = ExpandPattern( Patterns[rarity][NewRand(Patterns.size())])
	if color: item = RarityColor[rarity] % [ item ]
	return item


func NewRand(_max):
	randomize()
	return randi() % _max # int(rand_range(0, _max))

func CreateList(_qty, color=false):
	var items = []
	for i in _qty:
		items.append( Create(-1, color) )
	return items
