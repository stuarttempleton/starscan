extends Node

var RarityColor = {
	"Rare": "[color=#FFBF00]%s[/color]",
	"Common": "[color=#3261c7]%s[/color]"
}

var Patterns = {
	"Rare": ["%name's %Noun", "%Noun of %name", "The %name %Noun", "%name %Noun"],
	"Common": [
		"A %adjective %noun",
		"A %adjective, %appearance %noun",
		"A %size %noun",
		"A %color %noun",
		"A %appearance %noun",
		"A %appearance %color %noun",
		"A %size %color %noun",
		"A %size %adjective %noun",
		"A %size %adjective %color %noun"]
}
var Words = {
	"%noun":["hammer", "book", "data cube", "obelisk"],
	"%color":[
		"aqua",
		"aquamarine",
		"azure",
		"beige",
		"black",
		"blue",
		"brown",
		"chartreuse",
		"crimson",
		"cyan",
		"fuchsia",
		"gold",
		"gray",
		"green",
		"hot pink",
		"indigo",
		"khaki",
		"lavender",
		"lime green",
		"magenta",
		"maroon",
		"midnight blue",
		"navy blue",
		"olive drab",
		"orange",
		"pink",
		"purple",
		"red",
		"sea green",
		"turquoise",
		"violet",
		"white",
		"yellow"
	],
	"%appearance":[
		"beaming",
		"bold",
		"bright",
		"brilliant",
		"colorful",
		"deep",
		"delicate",
		"electric",
		"festive",
		"fiery",
		"flamboyant",
		"glistening",
		"glowing",
		"iridescent",
		"opalescent",
		"prismatic",
		"radiant",
		"sepia",
		"vibrant",
		"vivid",
		"ashy",
		"bleak",
		"blotchy",
		"brash",
		"chintzy",
		"cold",
		"dark",
		"dim",
		"discolered",
		"drab",
		"harsh",
		"muddy",
		"opaque",
		"gaudy",
		"sooty",
		"stained",
		"faded",
		"flecked",
		"light",
		"monochromatic",
		"monotone",
		"muted",
		"neutral",
		"pale",
		"rustic",
		"tinged",
		"tinted",
		"translucent",
		"transparent"
	],
	"%size":[
		"large",
		"enormous",
		"giant",
		"gigantic",
		"grand",
		"huge",
		"immense",
		"massive",
		"wide",
		"colossal",
		"monumental",
		"small",
		"meager",
		"miniature",
		"miniscule",
		"little",
		"mini",
		"petite",
		"trifling",
		"modest",
		"undersized",
		"understated"
	],
	"%adjective": [
		"old",
		"ancient",
		"modern",
		"futuristic",
		"broken",
		"busted",
		"rusted",
		"decaying",
		"delapidated",
		"decadent",
		"dingy",
		"ruined",
		"ravaged",
		"decrepit",
		"battered",
		"flawed",
		"blemished"
	],
	"%adjective-tech": [
		"whirring",
		"buzzing",
		"humming",
		"beeping",
		"hovering",
		"floating",
		"pulsating",
		"ticking",
		"functional",
		"dynamic",
		"working",
		"flashing",
		"blinking"
	]
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
	var item = ExpandPattern( Patterns[rarity][NewRand(Patterns[rarity].size())])
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
