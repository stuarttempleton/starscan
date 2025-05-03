# ArtifactItem.gd
extends BaseItem

var DescriptorGenerator

# Weighted rarity probabilities
var rarity_weights = {
	"common": 60,
	"uncommon": 25,
	"rare": 10,
	"epic": 4,
	"legendary": 1
}

func _ready():
	DescriptorGenerator = ArtifactDescriptorGenerator.new()

func _generate(_seed:int = randi(), _opts = {}):
	var rng = RandomNumberGenerator.new()
	rng.seed = _seed
	
	# Pick rarity if not explicitly provided
	var rarity = _opts["rarity"] if _opts.has("rarity") else _pick_weighted_rarity(rng)
	var language_data = _opts["language_data"] if _opts.has("language_data") else null
	
	var data = _build_item_data(_seed)
	data["Name"] = DescriptorGenerator.create_name(_seed, {"rarity": rarity, "language_data": language_data})
	data["Rarity"] = rarity.value * 0.01
	data["Type"] = ItemFactory.ItemTypes.ARTIFACT
	# Add more data here, like culture, lore, etc.
	return data

func _pick_weighted_rarity(rng: RandomNumberGenerator) -> Dictionary:
	var total_weight = 0
	for weight in rarity_weights.values():
		total_weight += weight

	var roll = rng.randi_range(1, total_weight)
	var cumulative = 0

	for rarity in rarity_weights.keys():
		cumulative += rarity_weights[rarity]
		if roll <= cumulative:
			return {
				"name": rarity,
				"value": rarity_weights[rarity]
			}

	return {
		"name": "common",
		"value": rarity_weights.get("common", 0)
	}
