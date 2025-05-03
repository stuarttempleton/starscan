extends Node
class_name ArtifactDescriptorGenerator

var prefixes = [
	"Ancient", "Lost", "Forgotten", "Cursed", "Mystic",
	"Shattered", "Hallowed", "Obscured", "Sacred", "Veiled",
	"Primordial", "Twisted", "Haunted", "Eternal", "Forbidden"
]

var connectors = [
	"Tome", "Idol", "Stone", "Relic", "Orb",
	"Sigil", "Totem", "Scroll", "Amulet", "Mask",
	"Fossil", "Lens", "Shard", "Core", "Monolith"
]


var rarity_descriptors = {
	"common": [
		"Cracked", "Dusty", "Simple", "Worn", "Faded", "Chipped", "Ordinary", "Plain", "Brittle"
	],
	"uncommon": [
		"Gleaming", "Marked", "Refined", "Polished", "Etched", "Tempered", "Familiar", "Preserved", "Notched"
	],
	"rare": [
		"Radiant", "Enigmatic", "Runed", "Mystic", "Ancient", "Infused", "Bound", "Hidden", "Exquisite"
	],
	"epic": [
		"Arcane", "Eldritch", "Resplendent", "Otherworldly", "Shimmering", "Cursed", "Primal", "Runescribed", "Sealed"
	],
	"legendary": [
		"Mythical", "Transcendent", "Unfathomable", "Timeless", "Celestial", "Singular", "Voidtouched", "Forbidden", "Divine"
	]
}


var rarity_colors = {
	"common": "#FFFFFF",
	"uncommon": "#90EE90",
	"rare": "#00BFFF",
	"epic": "#EE82EE",
	"legendary": "#FFD700"
}


func create_name(_seed: int, _opts = {}) -> String:
	var rng = RandomNumberGenerator.new()
	rng.seed = _seed
	
	var rarity := "common"
	if _opts.has("rarity"):
		rarity = _opts["rarity"].name
	
	var rarity_pool = rarity_descriptors[rarity] if rarity_descriptors.has(rarity) else rarity_descriptors["common"]
	var rarity_color = rarity_colors[rarity] if rarity_colors.has(rarity) else "#FFFFFF"
	
	var rarity_word = rarity_pool[rng.randi() % rarity_pool.size()]
	var prefix = prefixes[rng.randi() % prefixes.size()]
	var connector = connectors[rng.randi() % connectors.size()]
	var culture_word = WordGenerator.Create(rng.randi(), _opts["language_data"]).capitalize()
	
	var name = "The %s %s %s of %s" % [rarity_word, prefix, connector, culture_word]
	return "[color=%s]%s[/color]" % [rarity_color, name]
