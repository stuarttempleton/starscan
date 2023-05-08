extends Node
class_name ArtifactNameGenerator


var RarityColor = {
	"Rare": "[color=#FFBF00]%s[/color]",
	"Common": "[color=#3261c7]%s[/color]"
}
var Patterns = {
	"Rare": ["%name's %Noun", "%Noun of %name", "The %name %Noun", "%name %Noun"],
	"Common": [
		"%A|N %adjective %noun",
		"%A|N %adjective %appearance %noun",
		"%A|N %size %noun",
		"%A|N %color %noun",
		"%A|N %appearance %noun",
		"%A|N %appearance %color %noun",
		"%A|N %size %color %noun",
		"%A|N %size %adjective %noun",
		"%A|N %size %adjective %color %noun",
		"%A|N %tech-adjective %tech-noun",
		"%A|N %appearance %tech-adjective %tech-noun",
		"%A|N %size %tech-noun",
		"%A|N %color %tech-noun",
		"%A|N %appearance %tech-noun",
		"%A|N %appearance %color %tech-adjective %tech-noun",
		"%A|N %size %color %tech-noun",
		"%A|N %size %tech-adjective %tech-noun",
		"%A|N %size %color %tech-adjective %tech-noun"]
}
var Words = {
	"%noun":["hammer",
		"tool",
		"weapon",
		"sword",
		"knife",
		"shield",
		"club",
		"gun",
		"beaker",
		"flask",
		"book",
		"magazine",
		"painting",
		"sculpture",
		"etching",
		"carving",
		"scroll",
		"disc",
		"pot",
		"cup",
		"chalice",
		"bowl",
		"plate",
		"obelisk",
		"armillary sphere",
		"azimuth theodolite",
		"mechanism",
		"sundial",
		"nilometer",
		"siesmograph",
		"sextant",
		"alidade",
		"astrolabe",
		"quadrant",
		"octant",
		"monocular",
		"telescope",
		"vessel",
		"clock",
		"celestial calendar"
	],
	"%tech-noun":["device",
		"computer",
		"tablet",
		"unit",
		"cube",
		"sphere",
		"cylinder",
		"crystal",
		"unit",
		"archive",
		"record"
	],
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
	"%tech-adjective": [
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
		"blinking",
		"digital",
		"data",
		"library",
		"memory",
		"news",
		"entertainment",
		"communication"
	]
}
var Nouns = ["Hammer"]
var rng


func GetUpperKey(key):
	var newKey = key
	newKey[1] = newKey[1].to_upper()
	return newKey

func GetLowerKey(key):
	var newKey = key
	newKey[1] = newKey[1].to_lower()
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
	
func StartsWith(text, items):
	for item in items:
		if text.left(item.length()) == item:
			return true
	return false

func CorrectAAN(item):
	var split = item.split(' ')
	for i in range(0, split.size()):
		if split[i] == "%A|N":
			if StartsWith(split[i+1].to_upper(), ["EU","EW","UNI","HAI","HOR","ONCE","ONE"]):
				split[i] = "A"
			elif StartsWith(split[i+1].to_upper(), ["HOU","HONO","HEI","HIS","HAI","YV"]):
				split[i] = "AN"
			elif StartsWith(split[i+1].to_upper(), ["A","E","I","O","U"]):
				split[i] = "An"
			else:
				split[i] = "A"
	return split.join(" ")

func ExpandPattern(pat):
	var item = pat
	item = item.replace("%name", WordGenerator.Create(rng.randi()).capitalize())
	item = item.replace("%Name", WordGenerator.Create(rng.randi()).capitalize())
	for key in Words.keys():
		item = SwapBoilerPlate(item, GetUpperKey(key))
		item = SwapBoilerPlate(item, key)
	item = CorrectAAN(item)
	return item

func ConvertRarityFromFloat(rarity):
	if rarity > 0.9:
		return "Rare"
	return "Common"

func Create(_seed:int = randi(), RarityFloat=-1, color=false):
	if _seed < 0: _seed = randi()
	rng = RandomNumberGenerator.new()
	rng.seed = _seed
	
	if RarityFloat < 0:
		RarityFloat = rng.randf() #(NewRand(99) + 1) * 0.01
	var rarity = ConvertRarityFromFloat(RarityFloat)
	var item = ExpandPattern( Patterns[rarity][NewRand(Patterns[rarity].size())])
	if color: item = RarityColor[rarity] % [ item ]
	return item

func NewRand(_max):
	return rng.randi() % _max

func CreateList(_qty, color=false):
	var items = []
	for i in _qty:
		items.append( Create(-1, -1, color) )
	return items
