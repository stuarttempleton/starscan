extends Node

var RarityColor = {
	"Rare": "[color=#FFBF00]%s[/color]",
	"Common": "[color=#3261c7]%s[/color]"
}

var Patterns = {
	"Rare": ["%name's %Noun", "%Noun of %name", "The %name %Noun", "%name %Noun"],
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

func GetUpperKey(key):
	var newKey = key
	newKey[1] = newKey[1].to_upper()
	print("%s -> %s" % [key, newKey])
	return newKey

func GetLowerKey(key):
	var newKey = key
	newKey[1] = newKey[1].to_lower()
	print("%s -> %s" % [key, newKey])
	return newKey

func GetWordWithCaps(key):
	var lowKey = GetLowerKey(key)
	var word = Words[lowKey][NewRand(Words[lowKey].size())]
	if key[1] == key[1].to_upper():
		word = word.capitalize()
	return word

func SwapBoilerPlate(txt, key):
	var swapped = ""
	var split = txt.split(key, true)
	for i in range(0, split.size()):
		swapped += split[i]
		if i < split.size() - 1 :
			swapped += GetWordWithCaps(key)
	return swapped


func ExpandPattern(pat):
	var item = pat
	item = item.replace("%name", get_parent().CreateWord().capitalize())
	item = item.replace("%Name", get_parent().CreateWord().capitalize())
	for key in Words.keys():
		item = SwapBoilerPlate(item, GetUpperKey(key))
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
